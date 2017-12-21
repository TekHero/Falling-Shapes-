//
//  GameoverScene.swift
//  Falling Shapes!
//
//  Created by Brian Lim on 5/21/16.
//  Copyright © 2016 codebluapps. All rights reserved.
//

import SpriteKit
import GameKit
import UIKit

extension UIView {
    
    func pb_takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
        
        drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        
        // old style: layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

class GameoverScene: SKScene, GKGameCenterControllerDelegate {
    
    var leaderboardBtn = SKSpriteNode()
    var soundBtn = SKSpriteNode()
    var rateBtn = SKSpriteNode()
    var shareBtn = SKSpriteNode()
    var homeBtn = SKSpriteNode()
    var retryBtn = SKSpriteNode()
    var scoreBox = SKSpriteNode()
    
    var titleLbl = SKLabelNode()
    var scoreLbl = SKLabelNode()
    var recordScoreLbl = SKLabelNode()
    var scoreTxtLbl = SKLabelNode()
    var recordScoreTxtLbl = SKLabelNode()
    
    var activityViewController: UIActivityViewController?
    
    var userScore = 0
    var userHighscore = 0
    
    var shouldAnimate = false
    
    override func didMoveToView(view: SKView) {
        adShown += 1
        
        checkScore()
        initialize()
        
        if soundOn == true {
            
            soundBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "MusicOnBtn")))
        } else {
            
            soundBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "MusicOffBtn")))
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("showInterstitialKey", object: nil)
        
    }
    
    func checkScore() {
        
        // Checking to see if there is a integer for the key "SCORE"
        if let score: Int = NSUserDefaults.standardUserDefaults().integerForKey("SCORE") {
            userScore = score
            
            // Checking to see if there if a integer for the key "HIGHSCORE"
            if let highscore: Int = NSUserDefaults.standardUserDefaults().integerForKey("HIGHSCORE") {
                
                // If there is, check if the current score is greater then the value of the current highscore
                if score > highscore {
                    // If it is, set the current score as the new high score
                    GameManager.instance.setHighscore(score)
                    userHighscore = score
                    saveHighscore(score)
                    shouldAnimate = true
                    
                } else {
                    // Score is not greater then highscore
                }
            } else {
                // There is no integer for the key "HIGHSCORE"
                // Set the current score as the highscore since there is no value for highscore yet
                GameManager.instance.setHighscore(score)
                userHighscore = score
                saveHighscore(score)
                shouldAnimate = true
                
            }
        }
        
        // Checking to see if there a integer for the key "HIGHSCORE"
        if let highscore: Int = NSUserDefaults.standardUserDefaults().integerForKey("HIGHSCORE") {
            // If so, then set the value of this key to the userHighscore variable
            userHighscore = highscore
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.locationInNode(self)
            
            if nodeAtPoint(location) == retryBtn {
                
                retryBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "RetryBtnDown")))
            }
            
            if nodeAtPoint(location) == homeBtn {
                
                homeBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "BigHomeBtnDown")))

            }
            
            if nodeAtPoint(location).name == "Leaderboard" {
                
                leaderboardBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "HighscoreBtnDown")))
            }
            
            if nodeAtPoint(location).name == "Sound" {
                
                soundBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "MusicOnBtnDown")))
            }
            
            if nodeAtPoint(location).name == "Rate" {
                
                rateBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "RateBtnDown")))
            }
            
            if nodeAtPoint(location).name == "Share" {
                
                shareBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "ShareBtnDown")))
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.locationInNode(self)
            
            if nodeAtPoint(location) != homeBtn {
                
                homeBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "BigHomeBtn")))

            }
            
            if nodeAtPoint(location) != retryBtn {
                
                retryBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "RetryBtn")))
            }
            
            if nodeAtPoint(location).name != "Leaderboard" {
                
                leaderboardBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "HighscoreBtn")))
                
            }
            
            if nodeAtPoint(location).name != "Sound" {
                
                soundBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "MusicOnBtn")))
                
            }
            
            if nodeAtPoint(location).name != "Rate" {
                
                rateBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "RateBtn")))
                
            }
            
            if nodeAtPoint(location).name != "Share" {
                
                shareBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "ShareBtn")))
                
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.locationInNode(self)
            
            if nodeAtPoint(location) == retryBtn {
                
                retryBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "RetryBtn")))
                playClickSound1()
                
                let gameplay = GameplayScene(fileNamed: "GameplayScene")
                gameplay?.scaleMode = .AspectFill
                self.view?.presentScene(gameplay!, transition: SKTransition.fadeWithDuration(0.5))
                
                self.removeAllActions()
                self.removeAllChildren()
            }
            
            if nodeAtPoint(location) == homeBtn {
                
                homeBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "BigHomeBtn")))
                playClickSound1()
                
                let mainMenu = MainMenuScene(fileNamed: "MainMenuScene")
                mainMenu?.scaleMode = .AspectFill
                self.view?.presentScene(mainMenu!, transition: SKTransition.fadeWithDuration(0.5))
                
                self.removeAllActions()
                self.removeAllChildren()
            }
            
            if nodeAtPoint(location).name == "Leaderboard" {
                
                leaderboardBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "HighscoreBtn")))
                playClickSound1()
                leaderboardBtnPressed()
            }
            
            if nodeAtPoint(location).name == "Sound" {
                
                soundBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "MusicOnBtn")))
                playClickSound1()
                soundBtnPressed()
            }
            
            if nodeAtPoint(location).name == "Rate" {
                
                rateBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "RateBtn")))
                playClickSound1()
                rateBtnPressed()
            }
            
            if nodeAtPoint(location).name == "Share" {
                
                shareBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "ShareBtn")))
                playClickSound1()
                delayShare()
            }
        }
    }
    
    func delayShare() {
        
        let wait = SKAction.waitForDuration(0.2)
        let run = SKAction.runBlock {
            
            self.socialShare("I just got a score of \(self.userScore) in Droppy Shapes!", sharingURL: NSURL(string: "https://itunes.apple.com/us/app/droppy-shapes!/id1116813676?ls=1&mt=8"))
        }
        
        let sequence = SKAction.sequence([wait, run])
        self.runAction(sequence)
    }
    
    func initialize() {
        
        createSoundBtn()
        createRateBtn()
        createTutorialBtn()
        createLeaderboardBtn()
        createHomeBtn()
        createRetryBtn()
        createScoreBox()
        createTitleLbl()
        createScoreLabels()
        createScoreTxtLabels()
        rotateSprite()
    }
    
    func createScoreTxtLabels() {
        
        scoreTxtLbl = SKLabelNode(fontNamed: "Prototype")
        scoreTxtLbl.fontSize = 70
        scoreTxtLbl.zPosition = 3
        scoreTxtLbl.horizontalAlignmentMode = .Left
//        scoreTxtLbl.text = "\(userScore)"
        scoreTxtLbl.text = "26"
        scoreTxtLbl.position = CGPoint(x: 20, y: 180)
        
        
        recordScoreTxtLbl = SKLabelNode(fontNamed: "Prototype")
        recordScoreTxtLbl.fontSize = 70
        recordScoreTxtLbl.zPosition = 3
        recordScoreTxtLbl.horizontalAlignmentMode = .Left
//        recordScoreTxtLbl.text = "\(userHighscore)"
        recordScoreTxtLbl.text = "92"
        recordScoreTxtLbl.position = CGPoint(x: 20, y: 30)
        if shouldAnimate == true {
            let fadeOut = SKAction.fadeAlphaTo(0.0, duration: 0.5)
            let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 0.5)
            recordScoreTxtLbl.runAction(SKAction.repeatActionForever(SKAction.sequence([fadeOut, fadeIn])))
        }
        
        self.addChild(scoreTxtLbl)
        self.addChild(recordScoreTxtLbl)
    }
    
    func createScoreLabels() {
        
        scoreLbl = SKLabelNode(fontNamed: "Prototype")
        scoreLbl.fontSize = 60
        scoreLbl.zPosition = 3
        scoreLbl.horizontalAlignmentMode = .Left
        scoreLbl.text = "SCORE"
        scoreLbl.position = CGPoint(x: -380, y: 180)
        
        recordScoreLbl = SKLabelNode(fontNamed: "Prototype")
        recordScoreLbl.fontSize = 60
        recordScoreLbl.zPosition = 3
        recordScoreLbl.horizontalAlignmentMode = .Left
        recordScoreLbl.text = "RECORD"
        recordScoreLbl.fontColor = SKColor(red: 80.0 / 255.0, green: 227.0 / 255.0, blue: 194.0 / 255.0, alpha: 1.0)
        recordScoreLbl.position = CGPoint(x: -380, y: 30)
        if shouldAnimate == true {
            let fadeOut = SKAction.fadeAlphaTo(0.0, duration: 0.5)
            let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 0.5)
            recordScoreLbl.runAction(SKAction.repeatActionForever(SKAction.sequence([fadeOut, fadeIn])))
        }
        
        self.addChild(scoreLbl)
        self.addChild(recordScoreLbl)
    }
    
    func createTitleLbl() {
        
        titleLbl = SKLabelNode(fontNamed: "Prototype")
        titleLbl.fontSize = 150
        titleLbl.zPosition = 2
        titleLbl.text = "GAMEOVER!"
        titleLbl.position = CGPoint(x: 0, y: 350)
        
        let moveLeft = SKAction.moveToX(-30, duration: 0.7)
        let moveRight = SKAction.moveToX(30, duration: 0.7)
        let sequence = SKAction.sequence([moveLeft, moveRight])
        
        titleLbl.runAction(SKAction.repeatActionForever(sequence))
        
        self.addChild(titleLbl)
    }
    
    func createScoreBox() {
        
        scoreBox = SKSpriteNode(imageNamed: "ScoreBox")
        scoreBox.name = "ScoreBox"
        scoreBox.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scoreBox.zPosition = 2
        scoreBox.size = CGSize(width: 850, height: 350)
        scoreBox.position = CGPoint(x: 0, y: 100)
        
        self.addChild(scoreBox)
    }
    
    func createHomeBtn() {
        
        homeBtn = SKSpriteNode(imageNamed: "BigHomeBtn")
        homeBtn.name = "Home"
        homeBtn.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        homeBtn.zPosition = 2
        homeBtn.size = CGSize(width: 350, height: 130)
        homeBtn.position = CGPoint(x: -250, y: -200)
        
        self.addChild(homeBtn)
    }
    
    func createRetryBtn() {
        
        retryBtn = SKSpriteNode(imageNamed: "RetryBtn")
        retryBtn.name = "Retry"
        retryBtn.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        retryBtn.zPosition = 2
        retryBtn.size = CGSize(width: 350, height: 130)
        retryBtn.position = CGPoint(x: 250, y: -200)
        
        let scaleUp = SKAction.scaleTo(1.1, duration: 0.5)
        let scaleDown = SKAction.scaleTo(1.0, duration: 0.5)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        
        retryBtn.runAction(SKAction.repeatActionForever(sequence))
        
        self.addChild(retryBtn)
    }
    
    func createLeaderboardBtn() {
        
        leaderboardBtn = SKSpriteNode(imageNamed: "HighscoreBtn")
        leaderboardBtn.size = CGSize(width: 150, height: 150)
        leaderboardBtn.name = "Leaderboard"
        leaderboardBtn.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        leaderboardBtn.position = CGPoint(x: -410, y: -400)
        leaderboardBtn.zPosition = 2
        
        self.addChild(leaderboardBtn)
        
    }
    
    func createSoundBtn() {
        
        soundBtn = SKSpriteNode(imageNamed: "MusicOnBtn")
        soundBtn.size = CGSize(width: 150, height: 150)
        soundBtn.name = "Sound"
        soundBtn.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        soundBtn.position = CGPoint(x: -130, y: -400)
        soundBtn.zPosition = 2
        
        self.addChild(soundBtn)
    }
    
    func createRateBtn() {
        
        rateBtn = SKSpriteNode(imageNamed: "RateBtn")
        rateBtn.size = CGSize(width: 150, height: 150)
        rateBtn.name = "Rate"
        rateBtn.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        rateBtn.position = CGPoint(x: 130, y: -400)
        rateBtn.zPosition = 2
        
        self.addChild(rateBtn)
    }
    
    func createTutorialBtn() {
        
        shareBtn = SKSpriteNode(imageNamed: "ShareBtn")
        shareBtn.size = CGSize(width: 150, height: 150)
        shareBtn.name = "Share"
        shareBtn.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        shareBtn.position = CGPoint(x: 410, y: -400)
        shareBtn.zPosition = 2
        
        self.addChild(shareBtn)
    }
    
    func playClickSound1() {
        
        let play = SKAction.playSoundFileNamed("ButtonClickSound", waitForCompletion: false)
        if soundOn == true {
            self.runAction(play)
        }
    }
    
    func soundBtnPressed() {
        if soundOn == true {
            soundBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "MusicOffBtn")))
            soundOn = false
            // Sound is OFF
        } else {
            soundBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "MusicOnBtn")))
            soundOn = true
            // Sound is ON
        }
    }
    
    func rotateSprite() {
        let rotate = SKAction.rotateByAngle(1.5, duration: 0.6)
        let rotate2 = SKAction.rotateByAngle(-1.5, duration: 0.6)
        leaderboardBtn.runAction(SKAction.repeatActionForever(rotate))
        soundBtn.runAction(SKAction.repeatActionForever(rotate2))
        rateBtn.runAction(SKAction.repeatActionForever(rotate))
        shareBtn.runAction(SKAction.repeatActionForever(rotate2))
        
    }
    
    func rateBtnPressed() {
        UIApplication.sharedApplication().openURL(NSURL(string: "itms-apps://itunes.apple.com/app/id1116813676")!)
    }
    
    func shareBtnPressed() {
        
        let screenshot = self.view?.pb_takeSnapshot()
        UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
        
        let activityViewController = UIActivityViewController(activityItems: [screenshot!], applicationActivities: nil)
        self.view?.window?.rootViewController?.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func socialShare(sharingText: String?, sharingURL: NSURL?) {
        var sharingItems = [AnyObject]()
        
        let screenshot = self.view?.pb_takeSnapshot()
        UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
        
        if let text = sharingText {
            sharingItems.append(text)
        }
        if let image = screenshot {
            sharingItems.append(image)
        }
        if let url = sharingURL {
            sharingItems.append(url)
        }
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypeAddToReadingList,UIActivityTypeAssignToContact,UIActivityTypePostToTencentWeibo,UIActivityTypePostToVimeo,UIActivityTypePrint,UIActivityTypePostToWeibo, UIActivityTypeSaveToCameraRoll, UIActivityTypeMessage]
        
        
        self.view?.window?.rootViewController?.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func leaderboardBtnPressed() {
        let gcVC: GKGameCenterViewController = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = GKGameCenterViewControllerState.Leaderboards
        gcVC.leaderboardIdentifier = "DroppyShapesLeaderboard_05"
        self.view?.window?.rootViewController?.presentViewController(gcVC, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //send high score to leaderboard
    func saveHighscore(score:Int) {
        
        //check if user is signed in
        if GKLocalPlayer.localPlayer().authenticated {
            
            let scoreReporter = GKScore(leaderboardIdentifier: "DroppyShapesLeaderboard_05") //leaderboard id here
            
            scoreReporter.value = Int64(score) //score variable here (same as above)
            
            let scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.reportScores(scoreArray, withCompletionHandler: {(error : NSError?) -> Void in
                if error != nil {
                    // error
                }
            })
            
        }
        
        
    }
    
}

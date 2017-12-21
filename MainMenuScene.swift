//
//  MainMenuScene.swift
//  Falling Shapes!
//
//  Created by Brian Lim on 5/14/16.
//  Copyright © 2016 codebluapps. All rights reserved.
//

import SpriteKit
import GameKit

class MainMenuScene: SKScene, GKGameCenterControllerDelegate {
    
    var title = SKLabelNode()
    var playBtn = SKSpriteNode()
    var leaderboardBtn = SKSpriteNode()
    var soundBtn = SKSpriteNode()
    var rateBtn = SKSpriteNode()
    var tutorialBtn = SKSpriteNode()
    
    var shapes = [SKSpriteNode]()
    
    override func didMoveToView(view: SKView) {
        adShown += 1
        
        waitBeforeShowingAd()
        
        initialize()
        
        if soundOn == true {
            
            soundBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "MusicOnBtn")))
        } else {
            
            soundBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "MusicOffBtn")))
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.locationInNode(self)
            
            if nodeAtPoint(location).name == "Play" {
                
                playBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "PlayBtnDown2")))
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
            
            if nodeAtPoint(location).name == "Tutorial" {
                
                tutorialBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "HowToPlayBtnDown")))
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.locationInNode(self)
            
            if nodeAtPoint(location).name == "Play" {
                
                playClickSound1()
                playBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "PlayBtn")))
                
                let gameplay = GameplayScene(fileNamed: "GameplayScene")
                gameplay?.scaleMode = .AspectFill
                self.view?.presentScene(gameplay!, transition: SKTransition.fadeWithDuration(0.5))
                
                self.removeAllActions()
                self.removeAllChildren()
                self.removeActionForKey("Spawn")
                
            }
            
            if nodeAtPoint(location).name == "Leaderboard" {
                
                leaderboardBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "HighscoreBtn")))
                playClickSound1()
                leaderboardBtnPressed()
            }
            
            if nodeAtPoint(location).name == "Sound" {
                
                soundBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "MusicOnBtnDown")))
                playClickSound1()
                soundBtnPressed()
            }
            
            if nodeAtPoint(location).name == "Rate" {
                
                rateBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "RateBtn")))
                playClickSound1()
                rateBtnPressed()
            }
            
            if nodeAtPoint(location).name == "Tutorial" {
                
                tutorialBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "HowToPlayBtn")))
                playClickSound1()
                createTutorialAlertView()
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.locationInNode(self)
            
            if nodeAtPoint(location).name != "Play" {
                
                playBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "PlayBtn")))
                
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
            
            if nodeAtPoint(location).name != "Tutorial" {
                
                tutorialBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "HowToPlayBtn")))
                
            }
            
            
        }
    }
    
    func initialize() {
        authenticateLocalPlayer()
        
        createTitleLabel()
        createPlayBtn()
        createLeaderboardBtn()
        createSoundBtn()
        createRateBtn()
        createTutorialBtn()
        rotateSprite()
        createShapes()
        spawnShapes()
        
    }
    
    func spawnShapes() {
        let wait = SKAction.waitForDuration(0.3)
        let spawn = SKAction.runBlock {
            
            self.spawnObstacles()
        }
        
        let sequence = SKAction.sequence([spawn, wait])
        self.runAction(SKAction.repeatActionForever(sequence), withKey: "Spawn")
    }
    
    func createShapes() {
        
        for i in 1...4 {
            
            let shape = SKSpriteNode(imageNamed: "Shape \(i)")
            shape.size = CGSize(width: 150, height: 150)
            shape.physicsBody = SKPhysicsBody(rectangleOfSize: shape.size)
            shape.physicsBody?.affectedByGravity = false
            shape.zPosition = 1
            
            shapes.append(shape)
        }
        
    }
    
    func spawnObstacles() {
        
        let index = Int(arc4random_uniform(UInt32(shapes.count))) // Generate a random number between 0 and the amount of sprites in the array
        let shape = shapes[index].copy() as! SKSpriteNode // Store a copy of the Sprite at the index in the array into the constant
        
        // Spawn the sprite to the right of the screen and set the y position to be 50
        shape.position = CGPoint(x: GameManager.instance.randomBetweenNumbers(-800, secondNum: 800), y: self.frame.size.height + 50)
        
        let rotate = SKAction.rotateByAngle(1.5, duration: 0.6)
        let move = SKAction.moveToY(-(self.frame.size.height) / 2 - 50, duration: 2.0)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([move, remove])
        
        shape.runAction(SKAction.repeatActionForever(rotate))
        shape.runAction(sequence)
        
        self.addChild(shape)
    }
    
    func createTitleLabel() {
    
        title.fontName = "Prototype"
        title.fontSize = 120
        title.fontColor = SKColor.whiteColor()
        title.position = CGPoint(x: 0, y: 380)
        title.text = "Droppy Shapes!"
        title.zPosition = 2
        
        let moveUp = SKAction.moveToY(title.position.y + 30, duration: 1.0)
        let moveDown = SKAction.moveToY(title.position.y - 30, duration: 1.0)
        let sequence = SKAction.sequence([moveUp, moveDown])
        
        title.runAction(SKAction.repeatActionForever(sequence))
        
        self.addChild(title)
    }
    
    func createPlayBtn() {
        
        playBtn = SKSpriteNode(imageNamed: "PlayBtn")
        playBtn.size = CGSize(width: 415, height: 143)
        playBtn.name = "Play"
        playBtn.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        playBtn.position = CGPoint(x: 0, y: 0)
        playBtn.zPosition = 2
        
        let moveLeft = SKAction.moveToX(playBtn.position.x - 30, duration: 1.0)
        let moveRight = SKAction.moveToX(playBtn.position.x + 30, duration: 1.0)
        let sequence = SKAction.sequence([moveLeft, moveRight])
        
        playBtn.runAction(SKAction.repeatActionForever(sequence))
        
        self.addChild(playBtn)
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
        
        tutorialBtn = SKSpriteNode(imageNamed: "HowToPlayBtn")
        tutorialBtn.size = CGSize(width: 150, height: 150)
        tutorialBtn.name = "Tutorial"
        tutorialBtn.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        tutorialBtn.position = CGPoint(x: 410, y: -400)
        tutorialBtn.zPosition = 2
        
        self.addChild(tutorialBtn)
    }
    
    func rotateSprite() {
        let rotate = SKAction.rotateByAngle(1.5, duration: 0.6)
        let rotate2 = SKAction.rotateByAngle(-1.5, duration: 0.6)
        leaderboardBtn.runAction(SKAction.repeatActionForever(rotate))
        soundBtn.runAction(SKAction.repeatActionForever(rotate2))
        rateBtn.runAction(SKAction.repeatActionForever(rotate))
        tutorialBtn.runAction(SKAction.repeatActionForever(rotate2))

    }
    
    func playClickSound1() {
        
        let play = SKAction.playSoundFileNamed("ButtonClickSound", waitForCompletion: false)
        if soundOn == true {
            self.runAction(play)
        }
    }
    
    func rateBtnPressed() {
        UIApplication.sharedApplication().openURL(NSURL(string: "itms-apps://itunes.apple.com/app/id1116813676")!)
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
    
    func createTutorialAlertView() {
        // Drag the corresponding shapes to its matching shape slots to earn a point, If one shape is placed in its wrong slot, it is GAMEOVER.
        let alert = UIAlertController(title: "How-To-Play", message: "Drag each shape to its matching shape slot to earn a point, If one shape is placed in its wrong slot, a point is deducted & it is GAMEOVER.", preferredStyle: UIAlertControllerStyle.Alert)
        let okay = UIAlertAction(title: "Let's Play", style: UIAlertActionStyle.Default, handler: nil)
        
        alert.addAction(okay)
        
        self.view?.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func waitBeforeShowingAd() {
        let wait = SKAction.waitForDuration(2)
        let run = SKAction.runBlock {
            
            NSNotificationCenter.defaultCenter().postNotificationName("showInterstitialKey", object: nil)
        }
        let sequence = SKAction.sequence([wait, run])
        self.runAction(sequence)
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
    
    //initiate gamecenter
    func authenticateLocalPlayer(){
        
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            
            if (viewController != nil) {
                self.view?.window?.rootViewController?.presentViewController(viewController!, animated: true, completion: nil)
                
            }
                
            else {
                print((GKLocalPlayer.localPlayer().authenticated))
            }
        }
        
    }

}






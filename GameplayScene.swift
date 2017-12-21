//
//  GameplayScene.swift
//  Falling Shapes!
//
//  Created by Brian Lim on 5/14/16.
//  Copyright © 2016 codebluapps. All rights reserved.
//

import SpriteKit
import AVFoundation

extension UIScreen {
    
    enum SizeType: CGFloat {
        case Unknown = 0.0
        case iPhone4 = 960.0
        case iPhone5 = 1136.0
        case iPhone6 = 1334.0
        case iPhone6Plus = 2208.0
    }
    
    var sizeType: SizeType {
        let height = nativeBounds.height
        guard let sizeType = SizeType(rawValue: height) else { return .Unknown }
        return sizeType
    }
}

class GameplayScene: SKScene, SKPhysicsContactDelegate {
    
    var starBlock = StarBlock()
    var triangleBlock = TriangleBlock()
    var squareBlock = SquareBlock()
    var circleBlock = CircleBlock()
    
    var dividerBlock1 = Divider()
    var dividerBlock2 = Divider()
    var dividerBlock3 = Divider()
    var dividerBlock4 = Divider()
    var dividerBlock5 = Divider()
    
    var star = SKSpriteNode()
    var triangle = SKSpriteNode()
    var square = SKSpriteNode()
    var circle = SKSpriteNode()
    
    var touchedStar: SKNode?
    var touchedCircle: SKNode?
    var touchedSquare: SKNode?
    var touchedTriangle: SKNode?
    
    var leftWall: SKSpriteNode?
    var rightWall: SKSpriteNode?
    
    var pauseBtn = SKSpriteNode()
    var scoreLbl = SKLabelNode()
    var timeCountDownLbl = SKLabelNode()
    
    var shapes = [SKSpriteNode]()
    
    var homeBtn = SKSpriteNode()
    var resumeBtn = SKSpriteNode()
    
    var spawner = NSTimer()
    
    var gameover = false
    var increaseSpawnFuncCalled = false
    var firstTimeSpawned = false
    
    var score = 0
    var time = 30
    var spawningTime = 0.8
    
    var touchPoint: CGPoint = CGPoint()
    
    override func didMoveToView(view: SKView) {
        physicsWorld.gravity = CGVectorMake(0, -2.7)
        
        initialize()
    }
    
    override func update(currentTime: NSTimeInterval) {
        checkSpriteLocation()
        
        self.timeCountDownLbl.text = "0:\(time)"
        
        if increaseSpawnFuncCalled == false && score > 5 {
            increaseSpawnTime()
            increaseSpawnFuncCalled = true
        }
        
        if time <= 9 {
            
            self.timeCountDownLbl.text = "0:0\(time)"
        }
        
        if time == 0 {
            
            self.endGame()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.locationInNode(self)
            let thisNode = self.nodeAtPoint(location)
            
            if thisNode.name == "Star" {
                
                self.touchedStar = thisNode
            }
            
            if thisNode.name == "Circle" {
                
                self.touchedCircle = thisNode
            }
            
            if thisNode.name == "Square" {
                
                self.touchedSquare = thisNode
            }
            
            if thisNode.name == "Triangle" {
                
                self.touchedTriangle = thisNode
            }
            
            if nodeAtPoint(location) == homeBtn {
                
                homeBtn.texture = SKTexture(imageNamed: "SmallHomeBtnDown")
            }
            
            if nodeAtPoint(location) == resumeBtn {
                
                resumeBtn.texture = SKTexture(imageNamed: "SmallPlayBtnDown")
            }
            
            if nodeAtPoint(location).name == "Pause" {
                
                pauseBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "PauseDown")))
            }
            
        }
            
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.locationInNode(self)
            
            self.touchedStar?.position.x = location.x
            self.touchedCircle?.position.x = location.x
            self.touchedTriangle?.position.x = location.x
            self.touchedSquare?.position.x = location.x
            
            
            if nodeAtPoint(location) != homeBtn {
                
                homeBtn.texture = SKTexture(imageNamed: "SmallHome")
            }
            
            if nodeAtPoint(location) != resumeBtn {
                
                resumeBtn.texture = SKTexture(imageNamed: "SmallPlayBtn")
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.touchedStar = nil
        self.touchedCircle = nil
        self.touchedSquare = nil
        self.touchedTriangle = nil
        
        for touch in touches {
            
            let location = touch.locationInNode(self)
            
            if nodeAtPoint(location).name == "Pause" {
                
                pauseBtn.runAction(SKAction.setTexture(SKTexture(imageNamed: "Pause")))
                
                if self.scene?.paused != true {
                    
                    spawner.invalidate()
                    createPauseMenu()
                }
                
            }
            
            if nodeAtPoint(location).name == "SmallHomeBtn" {
                
                playClickSound1()
                homeBtn.texture = SKTexture(imageNamed: "SmallHome")
                
                let mainMenu = MainMenuScene(fileNamed: "MainMenuScene")
                mainMenu?.scaleMode = .AspectFill
                self.view?.presentScene(mainMenu!, transition: SKTransition.fadeWithDuration(0.5))
                
            }
            
            if nodeAtPoint(location).name == "ResumeBtn" {
                
                playClickSound1()
                resumeBtn.texture = SKTexture(imageNamed: "SmallPlayBtn")
                self.scene?.paused = false
                spawner.invalidate();
                spawner = NSTimer.scheduledTimerWithTimeInterval(spawningTime, target: self, selector: #selector(GameplayScene.spawnObstacles), userInfo: nil, repeats: true)
                
                for child in children {
                    
                    if child.name == "SmallHomeBtn" {
                        child.removeFromParent()
                    }
                    
                    if child.name == "PauseBG" {
                        child.removeFromParent()
                    }
                    
                    if child.name == "ResumeBtn" {
                        child.removeFromParent()
                    }
                    
                    if child.name == "PauseTitle" {
                        child.removeFromParent()
                    }
                }
            }
        }
        
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.node?.name == "Circle" || contact.bodyA.node?.name == "Triangle" || contact.bodyA.node?.name == "Square" || contact.bodyA.node?.name == "Star" {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // Circle Contact
        if firstBody.node?.name == "Circle" && secondBody.node?.name == "CircleBlock" {
            
            incrementScore()
            firstBody.node?.removeFromParent()
        }
        
        if firstBody.node?.name == "Circle" && secondBody.node?.name == "TriangleBlock" {
            
            decrementScore()
            playErrorSound()
            endGame()
            firstBody.node?.removeFromParent()
        }
        
        if firstBody.node?.name == "Circle" && secondBody.node?.name == "SquareBlock" {
            
            decrementScore()
            playErrorSound()
            endGame()
            firstBody.node?.removeFromParent()
        }
        
        if firstBody.node?.name == "Circle" && secondBody.node?.name == "StarBlock" {
            
            decrementScore()
            playErrorSound()
            endGame()
            firstBody.node?.removeFromParent()
        }
        
        // Triangle Contact
        if firstBody.node?.name == "Triangle" && secondBody.node?.name == "TriangleBlock" {
            
            incrementScore()
            firstBody.node?.removeFromParent()
        }
        
        if firstBody.node?.name == "Triangle" && secondBody.node?.name == "CircleBlock" {
            
            decrementScore()
            playErrorSound()
            endGame()
            firstBody.node?.removeFromParent()
        }
        
        if firstBody.node?.name == "Triangle" && secondBody.node?.name == "SquareBlock" {
            
            decrementScore()
            playErrorSound()
            endGame()
            firstBody.node?.removeFromParent()
        }
        
        if firstBody.node?.name == "Triangle" && secondBody.node?.name == "StarBlock" {
            
            decrementScore()
            playErrorSound()
            endGame()
            firstBody.node?.removeFromParent()
        }
        
        // Square Contact
        if firstBody.node?.name == "Square" && secondBody.node?.name == "SquareBlock" {
            
            incrementScore()
            firstBody.node?.removeFromParent()
        }
        
        if firstBody.node?.name == "Square" && secondBody.node?.name == "StarBlock" {
            
            decrementScore()
            playErrorSound()
            endGame()
            firstBody.node?.removeFromParent()
        }
        
        if firstBody.node?.name == "Square" && secondBody.node?.name == "CircleBlock" {
            
            decrementScore()
            playErrorSound()
            endGame()
            firstBody.node?.removeFromParent()
        }
        
        if firstBody.node?.name == "Square" && secondBody.node?.name == "TriangleBlock" {
            
            decrementScore()
            playErrorSound()
            endGame()
            firstBody.node?.removeFromParent()
        }
        
        // Star Contact
        if firstBody.node?.name == "Star" && secondBody.node?.name == "StarBlock" {
            
            incrementScore()
            firstBody.node?.removeFromParent()
        }
        
        if firstBody.node?.name == "Star" && secondBody.node?.name == "SquareBlock" {
            
            decrementScore()
            playErrorSound()
            endGame()
            firstBody.node?.removeFromParent()

        }
        
        if firstBody.node?.name == "Star" && secondBody.node?.name == "CircleBlock" {
            
            decrementScore()
            playErrorSound()
            endGame()
            firstBody.node?.removeFromParent()
            
        }
        
        if firstBody.node?.name == "Star" && secondBody.node?.name == "TriangleBlock" {
            
            decrementScore()
            playErrorSound()
            endGame()
            firstBody.node?.removeFromParent()
        }
        
        
        
    }
    
    func initialize() {
        physicsWorld.contactDelegate = self
        
        createDividerBlocks()
        createStarBlock()
        createTriangleBlock()
        createSquareBlock()
        createCircleBlock()
        createPauseBtn()
        createScoreLabel()
        createWalls()
        
        createStar()
        createCircle()
        createSquare()
        createTriangle()
        
        spawner = NSTimer.scheduledTimerWithTimeInterval(spawningTime, target: self, selector: #selector(GameplayScene.spawnObstacles), userInfo: nil, repeats: true)
    }
    
    func createWalls() {
        
        leftWall = SKSpriteNode()
        rightWall = SKSpriteNode()
        
        leftWall?.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 50, height: self.size.height))
        leftWall?.physicsBody?.categoryBitMask = ColliderType.Wall
        leftWall?.physicsBody?.affectedByGravity = false
        leftWall?.color = SKColor.yellowColor()
        leftWall?.zPosition = 10
        leftWall?.position = CGPoint(x: CGRectGetMinX(self.frame) + 50, y: 0)
        
        self.addChild(leftWall!)
        
        rightWall?.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 50, height: self.size.height))
        rightWall?.physicsBody?.categoryBitMask = ColliderType.Wall
        rightWall?.physicsBody?.affectedByGravity = false
        rightWall?.color = SKColor.yellowColor()
        rightWall?.zPosition = 10
        rightWall?.position = CGPoint(x: CGRectGetMaxX(self.frame) - 50, y: 0)
        self.addChild(rightWall!)
        
    }
    
    func createDividerBlocks() {
        
        dividerBlock1 = Divider(imageNamed: "Divider")
        dividerBlock1.initialize()
        dividerBlock1.position = CGPoint(x: 0, y: -(self.frame.size.height / 2) + 110)
        
        dividerBlock2 = Divider(imageNamed: "Divider")
        dividerBlock2.initialize()
        dividerBlock2.position = CGPoint(x: -430, y: -(self.frame.size.height / 2) + 110)
        
        dividerBlock3 = Divider(imageNamed: "Divider")
        dividerBlock3.initialize()
        dividerBlock3.position = CGPoint(x: 430, y: -(self.frame.size.height / 2) + 110)
        
        dividerBlock4 = Divider(imageNamed: "Divider")
        dividerBlock4.initialize()
        dividerBlock4.position = CGPoint(x: 935, y: -(self.frame.size.height / 2) + 110)
        
        dividerBlock5 = Divider(imageNamed: "Divider")
        dividerBlock5.initialize()
        dividerBlock5.position = CGPoint(x: -935, y: -(self.frame.size.height / 2) + 110)
        
        self.addChild(dividerBlock1)
        self.addChild(dividerBlock2)
        self.addChild(dividerBlock3)
        self.addChild(dividerBlock4)
        self.addChild(dividerBlock5)
        
    }
    
    func createStarBlock() {
        
        starBlock = StarBlock(imageNamed: "Star Block")
        starBlock.initialize()
        starBlock.position = CGPoint(x: -670, y: -(self.frame.size.height / 2) + 55)
        starBlock.size = CGSize(width: 242, height: 90)
        
        self.addChild(starBlock)
    }
    
    func createTriangleBlock() {
        
        triangleBlock = TriangleBlock(imageNamed: "Triangle Block")
        triangleBlock.initialize()
        triangleBlock.position = CGPoint(x: -210, y: -(self.frame.size.height / 2) + 55)
        triangleBlock.size = CGSize(width: 242, height: 90)
        
        self.addChild(triangleBlock)
    }
    
    func createSquareBlock() {
        
        squareBlock = SquareBlock(imageNamed: "Square Block")
        squareBlock.initialize()
        squareBlock.position = CGPoint(x: 210, y: -(self.frame.size.height / 2) + 55)
        squareBlock.size = CGSize(width: 242, height: 90)
        
        self.addChild(squareBlock)
    }
    
    func createCircleBlock() {
        
        circleBlock = CircleBlock(imageNamed: "Circle Block")
        circleBlock.initialize()
        circleBlock.position = CGPoint(x: 670, y: -(self.frame.size.height / 2) + 55)
        circleBlock.size = CGSize(width: 242, height: 90)
        
        self.addChild(circleBlock)
    }
    
    func createStar() {
        
        star = SKSpriteNode(imageNamed: "Shape 4")
        star.name = "Star"
        star.zPosition = 1
        star.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        star.physicsBody = SKPhysicsBody(rectangleOfSize: star.size)
        star.physicsBody?.allowsRotation = true
        star.physicsBody?.categoryBitMask = ColliderType.Star
        star.physicsBody?.collisionBitMask = ColliderType.StarDetector | ColliderType.CircleDetector | ColliderType.SquareDetector | ColliderType.TriangleDetector | ColliderType.Star | ColliderType.Circle | ColliderType.Triangle | ColliderType.Square | ColliderType.Wall // | ColliderType.Divider
        star.physicsBody?.contactTestBitMask = ColliderType.StarDetector | ColliderType.SquareDetector | ColliderType.TriangleDetector | ColliderType.CircleDetector
        
        self.shapes.append(star)
    }
    
    func createTriangle() {
        
        triangle = SKSpriteNode(imageNamed: "Shape 1")
        triangle.name = "Triangle"
        triangle.zPosition = 1
        triangle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        triangle.physicsBody = SKPhysicsBody(rectangleOfSize: triangle.size)
        triangle.physicsBody?.allowsRotation = true
        triangle.physicsBody?.categoryBitMask = ColliderType.Triangle
        triangle.physicsBody?.collisionBitMask = ColliderType.StarDetector | ColliderType.CircleDetector | ColliderType.SquareDetector | ColliderType.TriangleDetector | ColliderType.Star | ColliderType.Circle | ColliderType.Triangle | ColliderType.Square | ColliderType.Wall  // | ColliderType.Divider
        triangle.physicsBody?.contactTestBitMask = ColliderType.StarDetector | ColliderType.SquareDetector | ColliderType.TriangleDetector | ColliderType.CircleDetector
        
        self.shapes.append(triangle)

    }
    
    func createSquare() {
        
        square = SKSpriteNode(imageNamed: "Shape 2")
        square.name = "Square"
        square.zPosition = 1
        square.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        square.physicsBody = SKPhysicsBody(rectangleOfSize: square.size)
        square.physicsBody?.allowsRotation = true
        square.physicsBody?.categoryBitMask = ColliderType.Square
        square.physicsBody?.collisionBitMask = ColliderType.StarDetector | ColliderType.CircleDetector | ColliderType.SquareDetector | ColliderType.TriangleDetector | ColliderType.Star | ColliderType.Circle | ColliderType.Triangle | ColliderType.Square | ColliderType.Wall  // | ColliderType.Divider
        square.physicsBody?.contactTestBitMask = ColliderType.StarDetector | ColliderType.SquareDetector | ColliderType.TriangleDetector | ColliderType.CircleDetector
        
        self.shapes.append(square)
    }
    
    func createCircle() {
        
        circle = SKSpriteNode(imageNamed: "Shape 3")
        circle.name = "Circle"
        circle.zPosition = 1
        circle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        circle.physicsBody = SKPhysicsBody(rectangleOfSize: circle.size)
        circle.physicsBody?.allowsRotation = true
        circle.physicsBody?.categoryBitMask = ColliderType.Circle
        circle.physicsBody?.collisionBitMask = ColliderType.StarDetector | ColliderType.CircleDetector | ColliderType.SquareDetector | ColliderType.TriangleDetector | ColliderType.Star | ColliderType.Circle | ColliderType.Triangle | ColliderType.Square | ColliderType.Wall  // | ColliderType.Divider
        circle.physicsBody?.contactTestBitMask = ColliderType.StarDetector | ColliderType.CircleDetector | ColliderType.SquareDetector | ColliderType.TriangleDetector
        
        self.shapes.append(circle)
    }
    
    func spawnObstacles() {
        
        if firstTimeSpawned == false {
            
            spawner.invalidate()
            spawner = NSTimer.scheduledTimerWithTimeInterval(spawningTime, target: self, selector: #selector(GameplayScene.spawnObstacles), userInfo: nil, repeats: true)
            firstTimeSpawned = true

        }
        
        let index = Int(arc4random_uniform(UInt32(shapes.count))) // Generate a random number between 0 and the amount of sprites in the array
        let shape = shapes[index].copy() as! SKSpriteNode // Store a copy of the Sprite at the index in the array into the constant
        
        // Spawn the sprite to the right of the screen and set the y position to be 50
        shape.position = CGPoint(x: GameManager.instance.randomBetweenNumbers(-650, secondNum: 600), y: 700) // self.frame.size.height + 100
        shape.setScale(2.4)
        
        self.addChild(shape)
    }
    
    
    func createPauseBtn() {
        
        pauseBtn = SKSpriteNode(imageNamed: "Pause")
        pauseBtn.name = "Pause"
        pauseBtn.anchorPoint = CGPoint(x: 1, y: 1)
        pauseBtn.size = CGSize(width: 80, height: 80)
        pauseBtn.zPosition = 4
        
        if UIScreen.mainScreen().sizeType == .iPhone4 {
            
            pauseBtn.position = CGPoint(x: CGRectGetMaxX(self.frame) - 200 , y: CGRectGetMaxY(self.frame) - 50)
            // iPhone 4/s
            
        } else if UIScreen.mainScreen().sizeType == .iPhone5 {
            
            pauseBtn.position = CGPoint(x: CGRectGetMaxX(self.frame) - 50 , y: CGRectGetMaxY(self.frame) - 50)
            // iPhone 5/s
            
        } else if UIScreen.mainScreen().sizeType == .iPhone6 {
            
            pauseBtn.position = CGPoint(x: CGRectGetMaxX(self.frame) - 50 , y: CGRectGetMaxY(self.frame) - 50)
            // iPhone 6/s
            
        } else if UIScreen.mainScreen().sizeType == .iPhone6Plus {
            
            pauseBtn.position = CGPoint(x: CGRectGetMaxX(self.frame) - 50 , y: CGRectGetMaxY(self.frame) - 50)
            // iPhone 6/s plus
        }
        
        
        self.addChild(pauseBtn)
    }
    
    func createScoreLabel() {
        
        scoreLbl = SKLabelNode(fontNamed: "Prototype")
        scoreLbl.fontSize = 120
        scoreLbl.zPosition = 1
        scoreLbl.text = "26"
        scoreLbl.horizontalAlignmentMode = .Left
        
        
        if UIScreen.mainScreen().sizeType == .iPhone4 {
            
            scoreLbl.position = CGPoint(x: CGRectGetMinX(self.frame) + 190 , y: CGRectGetMaxY(self.frame) - 130) // Looks Good
            // iPhone 4/s
            
        } else if UIScreen.mainScreen().sizeType == .iPhone5 {
            
            scoreLbl.position = CGPoint(x: CGRectGetMinX(self.frame) + 60 , y: CGRectGetMaxY(self.frame) - 130) // Check or Fix
            // iPhone 5/s
            
        } else if UIScreen.mainScreen().sizeType == .iPhone6 {
            
            scoreLbl.position = CGPoint(x: CGRectGetMinX(self.frame) + 60 , y: CGRectGetMaxY(self.frame) - 130) // Looks Good
            // iPhone 6/s
            
        } else if UIScreen.mainScreen().sizeType == .iPhone6Plus {
            
            scoreLbl.position = CGPoint(x: CGRectGetMinX(self.frame) + 60 , y: CGRectGetMaxY(self.frame) - 130) // Check or Fix
            // iPhone 6/s plus
        }
        
        self.addChild(scoreLbl)
    }
    
    func createPauseMenu() {
        
        self.scene?.paused = true
        
        let bg = SKSpriteNode(imageNamed: "PauseMenuBG")
        bg.name = "PauseBG"
        bg.zPosition = 3
        bg.size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        bg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        bg.position = CGPoint(x: 0, y: 0)
        
        let pauseLabel = SKLabelNode(fontNamed: "Prototype")
        pauseLabel.name = "PauseTitle"
        pauseLabel.zPosition = 5
        pauseLabel.fontSize = 100
        pauseLabel.text = "PAUSED"
        pauseLabel.position = CGPoint(x: 0, y: 250)
        
        homeBtn = SKSpriteNode(imageNamed: "SmallHome")
        homeBtn.name = "SmallHomeBtn"
        homeBtn.zPosition = 5
        homeBtn.size = CGSize(width: 300, height: 180)
        homeBtn.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        homeBtn.position = CGPoint(x: -290, y: 0)
        
        resumeBtn = SKSpriteNode(imageNamed: "SmallPlayBtn")
        resumeBtn.name = "ResumeBtn"
        resumeBtn.zPosition = 5
        resumeBtn.size = CGSize(width: 300, height: 180)
        resumeBtn.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        resumeBtn.position = CGPoint(x: 290, y: 0)
        
        self.addChild(bg)
        self.addChild(pauseLabel)
        self.addChild(homeBtn)
        self.addChild(resumeBtn)
    }
    
    func incrementScore() {
        
        score += 1
        scoreLbl.text = "\(score)"
        playCorrectSound()

    }
    
    func decrementScore() {
        
        if score >= 0 {
            
            playErrorSound()
        }
        
        if score > 0 {
            
            score -= 1
            scoreLbl.text = "\(score)"
        }
        
    }
    
    func endGame() {
        
        spawner.invalidate()
        self.removeAllActions()
        self.removeAllChildren()
        
        NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "SCORE")
        
        let gameover = GameoverScene(fileNamed: "GameoverScene")
        gameover?.scaleMode = .AspectFill
        self.view?.presentScene(gameover!, transition: SKTransition.fadeWithDuration(0.5))
    }
    
    func playErrorSound() {
        
        let play = SKAction.playSoundFileNamed("dingwrong", waitForCompletion: false)
        
        if soundOn == true {
            self.runAction(play)
        }
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    func playCorrectSound() {
        
        let play = SKAction.playSoundFileNamed("CorrectSound", waitForCompletion: false)
        if soundOn == true {
            self.runAction(play)
        }
    }
    
    func playClickSound1() {
        
        let play = SKAction.playSoundFileNamed("ButtonClickSound", waitForCompletion: false)
        if soundOn == true {
            self.runAction(play)
        }
    }
    
    func increaseSpawnTime() {
        
        let wait = SKAction.waitForDuration(8)
        let change = SKAction.runBlock {
            
            self.spawningTime -= 0.1
            
            self.spawner.invalidate()
            self.spawner = NSTimer.scheduledTimerWithTimeInterval(self.spawningTime, target: self, selector: #selector(GameplayScene.spawnObstacles), userInfo: nil, repeats: true)

        }
        let sequence = SKAction.sequence([wait, change])
        self.runAction(SKAction.repeatAction(sequence, count: 3))
    }
    
    func checkSpriteLocation() {
        
        self.enumerateChildNodesWithName("Circle", usingBlock: ({
            (node, error) in
            
            if node.position.y < CGRectGetMinY(self.frame) {
                
                node.removeFromParent()
                node.removeAllActions()
            }
        
        }))
        
        self.enumerateChildNodesWithName("Square", usingBlock: ({
            (node, error) in
            
            if node.position.y < CGRectGetMinY(self.frame) {
                
                node.removeFromParent()
                node.removeAllActions()
            }
            
        }))
        
        self.enumerateChildNodesWithName("Triangle", usingBlock: ({
            (node, error) in
            
            if node.position.y < CGRectGetMinY(self.frame) {
                
                node.removeFromParent()
                node.removeAllActions()
            }
            
        }))
        
        self.enumerateChildNodesWithName("Star", usingBlock: ({
            (node, error) in
            
            if node.position.y < CGRectGetMinY(self.frame) {
                
                node.removeFromParent()
                node.removeAllActions()
            }
            
        }))
    }

}


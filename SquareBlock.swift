//
//  SquareBlock.swift
//  Falling Shapes!
//
//  Created by Brian Lim on 5/15/16.
//  Copyright © 2016 codebluapps. All rights reserved.
//

import SpriteKit

class SquareBlock: SKSpriteNode {
    
    func initialize() {
        
        self.name = "SquareBlock"
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = 1
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: self.size.width + 220, height: self.size.height))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.dynamic = false
        self.physicsBody?.categoryBitMask = ColliderType.SquareDetector
        self.physicsBody?.contactTestBitMask = ColliderType.Star | ColliderType.Circle | ColliderType.Triangle | ColliderType.Square
    }
}

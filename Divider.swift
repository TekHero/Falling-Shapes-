//
//  Divider.swift
//  Falling Shapes!
//
//  Created by Brian Lim on 5/15/16.
//  Copyright © 2016 codebluapps. All rights reserved.
//

import SpriteKit

class Divider: SKSpriteNode {
    
    func initialize() {
        
        self.name = "Divider"
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = 1
        self.yScale = 2.8
        self.xScale = 2.0
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 10, height: self.size.height))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.dynamic = false
        self.physicsBody?.categoryBitMask = ColliderType.Divider
        self.physicsBody?.collisionBitMask = ColliderType.Circle | ColliderType.Square | ColliderType.Star | ColliderType.Triangle
        
    }
}

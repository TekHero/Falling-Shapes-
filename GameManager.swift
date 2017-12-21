//
//  GameManager.swift
//  Falling Shapes!
//
//  Created by Brian Lim on 5/14/16.
//  Copyright © 2016 codebluapps. All rights reserved.
//

import Foundation
import SpriteKit

struct ColliderType {
    
    static let Divider: UInt32 = 1
    static let Star: UInt32 = 2
    static let Triangle: UInt32 = 3
    static let Square: UInt32 = 4
    static let Circle: UInt32 = 5
    static let StarDetector: UInt32 = 6
    static let TriangleDetector: UInt32 = 7
    static let SquareDetector: UInt32 = 8
    static let CircleDetector: UInt32 = 9
    static let Wall: UInt32 = 10
}

class GameManager {
    
    static let instance = GameManager()
    private init() {}
    
    func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    // Saving and Grabbing highscores
    func setHighscore(highscore: Int) {
        NSUserDefaults.standardUserDefaults().setInteger(highscore, forKey: "HIGHSCORE")
    }
    
    func getHighscore() -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey("HIGHSCORE")
    }
    
    
}
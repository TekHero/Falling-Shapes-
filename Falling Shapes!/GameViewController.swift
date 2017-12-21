//
//  GameViewController.swift
//  Falling Shapes!
//
//  Created by Brian Lim on 5/14/16.
//  Copyright (c) 2016 codebluapps. All rights reserved.
//

import UIKit
import SpriteKit
import Foundation
import GoogleMobileAds

class GameViewController: UIViewController, GADInterstitialDelegate {
    
    var interstitial: GADInterstitial!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameViewController.checkAd), name: "showInterstitialKey", object: nil)
        
        self.interstitial = createAndLoadInterstitial()
        
        let request = GADRequest()
        request.testDevices = ["kGADSimulatorID"]
        self.interstitial.loadRequest(request)

        if let scene = MainMenuScene(fileNamed:"MainMenuScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }
    
    func checkAd() {
        
        if interstitial.isReady {
            
            if self.interstitial.isReady {
                
                if adShown % 4 == 0 {
                    
                    self.interstitial.presentFromRootViewController(self)
                    
                }
            }
        }
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-6536902852765774/7870877446")
        interstitial.delegate = self
        interstitial.loadRequest(GADRequest())
        return interstitial
        
    }
    
    func interstitialDidDismissScreen(ad: GADInterstitial!) {
        
        self.interstitial = createAndLoadInterstitial()
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

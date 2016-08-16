//
//  GameViewController.swift
//  FireworksNight
//
//  Created by My Nguyen on 8/15/16.
//  Copyright (c) 2016 My Nguyen. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
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

    // this method is invoked when the device is shaken
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        // fetch the app view as a SpriteKit view
        let skView = view as! SKView
        // fetch a reference to the GameScene
        let gameScene = skView.scene as! GameScene
        // explode the fireworks
        gameScene.explodeFireworks()
    }
}

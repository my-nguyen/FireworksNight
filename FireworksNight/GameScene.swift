//
//  GameScene.swift
//  FireworksNight
//
//  Created by My Nguyen on 8/15/16.
//  Copyright (c) 2016 My Nguyen. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene {

    // used to call launchFireworks() method every 6 seconds
    var gameTimer: NSTimer!
    // an array of SKNode objects. fireworks will have a container node, an image node and a fuse node.
    var fireworks = [SKNode]()
    // the 3 edges are used to define where to launch fireworks from
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    // track the player's score
    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    override func didMoveToView(view: SKView) {
        // set a background picture
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .Replace
        background.zPosition = -1
        addChild(background)

        // add a score label to the scene
        scoreLabel = SKLabelNode()
        scoreLabel.text = "Score: 0"
        // align the label to the right
        scoreLabel.horizontalAlignmentMode = .Right
        // position the label on the top-right edge of the scene
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)

        // createa an NSTimer to call launchFireworks() every 6 seconds, with repeating enable
        gameTimer = NSTimer.scheduledTimerWithTimeInterval(6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        checkForTouches(touches)
    }
   
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        checkForTouches(touches)
    }
    
    override func update(currentTime: CFTimeInterval) {
        // loop backward through the fireworks array
        for (index, firework) in fireworks.enumerate().reverse() {
            // this uses a position high above so that rockets can explode off screen
            if firework.position.y > 900 {
                // if a firework gets past 900 points up vertically, remove it from the fireworks array
                // and from the scene
                fireworks.removeAtIndex(index)
                firework.removeFromParent()
            }
        }
    }

    // this method accepts 3 parameters: the horizontal speed, and the X and Y coordinates for creation
    func createFirework(xMovement xMovement: CGFloat, x: Int, y: Int) {
        // create an SKNode that will act as the firework container
        let node = SKNode()
        // place the SKNode at the specified X/Y position
        node.position = CGPoint(x: x, y: y)

        // create a rocket SKSpriteNode, name it "firework" and add it to the container node
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.name = "firework"
        node.addChild(firework)

        // give the firework SKSpriteNode 1 of 3 random colors: cyan, green, or red.
        switch GKRandomSource.sharedRandom().nextIntWithUpperBound(3) {
        case 0:
            firework.color = UIColor.cyanColor()
            firework.colorBlendFactor = 1

        case 1:
            firework.color = UIColor.greenColor()
            firework.colorBlendFactor = 1

        case 2:
            firework.color = UIColor.redColor()
            firework.colorBlendFactor = 1

        default:
            break
        }

        // create a UIBezierPath that will represent the movement of the firework
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 0))
        path.addLineToPoint(CGPoint(x: xMovement, y: 1000))

        // tell the container node to follow that path, turning itself as needed
        let move = SKAction.followPath(path.CGPath, asOffset: true, orientToPath: true, speed: 200)
        node.runAction(move)

        // create particles behind the rocket to make it look like the fireworks are lit
        let emitter = SKEmitterNode(fileNamed: "fuse")!
        emitter.position = CGPoint(x: 0, y: -22)
        node.addChild(emitter)

        // add the container node to the fireworks array and also to the scene
        fireworks.append(node)
        addChild(node)
    }

    // this method will launch fireworks five at a time in four different shapes
    func launchFireworks() {
        let movementAmount: CGFloat = 1800

        // generate a random number between 0 and 4 inclusive.
        switch GKRandomSource.sharedRandom().nextIntWithUpperBound(5) {
        case 0:
            // fire five, straight up
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)

        case 1:
            // fire five, in a fan
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)

        case 2:
            // fire five, from the left to the right
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)

        case 3:
            // fire five, from the right to the left
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)

        case 4:
            // ten five, from the left to the right and from the right to the left
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)

        default:
            break
        }
    }

    func checkForTouches(touches: Set<UITouch>) {
        // fetch the touch location from the scene
        guard let touch = touches.first else { return }
        let location = touch.locationInNode(self)
        // fetch all nodes under the touch location
        let nodes = nodesAtPoint(location)

        // look through all such nodes
        for node in nodes {
            if node is SKSpriteNode {
                let sprite = node as! SKSpriteNode

                // find any node with the name "firework"
                if sprite.name == "firework" {
                    // go through every firework in the fireworks array
                    for parent in fireworks {
                        // fetch the firework image within the firework (container node)
                        let firework = parent.children[0] as! SKSpriteNode
                        // if the firework was selected and is a different color than the firework
                        // that was just tapped, then reset the name to "firework" and reset its color by 
                        // setting colorBlendFactor to 1
                        if firework.name == "selected" && firework.color != sprite.color {
                            firework.name = "firework"
                            firework.colorBlendFactor = 1
                        }
                    }
                    // change the node name to "selected"
                    sprite.name = "selected"
                    // set colorBlendFactor to 0, to disable the color blending, making the firework white
                    sprite.colorBlendFactor = 0
                }
            }
        }
    }

    func explodeFirework(firework: SKNode) {
        // create an explosion where the firework is
        let emitter = SKEmitterNode(fileNamed: "explode")!
        emitter.position = firework.position
        addChild(emitter)

        // remove the firework from the scene
        firework.removeFromParent()
    }

    func explodeFireworks() {
        var numExploded = 0
        // loop backward through the fireworks array
        for (index, fireworkContainer) in fireworks.enumerate().reverse() {
            let firework = fireworkContainer.children[0] as! SKSpriteNode
            // pick out the selected firework
            if firework.name == "selected" {
                // destroy this firework!
                explodeFirework(fireworkContainer)
                fireworks.removeAtIndex(index)

                numExploded += 1
            }
        }

        // calculate player's score based on the number of exploded fireworks
        switch numExploded {
        case 0:
            // nothing – rubbish!
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 4000
        }
    }
}
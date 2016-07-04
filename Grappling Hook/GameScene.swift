//
//  GameScene.swift
//  Grappling Hook
//
//  Created by mitchell hudson on 7/4/16.
//  Copyright (c) 2016 mitchell hudson. All rights reserved.
//

/*
    This exmaple mocks up a possible mehcanic for creating a grappling hook like effect 
    that might be used in a video game. 
 
    The mechanic demonstrated here uses update to move the hook and the player towards 
    location. This mechanic has the following advantages:
 
        1. It is simple and easy to understand and manipulate
        2. The position of the grapple can be updated often without upsetting the system. 
            This means you could attach the hook to a moving object and this system would not 
            have any problems. 
 
    As written the code in update may speed up or slow down depending on frame rate. This can 
    be eleviated with a more carefully animation formula taking delta time into consideration.
 
    The down sides to this system would be:
 
        1. While I setup physics objects to detect contacts. This system would not play 
            well with collisions, and won't allow the object to appear as if it is swining
            at the end of the rope.
 
    The rope (orange line) is drawn using an SKShape node. This node draws a path between the 
        player and the target every frame.
*/

import SpriteKit

class GameScene: SKScene {
    
    var player: SKSpriteNode!       // Player object moves to the ropeTarget "hook"
    var rope: SKShapeNode!          // Shape node that draws a line between player and target
    var ropeTarget: SKSpriteNode!   // Imagine this as the hook. The player will move to this hook
    var hookTarget = CGPointZero    // The position the hook moves to.
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // Edge loop
        
        // An edge loop around the scene. This has no effect on the example here. 
        // Though it might be used detect objects leaving the bounds of the screen.
        physicsBody = SKPhysicsBody(edgeLoopFromRect: view.frame)
        
        
        // Player
        // Create the player object.
        let playerSize = CGSize(width: 30, height: 30)
        player = SKSpriteNode(color: UIColor.redColor(), size: playerSize)
        addChild(player)
        player.position.x = 200
        player.position.y = 100
        player.physicsBody = SKPhysicsBody(rectangleOfSize: playerSize)
        player.physicsBody?.allowsRotation = false
        // make this object dynamic since its position won't be set by physics
        player.physicsBody?.dynamic = false
        
        
        // Rope
        // Make the rope object
        rope = SKShapeNode()
        addChild(rope)
        
        // Rope Target
        let ropeTargetSize = CGSize(width: 10, height: 10)
        ropeTarget = SKSpriteNode(color: UIColor.blueColor(), size: ropeTargetSize)
        addChild(ropeTarget)
        ropeTarget.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        // // make this object dynamic since its position won't
        ropeTarget.physicsBody?.dynamic = false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        let touch = touches.first!
        let location = touch.locationInNode(self)
        
        // Set the target location for the ropeTarget to move to
        hookTarget = location
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        // Move Target
        // Move the ropeTarget to the hookTarget position
        ropeTarget.position.x -= (ropeTarget.position.x - hookTarget.x) * 0.5
        ropeTarget.position.y -= (ropeTarget.position.y - hookTarget.y) * 0.5
        
        // Move the player to the hookTarget slower than the ropeTarget
        player.position.x -= (player.position.x - hookTarget.x) * 0.2
        player.position.y -= (player.position.y - hookTarget.y) * 0.2
        
        // Draw a line between the two positions
        let ropePath = CGPathCreateMutable()
        CGPathMoveToPoint(ropePath, nil, player.position.x, player.position.y)
        CGPathAddLineToPoint(ropePath, nil, ropeTarget.position.x, ropeTarget.position.y)
        rope.path = ropePath
        rope.strokeColor = UIColor.orangeColor()
        rope.lineWidth = 4
    }
}

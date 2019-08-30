//
//  GameScene.swift
//  Baseball Striker
//
//  Created by Michael Kronovet on 12/15/18.
//  Copyright © 2018 Michael Kronovet. All rights reserved.
//

import SpriteKit
import GameplayKit

class gamePlayScene: SKScene, SKPhysicsContactDelegate {
    
    var levelNumber = 0
    var livesNumber = 3
    
    let scoreLabel = SKLabelNode()
    let livesLabel = SKLabelNode()
    //SKLabelNode(fontNamed: "Custom font namee")
    
    let player = SKSpriteNode(imageNamed: "bat")
    let hitSound = SKAction.playSoundFileNamed("bat+hit+ball.wav", waitForCompletion: false)
    let throwSound = SKAction.playSoundFileNamed("throwBall.wav", waitForCompletion: false)
    
    struct PhysicsCategories{
        static let None: UInt32 = 0
        static let Player: UInt32 = 0b1
        static let Ball: UInt32 = 0b10
    }
    
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random())/0xFFFFFFFF)
    }
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max-min) + min
    }
    
    let gameArea: CGRect
    override init(size: CGSize){
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height/maxAspectRatio
        let margin = (size.width-playableWidth)/2
        gameArea = CGRect(x: margin , y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("some bullshit")
    }
    
    override func didMove(to view: SKView) {
        gameScore = 0
        
        self.physicsWorld.contactDelegate = self
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x:self.size.width/2,y:self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        player.setScale(0.3)
        background.size = self.size
        player.position = CGPoint(x:self.size.width/2,y:gameArea.minY + 200)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        ///
        player.physicsBody!.friction = 0.2
        player.physicsBody!.restitution = 0.3
        player.physicsBody!.mass = 1000
        ///
        //player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        //player.physicsBody!.collisionBitMask = PhysicsCategories.None
        //player.physicsBody!.contactTestBitMask = PhysicsCategories.Ball
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.Ball
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Ball
        self.addChild(player)
        
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.9)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        livesLabel.text = "Lives: \(livesNumber)"
        livesLabel.fontSize = 50
        livesLabel.fontColor = SKColor.white
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        livesLabel.position = CGPoint(x: self.size.width * 0.85, y: self.size.height * 0.9)
        livesLabel.zPosition = 100
        self.addChild(livesLabel)
        
        startNewLevel()
    }
    
    func loseLife(){
        livesNumber-=1
        livesLabel.text = "Lives: \(livesNumber)"
        
        let scaleIn = SKAction.scale(to: 1.5, duration: 0.2)
        let fadeOut = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleIn,fadeOut])
        livesLabel.run(scaleSequence)
        if livesNumber == 0{
            gameOver()
        }
    }
    
    func addScore(){
        gameScore+=1
        scoreLabel.text = "Score: \(gameScore)"
        
        if gameScore != 0 && gameScore%15 == 0{
            startNewLevel()
        }
    }
    
    func gameOver(){
        self.removeAllActions()
        self.enumerateChildNodes(withName: "Ball"){
            bullet, stop in
            bullet.removeAllActions()
        }
        currentGameState = gameState.postgame
        
        let newScene = GameOverScene(size: self.size)
        newScene.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        SKAction.wait(forDuration: 1)
        self.view!.presentScene(newScene, transition: myTransition)
    }
    
    func startNewLevel(){
        levelNumber += 1
        
        if self.action(forKey: "SpawningEnemies") != nil{
            self.removeAction(forKey: "SpawningEnemies")
        }
        var levelDuration =  TimeInterval()
        
        levelDuration = 1.5 / (Double(levelNumber+1))
        
        let spawn = SKAction.run(spawnBall)
        let waitToSpawn = SKAction.wait(forDuration: 4*levelDuration)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnToForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnToForever, withKey: "SpawningEnemies")
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Ball{
            addScore()
            if body2.node != nil{
                if body2.node!.position.y > self.size.height{
                    return
                }
                else{
                    //spawnExplosion(spawnPosition: body2.node!.position)
                }
            }
            
            //body2.node?.removeFromParent()
        }
        else if body1.categoryBitMask == PhysicsCategories.Ball && body2.categoryBitMask == PhysicsCategories.Ball{
            if body2.node != nil{
                //spawnExplosion(spawnPosition: body2.node!.position)
            }
        }
        
    }
    
    func spawnExplosion(spawnPosition: CGPoint){
        let explosion = SKSpriteNode(imageNamed: "explosition")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        let explosionSequence = SKAction.sequence([hitSound, scaleIn,fadeOut,delete])
        explosion.run(explosionSequence)
    }
    
    // Should balls be able to collide witth each other to change trajectory?
    func spawnBall() {
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)
        let startPoint = CGPoint(x: randomXStart, y: self.size.height*1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height*0.2)
        let ball = SKSpriteNode(imageNamed: "baseball")
        ball.name = "Ball"
        ball.setScale(0.04)
        ball.position = startPoint
        ball.zPosition = 2
        //ball.physicsBody = SKPhysicsBody(rectangleOf: ball.size)
        /////////
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.size.width/2)
        ball.physicsBody!.affectedByGravity = false
        ball.physicsBody!.friction = 0.2
        ball.physicsBody!.restitution = 1
        ball.physicsBody!.mass = 1
        ball.physicsBody!.allowsRotation = true
        self.addChild(ball)
        ball.physicsBody!.applyForce(CGVector(dx: endPoint.x-startPoint.x, dy: 4*(endPoint.y-startPoint.y)))
        ///////////
        /*
        ball.physicsBody!.categoryBitMask = PhysicsCategories.Ball
        ball.physicsBody!.collisionBitMask = PhysicsCategories.None
        ball.physicsBody!.collisionBitMask = PhysicsCategories.Player
        ball.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        self.addChild(ball)
        let moveBall = SKAction.move(to: endPoint, duration:Double(random(min: 1, max: 10)))
        let deleteBall = SKAction.removeFromParent()
        let loseLifeAction = SKAction.run(loseLife)
        let ballSequence = SKAction.sequence([throwSound, moveBall,deleteBall, loseLifeAction])
        if currentGameState == gameState.ingame{
            ball.run(ballSequence)
        }
         */
        let ballSequence = SKAction.sequence([throwSound])
        if currentGameState == gameState.ingame{
            ball.run(ballSequence)
        }
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy,dx)
        ball.zRotation = amountToRotate
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentGameState == gameState.ingame{
            spawnBall()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        var count = 0
        for touch: AnyObject in touches{
            if count == 0{
                let pointofTouch = touch.location(in: self)
                let previousPointOfTouch = touch.previousLocation(in: self)
                let amountDragged = pointofTouch.x - previousPointOfTouch.x
                let yDrag = pointofTouch.y - previousPointOfTouch.y
                if currentGameState == gameState.ingame{
                    player.position.x += amountDragged
                    player.position.y += yDrag
                }
                if player.position.x > gameArea.maxX - player.size.width/2{
                    player.position.x = gameArea.maxX - player.size.width/2
                }
                if player.position.x < gameArea.minX + player.size.width/2{
                    player.position.x = gameArea.minX + player.size.width/2
                }
                if player.position.y > gameArea.minY + 300 - player.size.height/2{
                    player.position.y = gameArea.minY + 300 - player.size.height/2
                }
                if player.position.y < gameArea.minY + player.size.height/2{
                    player.position.y = gameArea.minY + player.size.height/2
                }
            }
            else{
                let pointofTouch2 = touch.location(in: self)
                let previousPointOfTouch2 = touch.previousLocation(in: self)
                let amountDraggedX2 = pointofTouch2.x - previousPointOfTouch2.x
                let amountDraggedY2 = pointofTouch2.y - previousPointOfTouch2.y
                let amountToRotate = atan2(amountDraggedY2,amountDraggedX2)
                //player.physicsBody?.applyAngularImpulse(0.1 * amountToRotate)
                let rot = SKAction.rotate(byAngle: 0.1 * amountToRotate, duration: 0.1)
                player.run(rot)
                //player.zRotation = amountToRotate
            }
            count += 1
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.enumerateChildNodes(withName: "Ball") {
            node, stop in
            if (node is SKSpriteNode) {
                let sprite = node as! SKSpriteNode
                // Check if the node is not in the scene
                if (sprite.position.y < self.gameArea.minY + sprite.size.height/2) {
                    sprite.removeFromParent()
                    self.loseLife()
                }
                else if (sprite.position.y > self.gameArea.maxY + 1000) {
                    sprite.removeFromParent()
                    self.addScore()
                }
                else if (sprite.position.x > self.gameArea.maxX - sprite.size.width/2 || sprite.position.x < self.gameArea.minX + sprite.size.width/2) {
                    sprite.removeFromParent()
                }
            }
        }
    }
    
}


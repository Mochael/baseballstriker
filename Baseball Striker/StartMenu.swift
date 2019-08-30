//
//  GameOverScene.swift
//  Baseball Striker
//
//  Created by Michael Kronovet on 12/28/18.
//  Copyright © 2018 Michael Kronovet. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene{
    
    let restartLabel = SKLabelNode()
    let mainMenuLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x:self.size.width/2,y:self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameOverLabel = SKLabelNode()
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 200
        gameOverLabel.fontColor = SKColor.black
        gameOverLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.7)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode()
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 125
        scoreLabel.fontColor = SKColor.black
        scoreLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.55)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        let defaults = UserDefaults()
        var highestScore = defaults.integer(forKey: "highScoreSaved")
        if gameScore > highestScore{
            highestScore = gameScore
            defaults.set(highestScore, forKey: "highScoreSaved")
        }
        
        let highScoreLabel = SKLabelNode()
        highScoreLabel.text = "High Score: \(highestScore)"
        highScoreLabel.fontSize = 125
        highScoreLabel.fontColor = SKColor.black
        highScoreLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.45)
        highScoreLabel.zPosition = 1
        self.addChild(highScoreLabel)
        
        restartLabel.text = "Play Again"
        restartLabel.fontSize = 90
        restartLabel.fontColor = SKColor.black
        restartLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.3)
        restartLabel.zPosition = 1
        self.addChild(restartLabel)
        
        mainMenuLabel.text = "Menu"
        mainMenuLabel.fontSize = 90
        mainMenuLabel.fontColor = SKColor.black
        mainMenuLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.15)
        mainMenuLabel.zPosition = 1
        self.addChild(mainMenuLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            if restartLabel.contains(pointOfTouch){
                let newScene = GameScene(size: self.size)
                newScene.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(newScene, transition: myTransition)
            }
            if mainMenuLabel.contains(pointOfTouch){
                let newScene = StartMenu(size: self.size)
                newScene.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(newScene, transition: myTransition)
            }
        }
    }
    
    
}

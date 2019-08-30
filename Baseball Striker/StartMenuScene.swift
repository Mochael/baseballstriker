//
//  GameOverScene.swift
//  Baseball Striker
//
//  Created by Michael Kronovet on 12/28/18.
//  Copyright © 2018 Michael Kronovet. All rights reserved.
//

import Foundation
import SpriteKit

class StartMenuScene: SKScene{
    
    let startLabel = SKLabelNode()

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x:self.size.width/2,y:self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let defaults = UserDefaults()
        let highestScore = defaults.integer(forKey: "highScoreSaved")
        
        let highScoreLabel = SKLabelNode()
        highScoreLabel.text = "High Score: \(highestScore)"
        highScoreLabel.fontSize = 125
        highScoreLabel.fontColor = SKColor.black
        highScoreLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.45)
        highScoreLabel.zPosition = 1
        self.addChild(highScoreLabel)
        
        startLabel.text = "Play"
        startLabel.fontSize = 150
        startLabel.fontColor = SKColor.black
        startLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.25)
        startLabel.zPosition = 1
        self.addChild(startLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            if startLabel.contains(pointOfTouch){
                let newScene = GameScene(size: self.size)
                newScene.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(newScene, transition: myTransition)
                currentGameState = gameState.ingame
            }
        }
    }
    
    
}

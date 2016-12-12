//
//  GameOverScene.swift
//  TomatoSky
//
//  Created by Mila Soares de Oliveira de Souza on 30/11/16.
//  Copyright © 2016 Mila Soares de Oliveira de Souza. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    var backgroundNode: SKNode!
    
    override func didMove(to view: SKView) {
        let restart = SKLabelNode(fontNamed: "Helvetica-UltraThin")
        decoration(label: restart, text: "Score: \(GameState.sharedInstance.score) \r \n Best Score: \(GameState.sharedInstance.highScore) \r \n Tap To Restart")
        addChild(restart)
        
        backgroundNode = createBackgroundNode()
        addChild(backgroundNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let fadeOut = SKTransition.fade(withDuration: 0.5)
        let gameScene = GameScene(size: self.size)
        self.view!.presentScene(gameScene, transition: fadeOut)
    }
    
}

extension GameOverScene {
    
    func decoration(label: SKLabelNode, text: String) {
        label.fontSize = 15
        label.fontColor = SKColor.white
        label.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        label.text = text
    
    }
    
    func createBackgroundNode() -> SKNode {
        let backgroundNode = SKNode()
        
        let bgColor = UIColor(red: 6/255, green: 214/255, blue: 255/255, alpha: 1)
        let colorNode = SKSpriteNode(color: bgColor, size: size)
        colorNode.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        colorNode.position = CGPoint(x: self.size.width / 2, y: 0)
        backgroundNode.addChild(colorNode)
        
        let floorColor = UIColor.gray //UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        let fs = CGSize(width: size.width, height:size.height/5)
        let floorNode = SKSpriteNode(color: floorColor, size: fs)
        floorNode.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        floorNode.position = CGPoint(x: self.size.width / 2, y: 0)
        backgroundNode.addChild(floorNode)
        
        let deadTomato = SKSpriteNode(imageNamed: "tomateMorto")
        deadTomato.anchorPoint = CGPoint(x:0.5, y: 0.0)
        deadTomato.position = CGPoint(x: self.size.width / 2, y: 30)
        backgroundNode.addChild(deadTomato)
        
        return backgroundNode
    }
}

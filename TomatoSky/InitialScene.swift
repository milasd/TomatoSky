//
//  InitialScene.swift
//  TomatoSky
//
//  Created by Mila Soares de Oliveira de Souza on 16/12/16.
//  Copyright © 2016 Mila Soares de Oliveira de Souza. All rights reserved.
//
import SpriteKit

class InitialScene: SKScene {
    var backgroundNode: SKNode!
    var scoreLabel: SKLabelNode!
    var newRecordLabel: SKLabelNode!
    var bestScoreLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        let bgColor = UIColor(red: 128/255, green: 231/255, blue: 255/255, alpha: 1)
        let colorNode = SKSpriteNode(color: bgColor, size: size)
        colorNode.zPosition = 0
        addChild(colorNode)
        
        let bgImage = SKSpriteNode(imageNamed: "telaInicial")
        let scalingFactor = bgImage.size.width / size.width
        bgImage.size.width *= scalingFactor
        bgImage.size.height *= scalingFactor
        //bgImage.anchorPoint = CGPoint(x: bgImage.frame.midX, y: bgImage.frame.midY)
        bgImage.position = CGPoint(x: size.width/2, y: size.height/2)
        bgImage.zPosition = 1
        addChild(bgImage)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let fadeOut = SKTransition.fade(withDuration: 0.5)
        let gameScene = GameScene(size: self.size)
        self.view!.presentScene(gameScene, transition: fadeOut)
    }
    
}

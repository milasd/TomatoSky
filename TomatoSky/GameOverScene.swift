//
//  GameOverScene.swift
//  TomatoSky
//
//  Created by Mila Soares de Oliveira de Souza on 30/11/16.
//  Copyright © 2016 Mila Soares de Oliveira de Souza. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    override func didMove(to view: SKView) {
        let restart = SKLabelNode(fontNamed: "Helvetica-UltraThin")
        decoration(label: restart, text: "Tap To Restart")
        addChild(restart)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let fadeOut = SKTransition.fade(withDuration: 0.5)
        let gameScene = GameScene(size: self.size)
        self.view!.presentScene(gameScene, transition: fadeOut)
    }
    
}

extension GameOverScene {
    
    func decoration(label: SKLabelNode, text: String) {
        label.fontSize = 35
        label.fontColor = SKColor.white
        label.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        label.text = text
    
    }

}

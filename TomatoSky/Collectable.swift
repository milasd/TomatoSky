//
//  Collectable.swift
//  TomatoSky
//
//  Created by Mila Soares de Oliveira de Souza on 30/11/16.
//  Copyright © 2016 Mila Soares de Oliveira de Souza. All rights reserved.
//

import SpriteKit

class Collectable: SKSpriteNode {
    
    init(){
        let s = CGSize(width: 20, height: 20)
        super.init(texture: nil, color: UIColor.white, size: s)
        physicsBody = Collectable.createPhysics(size: s)
    }
    
    private class func createPhysics(size: CGSize) -> SKPhysicsBody {
        let p = SKPhysicsBody(rectangleOf: size)
        
        p.friction = 0
        p.isDynamic = false
        p.usesPreciseCollisionDetection = true
        p.categoryBitMask = Mask.collectable.rawValue
        p.collisionBitMask = 0
        p.contactTestBitMask = Mask.tomato.rawValue | Mask.collectable.rawValue
        
        return p
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
//  GroundFloor.swift
//  TomatoSky
//
//  Created by Mila Soares de Oliveira de Souza on 12/12/16.
//  Copyright © 2016 Mila Soares de Oliveira de Souza. All rights reserved.
//

import SpriteKit

class GroundFloor: SKSpriteNode {

    init(){
        let s = CGSize(width: 1000, height: 80)
        super.init(texture: nil, color: UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1), size: s)
        physicsBody = GroundFloor.createPhysics(size: s)
    }
    
    private class func createPhysics(size: CGSize) -> SKPhysicsBody {
        let p = SKPhysicsBody(rectangleOf: size)
        
        p.friction = 0.5
        p.angularDamping = 1
        p.usesPreciseCollisionDetection = true
        p.categoryBitMask = Mask.platform.rawValue
        p.isDynamic = false
        
        return p
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

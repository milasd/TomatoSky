//
//  PlatformGenerator.swift
//  TomatoSky
//
//  Created by Mila Soares de Oliveira de Souza on 14/12/16.
//  Copyright © 2016 Mila Soares de Oliveira de Souza. All rights reserved.
//

import UIKit
import SpriteKit

extension GameScene {

    //let max: CGFloat = 500
    //let min: CGFloat = 100
    
    func generate(x:CGFloat, y:CGFloat, size: CGSize) -> (CGFloat, CGFloat) {
        let randomDistance = arc4random_uniform(100) + 100
        var randomAngle = Double(arc4random_uniform(180))
        let pi = Double(M_PI)
        randomAngle *=  pi / 180
        
        if randomAngle >= 0.83 * pi {
            randomAngle = randomAngle.truncatingRemainder(dividingBy: pi)
        }

        
        var targetX = CGFloat(randomDistance) * cos(CGFloat(randomAngle)) + x
        var targetY = CGFloat(randomDistance) * sin(CGFloat(randomAngle)) + y
        
        targetX = targetX.truncatingRemainder(dividingBy: size.width)
        
        if targetY - y < 100  {
            targetY = 100 + y
        }
        
        if targetY - y > 120 {
            targetY = 120 + y
        }
    
        return (targetX, targetY)
    }
    
}

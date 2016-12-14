//
//  PlatformGenerator.swift
//  TomatoSky
//
//  Created by Mila Soares de Oliveira de Souza on 14/12/16.
//  Copyright © 2016 Mila Soares de Oliveira de Souza. All rights reserved.
//

import UIKit
import SpriteKit

class PlatformGenerator {

    let max: CGFloat = 500
    let min: CGFloat = 100
    
    func generate(x:CGFloat, y:CGFloat, size: CGSize) -> (CGFloat, CGFloat) {
        let randomDistance = arc4random_uniform(400) + 100
        var randomAngle = arc4random_uniform(180)
        
        if randomAngle > 90 {
            randomAngle = 90 - randomAngle
        }
        
        var targetX = CGFloat(randomDistance) * cos(CGFloat(randomAngle)) + x
        var targetY = CGFloat(randomDistance) * sin(CGFloat(randomAngle)) + y
        
        targetX = targetX.truncatingRemainder(dividingBy: size.width)
    
        return (targetX, targetY)
    }
    
}

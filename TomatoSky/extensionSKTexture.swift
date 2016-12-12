//
//  extensionSKTexture.swift
//  TomatoSky
//
//  Created by Mila Soares de Oliveira de Souza on 12/12/16.
//  Copyright © 2016 Mila Soares de Oliveira de Souza. All rights reserved.
//

import UIKit
import SpriteKit

extension SKTexture {
    
    convenience init(size: CGSize, color1: CIColor, color2: CIColor) {
        let coreImageContext = CIContext(options: nil)
        let gradientFilter = CIFilter(name: "CILinearGradient")
        var startVector:CIVector
        var endVector:CIVector
        
        gradientFilter!.setDefaults()
        
        startVector = CIVector(x: size.width, y: size.height/2)
        endVector = CIVector(x: 0, y: size.height/2)
        
        gradientFilter!.setValue(startVector, forKey: "inputPoint0")
        gradientFilter!.setValue(endVector, forKey: "inputPoint1")
        gradientFilter!.setValue(color1, forKey: "inputColor0")
        gradientFilter!.setValue(color2, forKey: "inputColor1")
        let cgimg = coreImageContext.createCGImage(gradientFilter!.outputImage!, from: CGRect(x:0, y:0, width: size.width, height: size.height))
        
        self.init(cgImage: cgimg!)
    }
    
}

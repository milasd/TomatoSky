//
//  GameState.swift
//  TomatoSky
//
//  Created by Mila Soares de Oliveira de Souza on 06/12/16.
//  Copyright © 2016 Mila Soares de Oliveira de Souza. All rights reserved.
//

import Foundation

class GameState {
    
    var score: Int
    var highScore: Int
    
    class var sharedInstance: GameState {
        struct Singleton {
            static let instance = GameState()
        }
        return Singleton.instance
    }
    
    init() {
        score = 0
        highScore = 0
        
        let defaults = UserDefaults.standard
        highScore = defaults.integer(forKey: "highScore")
    }
    
    func saveState() {
        highScore = max(score, highScore)
        
        let defaults = UserDefaults.standard
        defaults.set(highScore, forKey: "highScore")
        UserDefaults.standard.synchronize()
    }
    
}

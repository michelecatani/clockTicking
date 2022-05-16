//
//  GameScene.swift
//  clock
//
//  Created by Michele Catani on 2022-05-14.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let clock = Clock(scene: self, center: CGPoint(x: 0, y: 0))
        self.backgroundColor = UIColor.white
        clock.start()
    }
}

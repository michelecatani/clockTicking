//
//  Clock.swift
//  clock
//
//  Created by Michele Catani on 2022-05-14.
//

import AVFoundation
import Foundation
import SpriteKit
import SceneKit

// Helper functions/constants

let angleOffset = -Double.pi / 2

func circleEdgePos(r: Double, phi: Double) -> CGPoint {
    return CGPoint(x: (r - 10) * cos(phi), y: (r - 10) * sin(phi))
}

func degsToRads(_ degrees: Double) -> Double {
    return 2 * Double.pi * degrees / 360
}

func secsToRad(_ seconds: Double) -> Double {
    let secondDegrees = 360.0 / 60.0
    return degsToRads(secondDegrees) * seconds + angleOffset
}

class Clock {
    
    var scene: SKScene
    
    var seconds: Double
    
    var radius: CGFloat
    
    var center: CGPoint
    
    var player: AVAudioPlayer
    
    var tickTock: Bool
    
    var previousLine: SKShapeNode?
    
    init(scene: SKScene, center: CGPoint) {
        seconds = 0
        self.radius = 100
        self.center = center
        self.player = AVAudioPlayer()
        self.tickTock = true
        self.scene = scene
    }
    
    private func drawFace() {
        let circle = SKShapeNode(circleOfRadius: radius)
        circle.fillColor = SKColor.black
        scene.addChild(circle)
    }
    
    private func drawHand() {
        let edge = circleEdgePos(r: radius, phi: -secsToRad(seconds))
        
        let handPath = CGMutablePath()
        handPath.move(to: center)
        handPath.addLine(to: edge)
        
        let lineWidth: CGFloat = 4
        let line = SKShapeNode()
        line.path = handPath
        line.lineWidth = lineWidth
        line.strokeColor = .gray
        
        scene.addChild(line)
        
        previousLine = line
    }
    
    @objc private func fireTimer() {
        previousLine?.removeFromParent() // If there is a previousLine, remove it from parent
        
        self.seconds += 1
        
        if tickTock {
            tick()
        } else {
            tock()
        }
        
        drawHand()
    }
    
    func tick() {
        let url = Bundle.main.url(forResource: "clockTick", withExtension: "mp3")
        self.player = try! AVAudioPlayer(contentsOf: url!)
        tickTock = !tickTock
        self.player.play()
    }
    
    func tock() {
        let url = Bundle.main.url(forResource: "clockTock", withExtension: "mp3")
        self.player = try! AVAudioPlayer(contentsOf: url!)
        tickTock = !tickTock
        self.player.play()
    }
    
    func start() {
        // do stuff
        fireTimer()
        tick()
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        drawFace()
        drawHand()
    }
}

//
//  GameScene.swift
//  SpriteKitTest
//
//  Created by João Gabriel Biazus de Quevedo on 31/08/21.


import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    
    // MARK: - Nodes
    
    private var background: SKSpriteNode = SKSpriteNode()
    
    // MARK: - Init
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        createBackground()
        
    }
    // MARK: - Function
    func createBackground(){
        let background = SKSpriteNode(imageNamed: "BG_with_streets")
        background.name = "Background"
        
        
        let backgroundSize = CGSize(width: (self.scene?.size.width)!, height: (self.scene?.size.height)!)
        background.size = backgroundSize
        
        addChild(background)
    }
    // MARK: - Update
    
    override func update(_ currentTime: TimeInterval) {
    }
}

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
    public lazy var cameraNode: Camera = {
        let cameraNode = Camera(sceneView: self.view!, scenario: background)
        cameraNode.position = CGPoint(x:UIScreen.main.bounds.width / 50, y: UIScreen.main.bounds.height / 3.25)
        cameraNode.applyZoomScale(scale: 0.6)
        
        return cameraNode
    }()
    
    
    
    // MARK: - Init
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        createBackground()
//        createFactory()
        camera = cameraNode
        addChild(cameraNode)


    }
    // MARK: - Function
    func createBackground(){
        background = SKSpriteNode(imageNamed: "BG_with_streets")
        background.name = "Background"
        
        
        background.addChild(createFactory())
        addChild(background)
    }
    
    
    /**
     Create player object with physics.
     */
    func createFactory() -> SKSpriteNode  {
        let factory = SKSpriteNode(imageNamed:"Factory_NFT_grande")
        factory.name = "factory"
        factory.anchorPoint = CGPoint(x: 0.5, y: 0)
        factory.zPosition = 1

        factory.position = CGPoint(x: -417.78, y: -68.25)

        return factory
    }
    
    
    // MARK: - Update
    
    override func update(_ currentTime: TimeInterval) {
    }
}

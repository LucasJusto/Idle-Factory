//
//  FactoryScene.swift
//  Idle Factory
//
//  Created by Felipe Grosze Nipper de Oliveira on 10/11/21.
//

import SpriteKit

class FactoryScene: SKScene {
    
    static var thisFactory:Factory? = nil
    static var thiscolor:String? = nil
    
    var background: SKSpriteNode = SKSpriteNode()
    var factoryNode:SKSpriteNode =  SKSpriteNode()
    
    public lazy var cameraNode: Camera = {
        let cameraNode = Camera(sceneView: self.view!, scenario: background)
        //cameraNode.position = CGPoint(x: GameScene.deviceScreenWidth / 50, y: GameScene.deviceScreenHeight / 4)
        //cameraNode.applyZoomScale(scale: 0.13)
        
        return cameraNode
    }()
    
    override func didMove(to view: SKView) {
        print(#function)
        if let factory = FactoryScene.thisFactory {
            factoryNode = factory.node
        }
        else {
            factoryNode = SKSpriteNode()
        }
        if let color = FactoryScene.thiscolor {
            background.color = UIColor(named: color)!
        }
        else {
            background.color = .white
        }
        factoryNode.size = CGSize(width: 460, height: 270)
        factoryNode.anchorPoint = CGPoint(x: 0.5, y: 0)
        background.size = CGSize(width: self.size.width , height: self.size.height)
        self.anchorPoint = CGPoint(x: 0.5, y: 0)
        background.anchorPoint = CGPoint(x: 0.5, y: 0)
        addChild(background)
        factoryNode.position.y = 10
        factoryNode.setScale(0.7)
//        factoryNode.enumerateChildNodes(withName: "*") { node, _ in
//            node.setScale(0.5)
//        }
        //factoryNode.zPosition = 10000000
        addChild(factoryNode)
        cameraNode.position = CGPoint(x: 0, y: 0)
        //camera?.setScale(0.5)
        
//        camera = cameraNode
//        addChild(cameraNode)
    }
}

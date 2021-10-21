//
//  GameInventory.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 21/10/21.
//

import SpriteKit

class GameInventoryScene: SKScene {
    
    // MARK: - Device Width and Height variables
    private var deviceWidth = UIScreen.main.bounds.width
    private var deviceHeight = UIScreen.main.bounds.height
    
    // MARK: - Player Inventory Scene display components
    private(set) var sceneBackground: SKShapeNode = SKShapeNode()
    
    
    /**
     Create the scene background.
     */
    func createBackground() -> SKShapeNode {
        sceneBackground = SKShapeNode(rect: CGRect(x: 0, y: 0, width: (deviceWidth), height: (deviceHeight)))
        sceneBackground.fillColor = UIColor(named: "HudActions-background")!
        sceneBackground.zPosition = 10
        return sceneBackground
    }
    
    
    /**
     Create the button to close the actual scene.
     */
    func createCloseButton() -> SKSpriteNode {
        let closeAction = SKSpriteNode(color: .white, size: CGSize(width: 90, height: 90))
        closeAction.name = "CloseInventoryScene"
        closeAction.zPosition = 11
        return closeAction
    }
    
    
}

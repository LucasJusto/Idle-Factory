//
//  GameChallengeScene.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 21/10/21.
//

import SpriteKit

class GameChallengeScene: SKScene {
    
    // MARK: - Challenge Scene display components
    private(set) var sceneBackground: SKShapeNode = SKShapeNode()
    
    
    /**
     Create the scene background.
     */
    func createBackground() -> SKShapeNode {
        sceneBackground = SKShapeNode(rect: CGRect(x: 0, y: 0, width: (GameScene.deviceScreenWidth
), height: (GameScene.deviceScreenHeight)))
        sceneBackground.fillColor = UIColor(named: "HudActions-background")!
        sceneBackground.zPosition = 10
        return sceneBackground
    }
    
    
    /**
     Create the button to close the actual scene.
     */
    func createCloseButton() -> SKSpriteNode {
        let closeAction = SKSpriteNode(color: .white, size: CGSize(width: 90, height: 90))
        closeAction.name = "CloseChallengeScene"
        closeAction.zPosition = 11
        return closeAction
    }
}

//
//  GameChallengeScene.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 21/10/21.
//

import SpriteKit

class GameChallengeScene: SKScene {
    
    // MARK: - Device Width and Height variables
    private var deviceWidth = UIScreen.main.bounds.width
    private var deviceHeight = UIScreen.main.bounds.height
    
    // MARK: - Challenge Scene display components
    private(set) var sceneBackground: SKShapeNode = SKShapeNode()
    
    
    func createBackground() -> SKShapeNode {
        sceneBackground = SKShapeNode(rect: CGRect(x: 0, y: 0, width: (deviceWidth), height: (deviceHeight)))
        sceneBackground.fillColor = .white
        sceneBackground.strokeColor = .white
        sceneBackground.zPosition = 3
        return sceneBackground
    }
}

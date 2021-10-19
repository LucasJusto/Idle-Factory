//
//  GameScene.swift
//  SpriteKitTest
//
//  Created by João Gabriel Biazus de Quevedo on 31/08/21.


import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    
    
    // MARK: - Factory positions
    private(set) var factoriesPositions: [(x: CGFloat, y: CGFloat)] =
        [
            (x: -417.78, y: -68.25),
            (x: -114.40, y: 110),
            (x: -117.40, y: -235),
            (x: 184.78, y: -68.25),
            (x: 181.78, y: -410),
            (x: 480.70, y: -235)
        ]
    
    // MARK: - GAME HUD
    private var gameHud: GameHud = GameHud()
    
    
    // MARK: - Nodes
    private var background: SKSpriteNode = SKSpriteNode()
    public lazy var cameraNode: Camera = {
        let cameraNode = Camera(sceneView: self.view!, scenario: background)
        cameraNode.position = CGPoint(x:UIScreen.main.bounds.width / 50, y: UIScreen.main.bounds.height / 4)
        cameraNode.applyZoomScale(scale: 0.43)
        
        return cameraNode
    }()
    
    
    
    // MARK: - Init
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        createBackground()
        createTopHud()
        createSidebarHud()
        addFactory(position: .first)
        addFactory(position: .second)
        addFactory(position: .third)
        addFactory(position: .fourth)
        addFactory(position: .fifth)
        addFactory(position: .sixth)

        camera = cameraNode
        addChild(cameraNode)


    }
    // MARK: - Function
    func createBackground(){
        background = SKSpriteNode(imageNamed: "BG_Streets")
        background.name = "Background"
                
        addChild(background)
    }
    
    
    /**
     Create and displays top hud of the game.
     */
    func createTopHud() {
        
        // Top HUD background creation
        let mainCurrencyHudBackground = gameHud.createTopHudBackground(xPos: 50)
        let premiumHudBackground = gameHud.createTopHudBackground(xPos: mainCurrencyHudBackground.calculateAccumulatedFrame().width + 60)
        
        // Main and Premium Currency info creation
        let mainCurrencyIcon = gameHud.createMainCurrencyIcon()
        let mainCurrencyData = gameHud.createMainCurrencyLabel()
        let premiumCurrencyIcon = gameHud.createPremiumCurrencyIcon()
        let premiumCurrencyData = gameHud.createPremiumCurrency()
        
        // Positioning currencies on the device
        mainCurrencyIcon.position = CGPoint(x: -((UIScreen.main.bounds.width) / 2) + 80, y: ((UIScreen.main.bounds.height) / 3) + 25)
        mainCurrencyData.position = CGPoint(x: mainCurrencyIcon.position.x + 50, y: ((UIScreen.main.bounds.height) / 3) + 18)
        premiumCurrencyIcon.position = CGPoint(x: -((UIScreen.main.bounds.width) / 2) + 215, y: ((UIScreen.main.bounds.height) / 3) + 25)
        premiumCurrencyData.position = CGPoint(x: premiumCurrencyIcon.position.x + 50, y: ((UIScreen.main.bounds.height) / 3) + 18)

        
        // Adds Hud as a child of the camera to keep Hud always on the camera
        cameraNode.addChild(mainCurrencyHudBackground)
        cameraNode.addChild(premiumHudBackground)
        
        mainCurrencyHudBackground.addChild(mainCurrencyIcon)
        mainCurrencyHudBackground.addChild(mainCurrencyData)
        premiumHudBackground.addChild(premiumCurrencyIcon)
        premiumHudBackground.addChild(premiumCurrencyData)
    
    }
    
    
    /**
     Create and displays sidebar hud of the game.
     */
    func createSidebarHud() {
        
        // Sidebar background creation
        let sidebarBackground = gameHud.createSidebarBackground()
        
        // HUD action buttons creation
        let marketPlaceButton = gameHud.createMarketplaceButton()
        let challengeButton = gameHud.createChallengeButton()
        
        // Positioning buttons on the device
        marketPlaceButton.position = CGPoint(x: ((UIScreen.main.bounds.width) / 2.31), y: -30)
        challengeButton.position = CGPoint(x: ((UIScreen.main.bounds.width) / 2.31), y: -120)

        // Add to scene
        cameraNode.addChild(sidebarBackground)
        sidebarBackground.addChild(marketPlaceButton)
        sidebarBackground.addChild(challengeButton)
    }
    
    
    /**
     Add a factory on the scene. Receives a position which represents what slot player wants to add the new factory.
     */
    func addFactory(position: GeneratorPositions) {
        let factory = createFactory()
        
        switch position {
        case .first:
            factory.position = CGPoint(x: factoriesPositions[0].x, y: factoriesPositions[0].y)
            factory.zPosition = 2
        case .second:
            factory.position = CGPoint(x: factoriesPositions[1].x, y: factoriesPositions[1].y)
            factory.zPosition = 1
        case .third:
            factory.position = CGPoint(x: factoriesPositions[2].x, y: factoriesPositions[2].y)
            factory.zPosition = 2
        case .fourth:
            factory.position = CGPoint(x: factoriesPositions[3].x, y: factoriesPositions[3].y)
            factory.zPosition = 1
        case .fifth:
            factory.position = CGPoint(x: factoriesPositions[4].x, y: factoriesPositions[4].y)
            factory.zPosition = 2
        case .sixth:
            factory.position = CGPoint(x: factoriesPositions[5].x, y: factoriesPositions[5].y)
            factory.zPosition = 1
        }
        
        background.addChild(factory)
    }
    
    
    /**
     Create factory.
     */
    func createFactory() -> SKSpriteNode  {
        let factory = SKSpriteNode(imageNamed:"Factory_NFT_grande")
        factory.anchorPoint = CGPoint(x: 0.5, y: 0)
        factory.name = "factory"

        return factory
    }
    
    
    // MARK: - Update
    
    override func update(_ currentTime: TimeInterval) {
    }
}

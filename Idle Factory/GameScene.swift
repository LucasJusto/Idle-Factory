//
//  GameScene.swift
//  SpriteKitTest
//
//  Created by João Gabriel Biazus de Quevedo on 31/08/21.


import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    
    
    // MARK: - Device Width and Height variables
    private(set) static var deviceScreenWidth = UIScreen.main.bounds.width
    private(set) static var deviceScreenHeight = UIScreen.main.bounds.height
    
    
    // MARK: - FACTORY POSITIONS
    private(set) var factoriesPositions: [(x: CGFloat, y: CGFloat)] =
    [
        (x: -417.78, y: -68.25),
        (x: -114.40, y: 110),
        (x: -117.40, y: -235),
        (x: 184.78, y: -68.25),
        (x: 181.78, y: -410),
        (x: 480.70, y: -235)
    ]
    
    // MARK: - GAME HUD & HUD SCENE ACTIONS
    private var gameHud: GameHud = GameHud()
    private var actionShapeNode: SKShapeNode = SKShapeNode()
    
    private(set) var gameInventoryScene: GameInventoryScene = GameInventoryScene()
    private(set) var gameMarketplaceScene: GameMarketplaceScene = GameMarketplaceScene()
    private(set) var gameChallengeScene: GameChallengeScene = GameChallengeScene()
    
    
    // MARK: - perSecIncrement
    lazy var perSecIncrement: SKAction = {
        let incrementAction = SKAction.run {
            if var generators = GameScene.user?.generators {
                var perSecTotal: Double = 0.0
                for n in 0..<generators.count {
                    if(generators[n].isActive == IsActive.yes){
                        let perSec : Double = generators[n].getCurrencyPerSec()
                        GameScene.user?.addMainCurrency(value: perSec)
                        perSecTotal += perSec
                    }
                }
                self.gameHud.mainCurrencyValue.text = "\(doubleToString(value:GameScene.user?.mainCurrency ?? 0.0))"
                self.gameHud.generatingResourceValue.text = "+ \(doubleToString(value: perSecTotal))/s"
            }
        }
        let delay = SKAction.wait(forDuration: 1)
        
        let sequence = SKAction.sequence([delay, incrementAction])
        
        let actionForever = SKAction.repeatForever(sequence)
        
        return actionForever
    }()

    
    // MARK: - Nodes
    private var background: SKSpriteNode = SKSpriteNode()
    private var loadingScreen: SKSpriteNode = SKSpriteNode()
    static var user: User? = nil
    public lazy var cameraNode: Camera = {
        let cameraNode = Camera(sceneView: self.view!, scenario: background)
        cameraNode.position = CGPoint(x: GameScene.deviceScreenWidth / 50, y: GameScene.deviceScreenHeight / 4)
        cameraNode.applyZoomScale(scale: 0.43)
        
        return cameraNode
    }()
    
    
    // MARK: - INIT
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
        
        
//        CKRepository.storeNewGenerator(userID: GameScene.user?.id ?? "", generator: Factory(resourcesArray: [Resource( basePrice: 2, baseQtt: 2, currentLevel: 1, qttPLevel: 2, type: ResourceType.computador, pricePLevelIncreaseTax: 1)], energy: 3, type: FactoryType.Basic, texture: "", position: GeneratorPositions.first, isActive: IsActive.yes), completion: {_,_ in })
        
        startIncrement()
        
    }
    
    
    // MARK: - TOUCH SCREEN EVENTS
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if(touchedNode.name == "PlayerInventoryButton"){
                displayInventory()
                //self.removeAllChildren()
            }
            if(touchedNode.name == "MarketplaceButton") {
                displayMarketplace()
                //self.removeAllChildren()
            }
            if touchedNode.name == "ChallengeButton" {
                displayChallenge()
            }
            
            if (
                touchedNode.name == "CloseInventoryScene" ||
                touchedNode.name == "CloseMarketplaceScene" ||
                touchedNode.name == "CloseChallengeScene"
               ) {
                actionShapeNode.removeFromParent()
            }
        }
    }
    
    
    // MARK: - INCREMENTAL CONTROL
    func startIncrement() {
        run(perSecIncrement, withKey: "perSecIncrement")
    }
    
    func stopIncrement() {
        removeAction(forKey: "perSecIncrement")
    }
    
    
    
    // MARK: - BACKGROUND & HUD Creation
    /**
     Create scene background.
     */
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
        let resourceGeneratorBackground = gameHud.createTopHudGenerationBackground()
        
        // Main / Premium Currency & resource generation per sec info creation
        let mainCurrencyIcon = gameHud.createMainCurrencyIcon()
        let mainCurrencyData = gameHud.createMainCurrencyLabel()
        let premiumCurrencyIcon = gameHud.createPremiumCurrencyIcon()
        let premiumCurrencyData = gameHud.createPremiumCurrency()
        let generatorResource = gameHud.createGenerateResource()
        
        // Check if device height (it turns the width when device is on horizontal) is equals to 926 to fix position (iPhone 12 and 13 Pro MAX versions). This condition only exists to fix the premium currency component position on PRO MAX devices.
        let positionX = GameScene.deviceScreenWidth == 926 ? (-((GameScene.deviceScreenWidth) / 2) + 230) : (-((GameScene.deviceScreenWidth) / 2) + 215)
        
        // Positioning all info datas on the device
        mainCurrencyIcon.position = CGPoint(x: -((GameScene.deviceScreenWidth) / 2) + 80, y: ((GameScene.deviceScreenHeight) / 3) + 25)
        mainCurrencyData.position = CGPoint(x: mainCurrencyIcon.position.x + 50, y: ((GameScene.deviceScreenHeight) / 3) + 18)
        premiumCurrencyIcon.position = CGPoint(x: positionX, y: ((GameScene.deviceScreenHeight) / 3) + 25)
        premiumCurrencyData.position = CGPoint(x: premiumCurrencyIcon.position.x + 45, y: ((GameScene.deviceScreenHeight) / 3) + 18)
        generatorResource.position = CGPoint(x: -((GameScene.deviceScreenWidth) / 2) + 90, y: ((GameScene.deviceScreenHeight) / 3) - 7)
        
        
        // Adds all Hud components as a child of the camera to keep Hud always on the camera
        cameraNode.addChild(mainCurrencyHudBackground)
        cameraNode.addChild(premiumHudBackground)
        cameraNode.addChild(resourceGeneratorBackground)
        
        mainCurrencyHudBackground.addChild(mainCurrencyIcon)
        mainCurrencyHudBackground.addChild(mainCurrencyData)
        premiumHudBackground.addChild(premiumCurrencyIcon)
        premiumHudBackground.addChild(premiumCurrencyData)
        mainCurrencyHudBackground.addChild(generatorResource)
        
    }
    
    
    /**
     Create and displays sidebar hud of the game.
     */
    func createSidebarHud() {
        
        // Sidebar background creation
        let sidebarBackground = gameHud.createSidebarBackground()
        
        // HUD action buttons creation
        let inventoryButton = gameHud.createInventoryButton()
        let marketPlaceButton = gameHud.createMarketplaceButton()
        let challengeButton = gameHud.createChallengeButton()
        
        // Positioning buttons on the device
        inventoryButton.position = CGPoint(x: ((GameScene.deviceScreenWidth) / 2.31), y: 50)
        marketPlaceButton.position = CGPoint(x: ((GameScene.deviceScreenWidth) / 2.31), y: -30)
        challengeButton.position = CGPoint(x: ((GameScene.deviceScreenWidth) / 2.31), y: -123)
        
        // Add to scene
        cameraNode.addChild(sidebarBackground)
        sidebarBackground.addChild(inventoryButton)
        sidebarBackground.addChild(marketPlaceButton)
        sidebarBackground.addChild(challengeButton)
    }
    
    
    // MARK: - GENERATORS FUNCTIONS
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
        case .none:
            let _ = 0
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
    
    
    // MARK: - RIGHTBAR INTERACTIONS
    /**
     Display player inventory.
     */
    func displayInventory() {
        
        let inventoryScene = gameInventoryScene.createBackground()
        let closeAction = gameInventoryScene.createCloseButton()
        actionShapeNode = inventoryScene
        
        inventoryScene.position = CGPoint(x: -(GameScene.deviceScreenWidth) / 2, y: -(GameScene.deviceScreenHeight) / 2)
        closeAction.position = CGPoint(x: (GameScene.deviceScreenWidth) / 2, y: (GameScene.deviceScreenHeight) / 2)

        cameraNode.addChild(actionShapeNode)
        inventoryScene.addChild(closeAction)
    }
    
    
    /**
     Display marketplace.
     */
    func displayMarketplace() {
        
        let marketplaceScene = gameMarketplaceScene.createBackground()
        let closeAction = gameMarketplaceScene.createCloseButton()
        actionShapeNode = marketplaceScene
        
        marketplaceScene.position = CGPoint(x: -(GameScene.deviceScreenWidth) / 2, y: -(GameScene.deviceScreenHeight) / 2)
        closeAction.position = CGPoint(x: (GameScene.deviceScreenWidth) / 2, y: (GameScene.deviceScreenHeight) / 2)

        cameraNode.addChild(actionShapeNode)
        marketplaceScene.addChild(closeAction)
    }
    
    
    /**
     Display challenge.
     */
    func displayChallenge() {
        
        let challengeScene = gameChallengeScene.createBackground()
        let closeAction = gameChallengeScene.createCloseButton()
        
        actionShapeNode = challengeScene
        challengeScene.position = CGPoint(x: -(GameScene.deviceScreenWidth) / 2, y: -(GameScene.deviceScreenHeight) / 2)
        closeAction.position = CGPoint(x: (GameScene.deviceScreenWidth) / 2, y: (GameScene.deviceScreenHeight) / 2)

        cameraNode.addChild(actionShapeNode)
        challengeScene.addChild(closeAction)
    }
    
    
    // MARK: - Update
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}

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
    private(set) var factoriesPositions: [(slot: SKSpriteNode, x: CGFloat, y: CGFloat)] =
    [
        (slot: SKSpriteNode(imageNamed: "Factory_add_new"), x: -417.78, y: -68.25),
        (slot: SKSpriteNode(imageNamed: "Factory_add_new"), x: -114.40, y: 110),
        (slot: SKSpriteNode(imageNamed: "Factory_add_new"), x: -117.40, y: -235),
        (slot: SKSpriteNode(imageNamed: "Factory_add_new"), x: 184.78, y: -68.25),
        (slot: SKSpriteNode(imageNamed: "Factory_add_new"), x: 181.78, y: -410),
        (slot: SKSpriteNode(imageNamed: "Factory_add_new"), x: 480.70, y: -235)
    ]

    
    // MARK: - GAME HUD & HUD SCENE ACTIONS
    private var gameHud: GameHud = GameHud()
    private var actionShapeNode: SKShapeNode = SKShapeNode()
    
    private(set) var gameInventoryScene: GameInventorySceneController = GameInventorySceneController()
    private(set) var gameMarketplaceScene: GameMarketplaceSceneController = GameMarketplaceSceneController()
    private(set) var gameChallengeScene: GameChallengeSceneController = GameChallengeSceneController()
    
    
    // MARK: - PERSECINCREMENT
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
        createSceneSlots()
        
        loadPlayerFactories()
        
        camera = cameraNode
        addChild(cameraNode)
        
        startIncrement()
        
    }
    
    
    // MARK: - TOUCH SCREEN EVENTS
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            switch touchedNode.name {
            case "PlayerInventoryButton":
                displayInventory(clickedSource: "AnnounceFactoryButton")
            case "MarketplaceButton":
                displayMarketplace()
            case "ChallengeButton":
                displayChallenge()
            case "factory_slot_0_empty":
                displayInventory(clickedSource: "InsertFactoryButton")
            case "factory_slot_1_empty":
                displayInventory(clickedSource: "InsertFactoryButton")
            case "factory_slot_2_empty":
                displayInventory(clickedSource: "InsertFactoryButton")
            case "factory_slot_3_empty":
                displayInventory(clickedSource: "InsertFactoryButton")
            case "factory_slot_4_empty":
                displayInventory(clickedSource: "InsertFactoryButton")
            case "factory_slot_5_empty":
                displayInventory(clickedSource: "InsertFactoryButton")
            case "factory_slot_0_occupied":
                displayUpgradeFactory()
            case "factory_slot_1_occupied":
                displayUpgradeFactory()
            case "factory_slot_2_occupied":
                displayUpgradeFactory()
            case "factory_slot_3_occupied":
                displayUpgradeFactory()
            case "factory_slot_4_occupied":
                displayUpgradeFactory()
            case "factory_slot_5_occupied":
                displayUpgradeFactory()
            default: return
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
    
    
    
    // MARK: - BACKGROUND & HUD CREATION
    /**
     Create scene background.
     */
    func createBackground(){
        background = SKSpriteNode(imageNamed: "BG_Streets")
        background.name = "Background"
        
        addChild(background)
    }
    
    
    /**
     Create all slots on the scene where can be replaced by a generator.
     */
    func createSceneSlots() {
        for n in 0..<factoriesPositions.count {
            let slot = factoriesPositions[n].slot
            slot.anchorPoint = CGPoint(x: 0.5, y: 0)
            slot.position = CGPoint(x: factoriesPositions[n].x, y: factoriesPositions[n].y)
            slot.zPosition = 1
            slot.name = "factory_slot_\(n)_empty"
            background.addChild(slot)
        }
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
        let premiumCurrencyData = gameHud.createPremiumCurrencyLabel()
        let generatorResource = gameHud.createGenerateResourceLabel()
        
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
     Load player active factories on the scene.
     */
    func loadPlayerFactories() {
        for n in 0..<(GameScene.user?.generators.count ?? 0){
            if GameScene.user?.generators[n].isActive == .yes {
                addFactory(factory: (GameScene.user?.generators[n])!)
            }
        }
    }
    
    
    /**
     Add a factory on the scene. Receives a Factory which checks what slot this factory is located.
     */
    func addFactory(factory: Factory) {
                
        switch factory.position {
        case .first:
            factoriesPositions[0].slot.texture = SKTexture(imageNamed: factory.textureName)
            factoriesPositions[0].slot.name = "factory_slot_0_occupied"
            factory.node.zPosition = 2
        case .second:
            factoriesPositions[1].slot.texture = SKTexture(imageNamed: factory.textureName)
            factoriesPositions[1].slot.name = "factory_slot_1_occupied"
            factory.node.zPosition = 2
        case .third:
            factoriesPositions[2].slot.texture = SKTexture(imageNamed: factory.textureName)
            factoriesPositions[2].slot.name = "factory_slot_2_occupied"
            factory.node.zPosition = 2
        case .fourth:
            factoriesPositions[3].slot.texture = SKTexture(imageNamed: factory.textureName)
            factoriesPositions[3].slot.name = "factory_slot_3_occupied"
            factory.node.zPosition = 1
        case .fifth:
            factoriesPositions[4].slot.texture = SKTexture(imageNamed: factory.textureName)
            factoriesPositions[4].slot.name = "factory_slot_4_occupied"
            factory.node.zPosition = 2
        case .sixth:
            factoriesPositions[5].slot.texture = SKTexture(imageNamed: factory.textureName)
            factoriesPositions[5].slot.name = "factory_slot_5_occupied"
            factory.node.zPosition = 1
        case .none:
            let _ = 0
        }
        
    }
    
    
    func displayUpgradeFactory() {
        let viewController = UIApplication.shared.windows.first!.rootViewController as! GameViewController
        viewController.displayUpgradeFactory()
    }
    
    
    // MARK: - RIGHTBAR INTERACTIONS
    /**
     Display player inventory. Receives from where the player clicked to enter in the scene. Depending on where clicked, different options is displayed inside inventory.
     */
    func displayInventory(clickedSource: String) {
        let viewController = UIApplication.shared.windows.first!.rootViewController as! GameViewController
        viewController.displayInventory(clickedSource: clickedSource)
    }
    
    
    /**
     Display marketplace.
     */
    func displayMarketplace() {
        let viewController = UIApplication.shared.windows.first!.rootViewController as! GameViewController
        viewController.displayMarketplace()
    }
    
    
    /**
     Display challenge.
     */
    func displayChallenge() {
        let viewController = UIApplication.shared.windows.first!.rootViewController as! GameViewController
        viewController.displayChallenge()
    }
    
    
    // MARK: - Update
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}

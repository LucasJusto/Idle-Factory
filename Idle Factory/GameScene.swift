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
    static var factoriesPositions: [(slot: SKSpriteNode, x: CGFloat, y: CGFloat)] =
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
                self.gameHud.premiumCurrencyValue.text = "\(doubleToString(value:GameScene.user?.premiumCurrency ?? 0.0))"
                self.gameHud.generatingResourceValue.text = "+ \(doubleToString(value: perSecTotal))/s"
            }
        }
        let delay = SKAction.wait(forDuration: 1)
        let sequence = SKAction.sequence([delay, incrementAction])
        let actionForever = SKAction.repeatForever(sequence)
        
        return actionForever
    }()
    
    
    // MARK: - NODES
    var background: SKSpriteNode = SKSpriteNode()
    private var loadingScreen: SKSpriteNode = SKSpriteNode()
    public lazy var cameraNode: Camera = {
        let cameraNode = Camera(sceneView: self.view!, scenario: background)
        cameraNode.position = CGPoint(x: GameScene.deviceScreenWidth / 50, y: GameScene.deviceScreenHeight / 4)
        cameraNode.applyZoomScale(scale: 0.43)
        
        return cameraNode
    }()
    
    
    // MARK: - USER
    static var user: User? = nil
    
    
    // MARK: - INIT
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        createBackground()
        createSceneSlots()
        createTopHud()
        createSidebarHud()
        
        loadPlayerFactories()
        
        camera = cameraNode
        addChild(cameraNode)
        
        startIncrement()
                
//        for g in GameScene.user!.generators {
//            CKRepository.deleteGeneratorByID(generator: g, completion: { _ in
//            })
//        }

    }
    
    
    // MARK: - TOUCH SCREEN EVENTS
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            switch touchedNode.name {
            case "GameSettingsButton":
                displaySettings()
            case "PlayerInventoryButton":
                displayInventory()
            case "ShopButton":
                displayShop()
            case "MarketplaceButton":
                displayMarketplace()
            case"ChallengeButton":
                displayChallenge()
            case "factory_slot_0_empty":
                selectGeneratorToInsert(position: .first)
            case "factory_slot_1_empty":
                selectGeneratorToInsert(position: .second)
            case "factory_slot_2_empty":
                selectGeneratorToInsert(position: .third)
            case "factory_slot_3_empty":
                selectGeneratorToInsert(position: .fourth)
            case "factory_slot_4_empty":
                selectGeneratorToInsert(position: .fifth)
            case "factory_slot_5_empty":
                selectGeneratorToInsert(position: .sixth)
            case "factory_slot_0_occupied":
                UpgradeFactorySceneController.generator = searchActiveFactory(position: .first)
                displayUpgradeFactory()
            case "factory_slot_1_occupied":
                UpgradeFactorySceneController.generator = searchActiveFactory(position: .second)
                displayUpgradeFactory()
            case "factory_slot_2_occupied":
                UpgradeFactorySceneController.generator = searchActiveFactory(position: .third)
                displayUpgradeFactory()
            case "factory_slot_3_occupied":
                UpgradeFactorySceneController.generator = searchActiveFactory(position: .fourth)
                displayUpgradeFactory()
            case "factory_slot_4_occupied":
                UpgradeFactorySceneController.generator = searchActiveFactory(position: .fifth)
                displayUpgradeFactory()
            case "factory_slot_5_occupied":
                UpgradeFactorySceneController.generator = searchActiveFactory(position: .sixth)
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
        for n in 0..<GameScene.factoriesPositions.count {
            let slot = GameScene.factoriesPositions[n].slot
            slot.anchorPoint = CGPoint(x: 0.5, y: 0)
            slot.position = CGPoint(x: GameScene.factoriesPositions[n].x, y: GameScene.factoriesPositions[n].y)
            slot.zPosition = 1
            slot.name = "factory_slot_\(n)_empty"
            slot.removeFromParent()
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
        let settingsButton = gameHud.createSettingsButton()
        let marketPlaceButton = gameHud.createMarketplaceButton()
        let inventoryButton = gameHud.createInventoryButton()
        let shopButton = gameHud.createShopButton()
        let challengeButton = gameHud.createChallengeButton()
        
        // Positioning buttons on the device
        settingsButton.position = CGPoint(x: ((GameScene.deviceScreenWidth) / 2.31), y: 130)
        marketPlaceButton.position = CGPoint(x: ((GameScene.deviceScreenWidth) / 2.31), y: 10)
        inventoryButton.position = CGPoint(x: ((GameScene.deviceScreenWidth) / 2.31), y: -65)
        shopButton.position = CGPoint(x: ((GameScene.deviceScreenWidth) / 2.31), y: -140)
        challengeButton.position = CGPoint(x: -((GameScene.deviceScreenWidth) / 2.55), y: -123)

        // Add to scene
        cameraNode.addChild(sidebarBackground)
        sidebarBackground.addChild(settingsButton)
        sidebarBackground.addChild(marketPlaceButton)
        sidebarBackground.addChild(inventoryButton)
        sidebarBackground.addChild(shopButton)
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
     Search for the factory receiving the position as argument. Return nil if nothing is found.
     */
    func searchActiveFactory(position: GeneratorPositions) -> Factory? {
        let activeFactories = GameScene.user?.generators.filter({ factory in
            factory.isActive == .yes
        })
        
        if let factories = activeFactories {
            for factory in factories {
                if factory.position == position {
                    return factory
                }
            }
        }
        return nil
    }
    
    
    /**
     Add a factory on the scene. Receives a Factory which checks what slot this factory is located.
     */
     func addFactory(factory: Factory) {
        switch factory.position {
        case .first:
            if factory.type == .Basic {
                GameScene.factoriesPositions[0].slot.texture = SKTexture(imageNamed: factory.textureName)
                GameScene.factoriesPositions[0].slot.name = "factory_slot_0_occupied"
            } else {
                factory.node.position = GameScene.factoriesPositions[0].slot.position
                GameScene.factoriesPositions[0].slot.removeFromParent()
                GameScene.factoriesPositions[0].slot = factory.node
                changeAllNodeFamilyNames(node: factory.node, name: "factory_slot_0_occupied")
                background.addChild(factory.node)
            }
            factory.node.zPosition = 5
        case .second:
            if factory.type == .Basic {
                GameScene.factoriesPositions[1].slot.texture = SKTexture(imageNamed: factory.textureName)
                GameScene.factoriesPositions[1].slot.name = "factory_slot_1_occupied"
            } else {
                factory.node.position = GameScene.factoriesPositions[1].slot.position
                GameScene.factoriesPositions[1].slot.removeFromParent()
                GameScene.factoriesPositions[1].slot = factory.node
                changeAllNodeFamilyNames(node: factory.node, name: "factory_slot_1_occupied")
                background.addChild(factory.node)
            }
            factory.node.zPosition = 2
        case .third:
            if factory.type == .Basic {
                GameScene.factoriesPositions[2].slot.texture = SKTexture(imageNamed: factory.textureName)
                GameScene.factoriesPositions[2].slot.name = "factory_slot_2_occupied"
            } else {
                factory.node.position = GameScene.factoriesPositions[2].slot.position
                GameScene.factoriesPositions[2].slot.removeFromParent()
                GameScene.factoriesPositions[2].slot = factory.node
                changeAllNodeFamilyNames(node: factory.node, name: "factory_slot_2_occupied")
                background.addChild(factory.node)
            }
            factory.node.zPosition = 20
        case .fourth:
            if factory.type == .Basic {
                GameScene.factoriesPositions[3].slot.texture = SKTexture(imageNamed: factory.textureName)
                GameScene.factoriesPositions[3].slot.name = "factory_slot_3_occupied"
            } else {
                factory.node.position = GameScene.factoriesPositions[3].slot.position
                GameScene.factoriesPositions[3].slot.removeFromParent()
                GameScene.factoriesPositions[3].slot = factory.node
                changeAllNodeFamilyNames(node: factory.node, name: "factory_slot_3_occupied")
                background.addChild(factory.node)
            }
            factory.node.zPosition = 15
        case .fifth:
            if factory.type == .Basic {
                GameScene.factoriesPositions[4].slot.texture = SKTexture(imageNamed: factory.textureName)
                GameScene.factoriesPositions[4].slot.name = "factory_slot_4_occupied"
            } else {
                factory.node.position = GameScene.factoriesPositions[4].slot.position
                GameScene.factoriesPositions[4].slot.removeFromParent()
                GameScene.factoriesPositions[4].slot = factory.node
                changeAllNodeFamilyNames(node: factory.node, name: "factory_slot_4_occupied")
                background.addChild(factory.node)
            }
            factory.node.zPosition = 25
        case .sixth:
            if factory.type == .Basic {
                GameScene.factoriesPositions[5].slot.texture = SKTexture(imageNamed: factory.textureName)
                GameScene.factoriesPositions[5].slot.name = "factory_slot_5_occupied"
            } else {
                factory.node.position = GameScene.factoriesPositions[5].slot.position
                GameScene.factoriesPositions[5].slot.removeFromParent()
                GameScene.factoriesPositions[5].slot = factory.node
                changeAllNodeFamilyNames(node: factory.node, name: "factory_slot_5_occupied")
                background.addChild(factory.node)
            }
            factory.node.zPosition = 20
        case .none:
            let _ = 0
        }
    }
    
    
    /**
     Remove a factory from the scene.
     */
    func removeFactory(position: GeneratorPositions) {
        switch position {
        case .first:
            cleanSlot(positionIndex: 0)
        case .second:
            cleanSlot(positionIndex: 1)
        case .third:
            cleanSlot(positionIndex: 2)
        case .fourth:
            cleanSlot(positionIndex: 3)
        case .fifth:
            cleanSlot(positionIndex: 4)
        case .sixth:
            cleanSlot(positionIndex: 5)
        case .none:
            let _ = 0
        }
    }
    
    
    /**
     Clean slot to a empty slot again.
     */
    func cleanSlot(positionIndex: Int) {
        GameScene.factoriesPositions[positionIndex].slot.removeFromParent()
        GameScene.factoriesPositions[positionIndex].slot = SKSpriteNode(imageNamed: "Factory_add_new")
        GameScene.factoriesPositions[positionIndex].slot.anchorPoint = CGPoint(x: 0.5, y: 0)
        GameScene.factoriesPositions[positionIndex].slot.position = CGPoint(x: GameScene.factoriesPositions[positionIndex].x, y: GameScene.factoriesPositions[positionIndex].y)
        GameScene.factoriesPositions[positionIndex].slot.zPosition = 5
        GameScene.factoriesPositions[positionIndex].slot.name = "factory_slot_\(positionIndex)_empty"
        background.addChild(GameScene.factoriesPositions[positionIndex].slot)
    }
    
    
    /**
     Calls inventory to make player select an generator to place on the slot clicked. Receives the slot position player clicked. 
     */
    func selectGeneratorToInsert (position: GeneratorPositions) {
        let viewController = UIApplication.shared.windows.first!.rootViewController as! GameViewController
        viewController.selectGeneratorToInsert(position: position)
    }

    
    
    func displayUpgradeFactory() {
        let viewController = UIApplication.shared.windows.first!.rootViewController as! GameViewController
        viewController.displayUpgradeFactory()
    }
    
    
    // MARK: - RIGHTBAR INTERACTIONS
    /**
     Display game Settings.
     */
    func displaySettings() {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        Haptics.shared.activateHaptics(sound: .sucess)
        let viewController = UIApplication.shared.windows.first!.rootViewController as! GameViewController
        viewController.displaySettings()
    }
    
    
    /**
     Display player inventory.
     */
    func displayInventory() {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        Haptics.shared.activateHaptics(sound: .sucess)
        let viewController = UIApplication.shared.windows.first!.rootViewController as! GameViewController
        viewController.displayInventory()
    }
    
    
    /**
     Display in-game shop.
     */
    func displayShop() {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        Haptics.shared.activateHaptics(sound: .sucess)
        let viewController = UIApplication.shared.windows.first!.rootViewController as! GameViewController
        viewController.displayShop()
    }
    
    
    /**
     Display marketplace.
     */
    func displayMarketplace() {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        Haptics.shared.activateHaptics(sound: .sucess)
        let viewController = UIApplication.shared.windows.first!.rootViewController as! GameViewController
        viewController.displayMarketplace()
    }
    
    
    /**
     Display challenge.
     */
    func displayChallenge() {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        Haptics.shared.activateHaptics(sound: .sucess)
        let viewController = UIApplication.shared.windows.first!.rootViewController as! GameViewController
        viewController.displayChallenge()
    }
    
    
    // MARK: - Update
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}

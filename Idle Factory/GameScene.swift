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
    
    
    // MARK: - GAME HUD & HUD SCENE ACTIONS
    private var gameHud: GameHud = GameHud()
    private var actionShapeNode: SKShapeNode = SKShapeNode()
    
    private(set) var gameInventoryScene: GameInventorySceneController = GameInventorySceneController()
    private(set) var gameMarketplaceScene: GameMarketplaceSceneController = GameMarketplaceSceneController()
    private(set) var gameChallengeScene: GameChallengeSceneController = GameChallengeSceneController()
    
    
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
        for n in 0..<(GameScene.user?.generators.count ?? 0){
            addFactory(factory: (GameScene.user?.generators[n])!, id: n)
        }
        
        camera = cameraNode
        addChild(cameraNode)
        
        startIncrement()
        
    }
    
    
    // MARK: - TOUCH SCREEN EVENTS
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if(touchedNode.name == "PlayerInventoryButton"){
                displayInventory()
            }
            else if(touchedNode.name == "ShopButton") {
                displayShop()
            }
            
            else if(touchedNode.name == "MarketplaceButton") {
                displayMarketplace()
            }
            
            else if touchedNode.name == "ChallengeButton" {
                displayChallenge()
            }
            
            else if touchedNode.name == "factory0" {
                displayUpgradeFactory()
            }
            
            else if touchedNode.name == "factory1" {
                displayUpgradeFactory()
            }
            
            else if touchedNode.name == "factory2" {
                displayUpgradeFactory()
            }
            
            else if touchedNode.name == "factory3" {
                displayUpgradeFactory()
            }
            
            else if touchedNode.name == "factory4" {
                displayUpgradeFactory()
            }
            
            else if touchedNode.name == "factory5" {
                displayUpgradeFactory()
            }
            
            else if (
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
        let shopButton = gameHud.createShopButton()
        let marketPlaceButton = gameHud.createMarketplaceButton()
        let challengeButton = gameHud.createChallengeButton()
        
        // Positioning buttons on the device
        inventoryButton.position = CGPoint(x: ((GameScene.deviceScreenWidth) / 2.31), y: 130)
        shopButton.position = CGPoint(x: ((GameScene.deviceScreenWidth) / 2.31), y: 50)
        marketPlaceButton.position = CGPoint(x: ((GameScene.deviceScreenWidth) / 2.31), y: -30)
        challengeButton.position = CGPoint(x: ((GameScene.deviceScreenWidth) / 2.31), y: -123)
        
        // Add to scene
        cameraNode.addChild(sidebarBackground)
        sidebarBackground.addChild(inventoryButton)
        sidebarBackground.addChild(shopButton)
        sidebarBackground.addChild(marketPlaceButton)
        sidebarBackground.addChild(challengeButton)
    }
    
    
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
    
    
    // MARK: - GENERATORS FUNCTIONS
    /**
     Add a factory on the scene. Receives a position which represents what slot player wants to add the new factory.
     */
    func addFactory(factory: Factory, id: Int) {
        
        factory.node.anchorPoint = CGPoint(x: 0.5, y: 0)
        factory.node.name = "factory\(id)"
        
        switch factory.position {
            case .first:
                factory.node.position = CGPoint(x: factoriesPositions[0].x, y: factoriesPositions[0].y)
                factory.node.zPosition = 5
            case .second:
                factory.node.position = CGPoint(x: factoriesPositions[1].x, y: factoriesPositions[1].y)
                factory.node.zPosition = 2
            case .third:
                factory.node.position = CGPoint(x: factoriesPositions[2].x, y: factoriesPositions[2].y)
                factory.node.zPosition = 20
            case .fourth:
                factory.node.position = CGPoint(x: factoriesPositions[3].x, y: factoriesPositions[3].y)
                factory.node.zPosition = 15
            case .fifth:
                factory.node.position = CGPoint(x: factoriesPositions[4].x, y: factoriesPositions[4].y)
                factory.node.zPosition = 25
            case .sixth:
                factory.node.position = CGPoint(x: factoriesPositions[5].x, y: factoriesPositions[5].y)
                factory.node.zPosition = 20
            case .none:
                let _ = 0
        }
        
        background.addChild(factory.node)
    }
    
    
    func displayUpgradeFactory() {
        let viewController = UIApplication.shared.windows.first!.rootViewController as! GameViewController
        viewController.displayUpgradeFactory()
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
        
        let viewController = UIApplication.shared.windows.first!.rootViewController as! GameViewController
        viewController.displayInventory()
    }
    
    
    /**
     Display in-game shop.
     */
    func displayShop() {
        
        let viewController = UIApplication.shared.windows.first!.rootViewController as! GameViewController
        viewController.displayShop()
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

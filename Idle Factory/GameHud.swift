//
//  GameHud.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 18/10/21.
//

import SpriteKit


/**
 Class responsible to create all the components which compounds the game hud.
 */
class GameHud: SKScene {
    
    
    // MARK: - Device Width and Height variables
    private var deviceWidth = UIScreen.main.bounds.width
    private var deviceHeight = UIScreen.main.bounds.height
    
    
    // MARK: - Top HUD display components
    private(set) var mainCurrencyIcon: SKSpriteNode = SKSpriteNode()
    private(set) var premiumCurrencyIcon: SKSpriteNode = SKSpriteNode()
    private(set) var mainCurrencyValue: SKLabelNode = SKLabelNode()
    private(set) var premiumCurrencyValue: SKLabelNode = SKLabelNode()
    private(set) var generatingResourceValue: SKLabelNode = SKLabelNode()
    
    
    // MARK: - Right Sidebar HUD display components
    private(set) var inventoryButton: SKSpriteNode = SKSpriteNode()
    private(set) var marketplaceButton: SKSpriteNode = SKSpriteNode()
    private(set) var challengeButton: SKSpriteNode = SKSpriteNode()
    
    
    // MARK: - Top HUD Functions
    /**
     Create a white rounded Rect ShapeNode used to display currency info on the HUD.
     */
    func createTopHudBackground(xPos: CGFloat) -> SKShapeNode {
        let HudInfoBackground = SKShapeNode(rect: CGRect(x: -((deviceWidth) / 2) + xPos, y: ((deviceHeight) / 3) + 7.5, width: (UIScreen.main.bounds.height) * 0.32, height: (deviceHeight) * 0.09), cornerRadius: 7)
        HudInfoBackground.fillColor = .white
        HudInfoBackground.zPosition = 4
        return HudInfoBackground
    }
    
    
    /**
     Create a black rounded Rect ShapeNode used to display the actual generating resource value info on the HUD.
     */
    func createTopHudGenerationBackground() -> SKShapeNode {
        let generationHudBackground = SKShapeNode(rect: CGRect(x: -((deviceWidth) / 2) + 50, y: ((deviceHeight) / 3) - 9, width: (UIScreen.main.bounds.height) * 0.19, height: (deviceHeight) * 0.10), cornerRadius: 7)
        generationHudBackground.fillColor = UIColor(named: "Rightbar_background")!
        generationHudBackground.strokeColor = UIColor(named: "Rightbar_background")!
        generationHudBackground.zPosition = 3
        return generationHudBackground
    }
    
    
    /**
     Create main currency icon of the game hud.
     */
    func createMainCurrencyIcon() -> SKSpriteNode {
        mainCurrencyIcon = SKSpriteNode(imageNamed: "Coin")
        mainCurrencyIcon.setScale(0.8)
        mainCurrencyIcon.zPosition = 3
        return mainCurrencyIcon
    }
   
    
    /**
     Create premium currency icon of the game hud.
     */
    func createPremiumCurrencyIcon() -> SKSpriteNode {
        premiumCurrencyIcon = SKSpriteNode(imageNamed: "Money_premium")
        premiumCurrencyIcon.setScale(0.8)
        premiumCurrencyIcon.zPosition = 3
        return premiumCurrencyIcon
    }
    
    
    /**
     Create main currency label to display on the scene.
     */
    func createMainCurrencyLabel() -> SKLabelNode{
        mainCurrencyValue.name = "MainCurrency"
        mainCurrencyValue.fontName = "AustralSlabBlur-Regular"
        mainCurrencyValue.text = "\(GameScene.user?.mainCurrency ?? 0.0)M"
        mainCurrencyValue.fontColor = .black
        mainCurrencyValue.fontSize = 14
        mainCurrencyValue.zPosition = 3
        return mainCurrencyValue
    }
    
    
    /**
     Create premium currency label to display on the scene.
     */
    func createPremiumCurrency() -> SKLabelNode{
        premiumCurrencyValue.name = "PremiumCurrency"
        premiumCurrencyValue.fontName = "AustralSlabBlur-Regular"
        premiumCurrencyValue.text = "\(GameScene.user?.premiumCurrency ?? 0.0)M"
        premiumCurrencyValue.fontColor = .black
        premiumCurrencyValue.fontSize = 14
        premiumCurrencyValue.zPosition = 3
        return premiumCurrencyValue
    }
    
    
    /**
     Create generator resource label to display on the scene.
     */
    func createGenerateResource() -> SKLabelNode{
        generatingResourceValue.name = "GeneratingResource"
        generatingResourceValue.fontName = "AustralSlabBlur-Regular"
        generatingResourceValue.text = "+ 999.999 M/s"
        generatingResourceValue.fontColor = .white
        generatingResourceValue.fontSize = 11
        generatingResourceValue.zPosition = 3
        return generatingResourceValue
    }
    
    
    // MARK: - Right sidebar HUD Functions
    
    /**
     Create a large right side Rect ShapeNode to display HUD actions.
     */
    func createSidebarBackground() -> SKShapeNode {
        let sidebarBackground = SKShapeNode(rect: CGRect(x: (deviceWidth) / 2.3, y: -(deviceHeight) / 2, width: (deviceWidth) * 0.08, height: deviceHeight))
        sidebarBackground.fillColor = UIColor(named: "Rightbar_background")!
        sidebarBackground.strokeColor = UIColor(named: "Rightbar_background")!
        sidebarBackground.zPosition = 3
        return sidebarBackground
    }
    
    
    /**
     Create inventory button for the sidebar hud.
     */
    func createInventoryButton() -> SKSpriteNode {
        inventoryButton = SKSpriteNode(imageNamed: "Button-inventory")
        inventoryButton.setScale(0.8)
        inventoryButton.zPosition = 4
        return inventoryButton
    }
    
    
    /**
     Create marketplace button for the sidebar hud.
     */
    func createMarketplaceButton() -> SKSpriteNode {
        marketplaceButton = SKSpriteNode(imageNamed: "Button-marketplace")
        marketplaceButton.setScale(0.8)
        marketplaceButton.zPosition = 4
        return marketplaceButton
    }
    
    
    /**
     Create premium currency icon of the game hud.
     */
    func createChallengeButton() -> SKSpriteNode {
        challengeButton = SKSpriteNode(imageNamed: "Button-challenges")
        challengeButton.setScale(0.8)
        challengeButton.zPosition = 4
        return challengeButton
    }
}
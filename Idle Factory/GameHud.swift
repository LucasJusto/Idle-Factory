//
//  GameHud.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 18/10/21.
//

import SpriteKit


class GameHud: SKScene {
    
    
    // MARK: - Device Width and Height variables
    private var deviceWidth = UIScreen.main.bounds.width
    private var deviceHeight = UIScreen.main.bounds.height
    
    
    // MARK: - Top HUD variables
    private(set) var mainCurrencyIcon: SKSpriteNode = SKSpriteNode()
    private(set) var premiumCurrencyIcon: SKSpriteNode = SKSpriteNode()
    private(set) var mainCurrencyValue: SKLabelNode = SKLabelNode()
    private(set) var premiumCurrencyValue: SKLabelNode = SKLabelNode()
    
    
    // MARK: - Right Sidebar HUD variables
    private(set) var marketplaceButton: SKSpriteNode = SKSpriteNode()
    private(set) var challengeButton: SKSpriteNode = SKSpriteNode()
    
    
    // MARK: - Top HUD Functions
    /**
     Create a white rounded Rect ShapeNode used to display currency info on the HUD.
     */
    func createTopHudBackground(xPos: CGFloat) -> SKShapeNode {
        let HudInfoBackground = SKShapeNode(rect: CGRect(x: -((deviceWidth) / 2) + xPos, y: ((deviceHeight) / 3) + 7.5, width: (UIScreen.main.bounds.height) * 0.32, height: (deviceHeight) * 0.09), cornerRadius: 10)
        HudInfoBackground.fillColor = .white
        HudInfoBackground.zPosition = 3
        return HudInfoBackground
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

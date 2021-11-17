//
//  GameAnnounceViewCell.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 02/11/21.
//

import UIKit
import SpriteKit

/**
 Display each offer made by player (you) on your announces scene.
 */
class GameAnnounceViewCell: UICollectionViewCell {
    
    // MARK: - GENERATOR OUTLETS
    @IBOutlet weak var totalCardView: UIView!
    @IBOutlet weak var cardView: UIView!
    
    // Generator Image
    @IBOutlet weak var generatorImage: SKView!
    
    // Generator resources
    @IBOutlet weak var leftMargin: UIView!
    @IBOutlet weak var resourceType1: UIImageView!
    @IBOutlet weak var resourceQuantityType1: UILabel!
    @IBOutlet weak var resourceType2: UIImageView!
    @IBOutlet weak var resourceQuantityType2: UILabel!
    @IBOutlet weak var resourceType3: UIImageView!
    @IBOutlet weak var resourceQuantityType3: UILabel!
    @IBOutlet weak var rightMargin: UIView!
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
    // Button
    @IBOutlet weak var seeAnnounceButton: UIButton!
    
    
    @IBAction func buttonCell(_ sender: Any) {
        if offer?.buyerID == "none" {
            //abrir tela de detalhes
        } else if offer?.isCollected == .no {
            // resgata o dinheiro e tira o gerador dessa lista
        }
    }
    
    // MARK: - VARIABLES
    var myFactoryAnnounce: Factory?
    var offer: Offer?
    
    // MARK: - CELL FUNCTIONS
    override func prepareForReuse() {
        leftMargin.isHidden = false
        resourceType1.isHidden = false
        resourceQuantityType1.isHidden = false
        resourceType2.isHidden = false
        resourceQuantityType2.isHidden = false
        resourceType3.isHidden = false
        resourceQuantityType3.isHidden = false
        rightMargin.isHidden = false
    }
    
    
    /**
     Hide the card if the request to database returns nothing.
     */
    func hideCell() {
        totalCardView.isHidden = true
    }
    
    
    /**
     Configure cell design.
     */
    func configureCell() {
        cardView.layer.cornerRadius = 20
        seeAnnounceButton.layer.cornerRadius = 10
        
        // FONT
        resourceQuantityType1.font = UIFont(name: "AustralSlabBlur-Regular", size: 8)
        resourceQuantityType2.font = UIFont(name: "AustralSlabBlur-Regular", size: 8)
        resourceQuantityType3.font = UIFont(name: "AustralSlabBlur-Regular", size: 8)
        priceLabel.font = UIFont(name: "AustralSlabBlur-Regular", size: 14)
        seeAnnounceButton.titleLabel?.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
        
        if offer?.buyerID == "none" {
            seeAnnounceButton.backgroundColor = UIColor(named: "actionColor1")
            seeAnnounceButton.setTitle(NSLocalizedString("AboutNewFactoryButton", comment: ""), for: .normal)
        } else if offer?.isCollected == .no {
            seeAnnounceButton.backgroundColor = UIColor(named: "HudActions-background")
            seeAnnounceButton.setTitle(NSLocalizedString("RedeemValueButton", comment: ""), for: .normal)
        }
    }
    
    
    /**
     Pull purchasable factories to display on marketplace.
     */
    func pullMyAnnouncesFactories(factory: Factory, offer: Offer, premium: Bool) {
        self.offer = offer
        let scene = FactoryScene(size: CGSize(width: 400, height: 400))
        scene.thisFactory = factory
        scene.thisYPosition = 12
        scene.scaleMode = .aspectFill
        generatorImage.presentScene(scene)
        let resources = factory.resourcesArray
        
        leftMargin.isHidden = false
        rightMargin.isHidden = false
        
        switch resources.count {
        case 1:
            resourceType1.isHidden = true
            resourceQuantityType1.isHidden = true
            resourceType2.image = UIImage(systemName: getResourceImageName(resource: resources[0].type))
            resourceQuantityType2.text = "\(Int(resources[0].baseQtt))"
            resourceType3.isHidden = true
            resourceQuantityType3.isHidden = true
            
        case 2:
            resourceType1.image = UIImage(systemName: getResourceImageName(resource: resources[0].type))
            resourceQuantityType1.text = "\(Int(resources[0].baseQtt))"
            resourceType2.image = UIImage(systemName: getResourceImageName(resource: resources[1].type))
            resourceQuantityType2.text = "\(Int(resources[1].baseQtt))"
            resourceType3.isHidden = true
            resourceQuantityType3.isHidden = true

        case 3:
            leftMargin.isHidden = true
            resourceType1.image = UIImage(systemName: getResourceImageName(resource: resources[0].type))
            resourceQuantityType1.text = "\(Int(resources[0].baseQtt))"
            resourceType2.image = UIImage(systemName: getResourceImageName(resource: resources[1].type))
            resourceQuantityType2.text = "\(Int(resources[1].baseQtt))"
            resourceType3.image = UIImage(systemName: getResourceImageName(resource: resources[2].type))
            resourceQuantityType3.text = "\(Int(resources[2].baseQtt))"
            rightMargin.isHidden = true

        default:
            leftMargin.isHidden = true
            resourceType1.isHidden = true
            resourceQuantityType1.isHidden = true
            resourceType2.isHidden = true
            resourceQuantityType2.isHidden = true
            resourceType3.isHidden = true
            resourceQuantityType3.isHidden = true
            rightMargin.isHidden = true
        }
        coinImage.image = UIImage(named: premium ? "Money_premium" : "Coin")
        priceLabel.text = doubleToString(value: offer.price)
    }
}

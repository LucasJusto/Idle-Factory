//
//  GameMarketplaceViewCell.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 01/11/21.
//

import UIKit
import SpriteKit

/**
 Display each offer made by a real player on the Marketplace scene.
 */
class GameMarketplaceViewCell: UICollectionViewCell {
    
    // MARK: - GENERATOR OUTLETS
    @IBOutlet weak var totalCardView: UIView!
    @IBOutlet weak var cardView: UIView!
    
    // Generator Image
    @IBOutlet weak var SKView: SKView!
    
    // Generator resources
    @IBOutlet weak var resourceType1: UIImageView!
    @IBOutlet weak var resourceQuantityType1: UILabel!
    @IBOutlet weak var resourceType2: UIImageView!
    @IBOutlet weak var resourceQuantityType2: UILabel!
    @IBOutlet weak var resourceType3: UIImageView!
    @IBOutlet weak var resourceQuantityType3: UILabel!
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
    // Button
    @IBOutlet weak var seeMoreButton: UIButton!
    
    
    var delegate: NavigationCellDelegate?
    var thisGenerator: Factory? = nil
    var thisOffer: Offer? = nil
    
    
    @IBAction func seeMoreAction(_ sender: Any) {
        FactoryDetailSceneController.isBlue = false
        FactoryDetailSceneController.generator = thisGenerator
        FactoryDetailSceneController.offer = thisOffer
        delegate?.didButtonPressed()
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
        totalCardView.isHidden = false

        // DESIGN
        cardView.layer.cornerRadius = 20
        seeMoreButton.layer.cornerRadius = 10
        
        // FONT
        resourceQuantityType1.font = UIFont(name: "AustralSlabBlur-Regular", size: 8)
        resourceQuantityType2.font = UIFont(name: "AustralSlabBlur-Regular", size: 8)
        resourceQuantityType3.font = UIFont(name: "AustralSlabBlur-Regular", size: 8)
        priceLabel.font = UIFont(name: "AustralSlabBlur-Regular", size: 14)
        seeMoreButton.titleLabel?.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)

        seeMoreButton.setTitle(NSLocalizedString("AboutNewFactoryButton", comment: ""), for: .normal)
    }
    
    
    /**
     Pull purchasable factories to display on marketplace.
     */
    func pullMarketplaceFactories(factory: Factory, offer: Offer, premium: Bool) {
        thisOffer = offer
        thisGenerator = factory
        let scene = FactoryScene(size: CGSize(width: 400, height: 400))
        scene.thisFactory = thisGenerator
        scene.scaleMode = .aspectFill
        SKView.presentScene(scene)
        let resources = factory.resourcesArray
        switch resources.count {
        case 1:
            resourceType1.isHidden = true
            resourceQuantityType1.text = ""
            resourceType2.image = UIImage(systemName: getResourceImageName(resource: resources[0].type))
            resourceQuantityType2.text = "\(resources[0].baseQtt)"
            resourceType3.isHidden = true
            resourceQuantityType3.text = ""
            
        case 2:
            resourceType1.image = UIImage(systemName: getResourceImageName(resource: resources[0].type))
            resourceQuantityType1.text = "\(resources[0].baseQtt)"
            resourceType2.image = UIImage(systemName: getResourceImageName(resource: resources[1].type))
            resourceQuantityType2.text = "\(resources[1].baseQtt)"
            resourceType3.isHidden = true
            resourceQuantityType3.text = ""

        case 3:
            resourceType1.image = UIImage(systemName: getResourceImageName(resource: resources[0].type))
            resourceQuantityType1.text = "\(resources[0].baseQtt)"
            resourceType2.image = UIImage(systemName: getResourceImageName(resource: resources[1].type))
            resourceQuantityType2.text = "\(resources[1].baseQtt)"
            resourceType3.image = UIImage(systemName: getResourceImageName(resource: resources[2].type))
            resourceQuantityType3.text = "\(resources[2].baseQtt)"
            
        default:
            resourceType1.isHidden = true
            resourceQuantityType1.text = ""
            resourceType2.isHidden = true
            resourceQuantityType2.text = ""
            resourceType3.isHidden = true
            resourceQuantityType3.text = ""
        }
        coinImage.image = UIImage(named: premium ? "Money_premium" : "Coin")
        priceLabel.text = "\(offer.price)"
    }
}


protocol NavigationCellDelegate {
    func didButtonPressed()
}

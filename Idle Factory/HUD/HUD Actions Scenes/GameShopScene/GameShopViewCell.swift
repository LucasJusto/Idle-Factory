//
//  GameShopViewCell.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 03/11/21.
//

import UIKit
import SpriteKit

/**
 Display purchasable random factories on the Shop.
 */
class GameShopViewCell: UICollectionViewCell {
    
    // MARK: - GENERATOR OUTLETS
    @IBOutlet weak var cardView: UIView!
    
    // Generator Image
    
    // Generator resources
    @IBOutlet weak var resourceType1: UIImageView!
    @IBOutlet weak var resourceQuantityType1: UILabel!
    @IBOutlet weak var resourceType2: UIImageView!
    @IBOutlet weak var resourceQuantityType2: UILabel!
    @IBOutlet weak var resourceType3: UIImageView!
    @IBOutlet weak var resourceQuantityType3: UILabel!
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var SKView: SKView!
    
    // Button
    @IBOutlet weak var seeMoreButton: UIButton!
    
    var thisGenerator: Factory? = nil
    var delegate: NavigationCellDelegate?
    
    
    /**
     Configure cell design.
     */
    func configureCell() {        
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
    func pullShopFactories(factory: Factory) {
        thisGenerator = factory
        let scene = FactoryScene(size: CGSize(width: 400, height: 400))
        scene.thisFactory = thisGenerator
        scene.scaleMode = .aspectFill
        SKView.presentScene(scene)
        //generatorImage.image = UIImage(named: "Basic_Factory_level_1_shop_marketplace")
        let resources = factory.resourcesArray
        
        resourceType1.isHidden = false
        resourceType2.isHidden = false
        resourceType3.isHidden = false
        
        switch resources.count {
        case 1:
            resourceType1.isHidden = true
            resourceQuantityType1.text = ""
            resourceType2.image = UIImage(systemName: getResourceImageName(resource: resources[0].type))
            resourceQuantityType2.text = "\(Int(resources[0].baseQtt))"
            resourceType3.isHidden = true
            resourceQuantityType3.text = ""
            priceLabel.text = "\(resources[0].basePrice)"
            
        case 2:
            resourceType1.image = UIImage(systemName: getResourceImageName(resource: resources[0].type))
            resourceQuantityType1.text = "\(Int(resources[0].baseQtt))"
            resourceType2.image = UIImage(systemName: getResourceImageName(resource: resources[1].type))
            resourceQuantityType2.text = "\(Int(resources[1].baseQtt))"
            resourceType3.isHidden = true
            resourceQuantityType3.text = ""
            priceLabel.text = "\(resources[0].basePrice + resources[1].basePrice)"

        case 3:
            resourceType1.image = UIImage(systemName: getResourceImageName(resource: resources[0].type))
            resourceQuantityType1.text = "\(Int(resources[0].baseQtt))"
            resourceType2.image = UIImage(systemName: getResourceImageName(resource: resources[1].type))
            resourceQuantityType2.text = "\(Int(resources[1].baseQtt))"
            resourceType3.image = UIImage(systemName: getResourceImageName(resource: resources[2].type))
            resourceQuantityType3.text = "\(Int(resources[2].baseQtt))"
            priceLabel.text = "\(resources[0].basePrice + resources[1].basePrice + resources[2].basePrice)"

        default:
            resourceType1.isHidden = true
            resourceQuantityType1.text = ""
            resourceType2.isHidden = true
            resourceQuantityType2.text = ""
            resourceType3.isHidden = true
            resourceQuantityType3.text = ""
        }
    }
    
    
    @IBAction func seeMore(_ sender: Any) {
        FactoryDetailSceneController.isBlue = true
        FactoryDetailSceneController.generator = thisGenerator
        delegate?.didButtonPressed()
    }
}

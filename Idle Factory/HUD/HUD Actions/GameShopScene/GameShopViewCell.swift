//
//  GameShopViewCell.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 03/11/21.
//

import UIKit


/**
 Display purchasable random factories on the Shop.
 */
class GameShopViewCell: UICollectionViewCell {
    
    // MARK: - GENERATOR OUTLETS
    @IBOutlet weak var cardView: UIView!
    
    // Generator Image
    @IBOutlet weak var generatorImage: UIImageView!
    
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
    
    
    /**
     Configure cell design.
     */
    func configureCell() {
        cardView.layer.cornerRadius = 20
        seeMoreButton.layer.cornerRadius = 10
        seeMoreButton.setTitle(NSLocalizedString("AboutNewFactoryButton", comment: ""), for: .normal)
    }
    
    
    /**
     Pull purchasable factories to display on marketplace.
     */
    func pullShopFactories(factory: Factory) {
        generatorImage.image = UIImage(named: factory.textureName)
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
    
    
    #warning("BOTÃO SEE MORE")
    @IBAction func seeMore(_ sender: Any) {
    }
    
    
}

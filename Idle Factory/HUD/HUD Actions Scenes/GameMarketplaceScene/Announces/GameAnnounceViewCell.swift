//
//  GameAnnounceViewCell.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 02/11/21.
//

import UIKit


/**
 Display each offer made by player (you) on your announces scene.
 */
class GameAnnounceViewCell: UICollectionViewCell {
    
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
    @IBOutlet weak var seeAnnounceButton: UIButton!
    
    
    // MARK: - CELL FUNCTIONS
    override func prepareForReuse() {
        resourceType1.isHidden = false
        resourceQuantityType1.isHidden = false
        resourceType2.isHidden = false
        resourceQuantityType2.isHidden = false
        resourceType3.isHidden = false
        resourceQuantityType3.isHidden = false
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
        
        seeAnnounceButton.setTitle(NSLocalizedString("AboutAnnounceButton", comment: ""), for: .normal)
    }
    
    
    /**
     Pull purchasable factories to display on marketplace.
     */
    func pullMarketplaceFactories(texture: String, resources: [Resource]) {
        generatorImage.image = UIImage(named: texture)
        switch resources.count {
        case 1:
            resourceType1.isHidden = true
            resourceQuantityType1.text = "  "
            resourceType2.image = UIImage(systemName: getResourceImageName(resource: resources[0].type))
            resourceQuantityType2.text = "\(Int(resources[0].baseQtt))"
            resourceType3.isHidden = true
            resourceQuantityType3.text = "  "
            
        case 2:
            resourceType1.image = UIImage(systemName: getResourceImageName(resource: resources[0].type))
            resourceQuantityType1.text = "\(Int(resources[0].baseQtt))"
            resourceType2.image = UIImage(systemName: getResourceImageName(resource: resources[1].type))
            resourceQuantityType2.text = "\(Int(resources[1].baseQtt))"
            resourceType3.isHidden = true
            resourceQuantityType3.isHidden = true

        case 3:
            resourceType1.image = UIImage(systemName: getResourceImageName(resource: resources[0].type))
            resourceQuantityType1.text = "\(Int(resources[0].baseQtt))"
            resourceType2.image = UIImage(systemName: getResourceImageName(resource: resources[1].type))
            resourceQuantityType2.text = "\(Int(resources[1].baseQtt))"
            resourceType3.image = UIImage(systemName: getResourceImageName(resource: resources[2].type))
            resourceQuantityType3.text = "\(Int(resources[2].baseQtt))"
            
        default:
            resourceType1.isHidden = true
            resourceQuantityType1.isHidden = true
            resourceType2.isHidden = true
            resourceQuantityType2.isHidden = true
            resourceType3.isHidden = true
            resourceQuantityType3.isHidden = true
        }
        priceLabel.text = "999.999 M"
    }
}

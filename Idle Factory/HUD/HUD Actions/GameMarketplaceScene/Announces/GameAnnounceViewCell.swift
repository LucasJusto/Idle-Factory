//
//  GameAnnounceViewCell.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 02/11/21.
//

import UIKit

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
    
    
    /**
     Configure cell design.
     */
    func configureCell() {
        cardView.layer.cornerRadius = 20
        seeAnnounceButton.layer.cornerRadius = 10
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
        priceLabel.text = "999.999 M"
    }
}

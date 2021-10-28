//
//  GameInventoryViewCell.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 26/10/21.
//

import UIKit

class GameInventoryViewCell: UICollectionViewCell {
    
    @IBOutlet weak var factoryTexture: UIImageView!
    @IBOutlet weak var factoryId: UILabel!
    
    // Resources types cell.
    @IBOutlet weak var resourceType1: UIImageView!
    @IBOutlet weak var quantityType1: UILabel!
    @IBOutlet weak var resourceType2: UIImageView!
    @IBOutlet weak var quantityType2: UILabel!
    @IBOutlet weak var resourceType3: UIImageView!
    @IBOutlet weak var quantityType3: UILabel!
    
    
    /**
     Configure cell design.
     */
    func configureCell() {
        self.contentView.layer.cornerRadius = 10
    }
    
    
    /**
     Pull factory data for each cell. Receives a texture of the Factory.
     */
    func pullFactoryData(texture: String, resources: [Resource]) {
        
        factoryTexture.image = UIImage(named: texture)
        switch resources.count {
        case 1:
            resourceType1.image = UIImage(named: "")
            quantityType1.text = ""
            resourceType2.image = UIImage(named: "")
            quantityType2.text = "\(resources[0].baseQtt)"
            resourceType3.image = UIImage(named: "")
            quantityType3.text = ""
            
        case 2:
            resourceType1.image = UIImage(named: "")
            quantityType1.text = "\(resources[0].baseQtt)"
            resourceType2.image = UIImage(named: "")
            quantityType2.text = "\(resources[1].baseQtt)"
            resourceType3.image = UIImage(named: "")
            quantityType3.text = ""

        case 3:
            resourceType1.image = UIImage(named: "")
            quantityType1.text = "\(resources[0].baseQtt)"
            resourceType2.image = UIImage(named: "")
            quantityType2.text = "\(resources[1].baseQtt)"
            resourceType3.image = UIImage(named: "")
            quantityType3.text = "\(resources[2].baseQtt)"

            
        default:
            resourceType1.image = UIImage(named: "")
            quantityType1.text = ""
            resourceType2.image = UIImage(named: "")
            quantityType2.text = ""
            resourceType3.image = UIImage(named: "")
            quantityType3.text = ""
        }
        
    }
}

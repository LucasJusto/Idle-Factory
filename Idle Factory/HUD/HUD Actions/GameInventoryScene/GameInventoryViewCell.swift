//
//  GameInventoryViewCell.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 26/10/21.
//

import UIKit
import SpriteKit

/**
 Display each generator which is not active in player inventory.
 */
class GameInventoryViewCell: UICollectionViewCell {
    
    // MARK: - GENERATOR OUTLETS
    
    // Factory Texture || Empty Slot.
    @IBOutlet weak var emptySlot: UIImageView!
    @IBOutlet weak var factoryTexture: SKView!
    @IBOutlet weak var factoryTextureImage: UIImageView!
    
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
    func pullFactoryData(texture: String, resources: [Resource], factory: Factory?) {

        
        emptySlot.isHidden = true
        factoryTextureImage.isHidden = false
        resourceType1.isHidden = false
        resourceType2.isHidden = false
        resourceType3.isHidden = false
        
        switch resources.count {
        case 1:
            let scene = FactoryScene(size: CGSize(width: 300, height: 300))
            scene.thisFactory = factory
            scene.isSmall = true
            scene.scaleMode = .aspectFill
            factoryTexture.presentScene(scene)
            factoryTextureImage.isHidden = true
            resourceType1.isHidden = true
            quantityType1.text = ""
            resourceType2.image = UIImage(systemName: getResourceImageName(resource: resources[0].type))
            quantityType2.text = "\(resources[0].baseQtt)"
            resourceType3.isHidden = true
            quantityType3.text = ""
            
        case 2:
            let scene = FactoryScene(size: CGSize(width: 300, height: 300))
            scene.thisFactory = factory
            scene.isSmall = true
            scene.scaleMode = .aspectFill
            factoryTexture.presentScene(scene)
            factoryTextureImage.isHidden = true
            resourceType1.image = UIImage(systemName: getResourceImageName(resource: resources[0].type))
            quantityType1.text = "\(resources[0].baseQtt)"
            resourceType2.image = UIImage(systemName: getResourceImageName(resource: resources[1].type))
            quantityType2.text = "\(resources[1].baseQtt)"
            resourceType3.isHidden = true
            quantityType3.text = ""

        case 3:
            let scene = FactoryScene(size: CGSize(width: 300, height: 300))
            scene.thisFactory = factory
            scene.isSmall = true
            scene.scaleMode = .aspectFill
            factoryTexture.presentScene(scene)
            factoryTextureImage.isHidden = true
            resourceType1.image = UIImage(systemName: getResourceImageName(resource: resources[0].type))
            quantityType1.text = "\(resources[0].baseQtt)"
            resourceType2.image = UIImage(systemName: getResourceImageName(resource: resources[1].type))
            quantityType2.text = "\(resources[1].baseQtt)"
            resourceType3.image = UIImage(systemName: getResourceImageName(resource: resources[2].type))
            quantityType3.text = "\(resources[2].baseQtt)"

        default:
            emptySlot.isHidden = false
            factoryTexture.isHidden = true
            factoryTextureImage.isHidden = true
            resourceType1.isHidden = true
            quantityType1.text = ""
            resourceType2.isHidden = true
            quantityType2.text = ""
            resourceType3.isHidden = true
            quantityType3.text = ""
        }
        
    }
}

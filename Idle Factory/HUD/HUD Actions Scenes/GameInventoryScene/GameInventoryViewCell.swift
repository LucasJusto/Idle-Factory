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
    
    // Resources types cell.
    @IBOutlet weak var leftMargin: UIView!
    @IBOutlet weak var resourceType1: UIImageView!
    @IBOutlet weak var quantityType1: UILabel!
    @IBOutlet weak var resourceType2: UIImageView!
    @IBOutlet weak var quantityType2: UILabel!
    @IBOutlet weak var resourceType3: UIImageView!
    @IBOutlet weak var quantityType3: UILabel!
    @IBOutlet weak var rightMargin: UIView!
    
    
    // MARK: - CELL FUNCTIONS
    override func prepareForReuse() {
        factoryTexture.isHidden = false
        leftMargin.isHidden = false
        resourceType1.isHidden = false
        quantityType1.isHidden = false
        resourceType2.isHidden = false
        quantityType2.isHidden = false
        resourceType3.isHidden = false
        quantityType3.isHidden = false
        rightMargin.isHidden = false

    }
    
    
    /**
     Configure cell design.
     */
    func configureCell() {
        self.contentView.layer.cornerRadius = 10
        
        quantityType1.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
        quantityType2.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
        quantityType3.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
    }
    
    
    /**
     Pull factory data for each cell. Receives a texture of the Factory.
     */
    func pullFactoryData(factory: Factory?) {
        
        var resources: [Resource] = []
        
        if let factory = factory {
            let scene = FactoryScene(size: CGSize(width: 300, height: 300))
            scene.thisFactory = factory
            scene.isSmall = true
            scene.scaleMode = .aspectFill
            factoryTexture.presentScene(scene)
            
            resources = factory.resourcesArray
        }
        
        emptySlot.isHidden = true
        leftMargin.isHidden = false
        rightMargin.isHidden = false
        
        switch resources.count {
        case 1:
            resourceType1.isHidden = true
            quantityType1.isHidden = true
            resourceType2.image = UIImage(systemName: getResourceImageName(resource: resources[0].type))
            let qtd0 = (resources[0].qttPLevel * Double(resources[0].currentLevel)) + resources[0].baseQtt
            quantityType2.text = "\(Int(qtd0))"
            resourceType3.isHidden = true
            quantityType3.isHidden = true
            
        case 2:
            resourceType1.image = UIImage(systemName: getResourceImageName(resource: resources[0].type))
            let qtd0 = (resources[0].qttPLevel * Double(resources[0].currentLevel)) + resources[0].baseQtt
            quantityType1.text = "\(Int(qtd0))"
            resourceType2.image = UIImage(systemName: getResourceImageName(resource: resources[1].type))
            let qtd1 = (resources[1].qttPLevel * Double(resources[1].currentLevel)) + resources[1].baseQtt
            quantityType2.text = "\(Int(qtd1))"
            resourceType3.isHidden = true
            quantityType3.isHidden = true

        case 3:
            leftMargin.isHidden = true
            resourceType1.image = UIImage(systemName: getResourceImageName(resource: resources[0].type))
            let qtd0 = (resources[0].qttPLevel * Double(resources[0].currentLevel)) + resources[0].baseQtt
            quantityType1.text = "\(Int(qtd0))"
            resourceType2.image = UIImage(systemName: getResourceImageName(resource: resources[1].type))
            let qtd1 = (resources[1].qttPLevel * Double(resources[1].currentLevel)) + resources[1].baseQtt
            quantityType2.text = "\(Int(qtd1))"
            resourceType3.image = UIImage(systemName: getResourceImageName(resource: resources[2].type))
            let qtd2 = (resources[2].qttPLevel * Double(resources[2].currentLevel)) + resources[2].baseQtt
            quantityType3.text = "\(Int(qtd2))"
            rightMargin.isHidden = true

        default:
            emptySlot.isHidden = false
            leftMargin.isHidden = true
            factoryTexture.isHidden = true
            resourceType1.isHidden = true
            quantityType1.isHidden = true
            resourceType2.isHidden = true
            quantityType2.isHidden = true
            resourceType3.isHidden = true
            quantityType3.isHidden = true
            rightMargin.isHidden = true
        }
    }
}

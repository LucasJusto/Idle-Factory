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
    // Cell CardView
    @IBOutlet weak var cardView: UIView!
    
    // Generator Image
    @IBOutlet weak var SKView: SKView!

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
    @IBOutlet weak var seeMoreButton: UIButton!
    
    
    // MARK: - VARIABLES
    var thisGenerator: Factory? = nil
    var delegate: NavigationCellDelegate?
    
    
    // MARK: - ACTIONS
    @IBAction func seeMore(_ sender: Any) {
        FactoryDetailSceneController.isBlue = true
        FactoryDetailSceneController.generator = thisGenerator
        delegate?.didButtonPressed()
    }
    
    
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
     Configure cell design.
     */
    func configureCell() {        
        // DESIGN
        cardView.layer.cornerRadius = 20
        seeMoreButton.layer.cornerRadius = 10
        
        // FONT
        resourceQuantityType1.font = UIFont(name: "AustralSlabBlur-Regular", size: 12)
        resourceQuantityType2.font = UIFont(name: "AustralSlabBlur-Regular", size: 12)
        resourceQuantityType3.font = UIFont(name: "AustralSlabBlur-Regular", size: 12)
        priceLabel.font = UIFont(name: "AustralSlabBlur-Regular", size: 14)
        seeMoreButton.titleLabel?.font = UIFont(name: "AustralSlabBlur-Regular", size: 14)
        
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
        
        leftMargin.isHidden = false
        rightMargin.isHidden = false
        
        switch resources.count {
        case 1:
            resourceType1.isHidden = true
            let qtd = (resources[0].qttPLevel * Double(resources[0].currentLevel)) + resources[0].baseQtt
            resourceQuantityType1.isHidden = true
            resourceType2.image = UIImage(systemName: getResourceImageName(resource: resources[0].type))
            resourceQuantityType2.text = "\(Int(qtd))"
            resourceType3.isHidden = true
            priceLabel.text = "\(doubleToString(value: getFactorySpendings(factory: factory)))"
            resourceQuantityType3.isHidden = true
            
        case 2:
            resourceType1.image = UIImage(systemName: getResourceImageName(resource: resources[0].type))
            let qtd0 = (resources[0].qttPLevel * Double(resources[0].currentLevel)) + resources[0].baseQtt
            resourceQuantityType1.text = "\(Int(qtd0))"
            let qtd1 = (resources[1].qttPLevel * Double(resources[1].currentLevel)) + resources[1].baseQtt
            resourceType2.image = UIImage(systemName: getResourceImageName(resource: resources[1].type))
            resourceQuantityType2.text = "\(Int(qtd1))"
            resourceType3.isHidden = true
            priceLabel.text = "\(doubleToString(value: getFactorySpendings(factory: factory)))"
            resourceQuantityType3.isHidden = true

        case 3:
            leftMargin.isHidden = true
            resourceType1.image = UIImage(systemName: getResourceImageName(resource: resources[0].type))
            let qtd0 = (resources[0].qttPLevel * Double(resources[0].currentLevel)) + resources[0].baseQtt
            resourceQuantityType1.text = "\(Int(qtd0))"
            resourceType2.image = UIImage(systemName: getResourceImageName(resource: resources[1].type))
            let qtd1 = (resources[1].qttPLevel * Double(resources[1].currentLevel)) + resources[1].baseQtt
            resourceQuantityType2.text = "\(Int(qtd1))"
            resourceType3.image = UIImage(systemName: getResourceImageName(resource: resources[2].type))
            let qtd2 = (resources[2].qttPLevel * Double(resources[2].currentLevel)) + resources[2].baseQtt
            resourceQuantityType3.text = "\(Int(qtd2))"
            priceLabel.text = "\(doubleToString(value: getFactorySpendings(factory: factory)))"
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
    }
}

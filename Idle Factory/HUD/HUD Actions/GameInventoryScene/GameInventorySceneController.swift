//
//  GameInventorySceneController.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 21/10/21.
//

import UIKit

class GameInventorySceneController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - HEADER OUTLETS
    @IBOutlet weak var inventoryHeader: UILabel!
    @IBOutlet weak var purchaseFactoryButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    // MARK: - FACTORY DETAILS OUTLETS
    @IBOutlet weak var factoryInfoView: UIView!
    @IBOutlet weak var factoryImage: UIImageView!
    
    // First Product Generation
    @IBOutlet weak var typeImage1: UIImageView!
    @IBOutlet weak var quantityType1: UILabel!
    @IBOutlet weak var coinImage1: UIImageView!
    @IBOutlet weak var generatePerSecType1: UILabel!
    
    // Second Product Generation
    @IBOutlet weak var typeImage2: UIImageView!
    @IBOutlet weak var quantityType2: UILabel!
    @IBOutlet weak var coinImage2: UIImageView!
    @IBOutlet weak var generatePerSecType2: UILabel!
    
    // Third Product Generation
    @IBOutlet weak var typeImage3: UIImageView!
    @IBOutlet weak var quantityType3: UILabel!
    @IBOutlet weak var coinImage3: UIImageView!
    @IBOutlet weak var generatePerSecType3: UILabel!
    
    // Total Production Info
    @IBOutlet weak var totalProductionLabel: UILabel!
    @IBOutlet weak var coinImage4: UIImageView!
    @IBOutlet weak var totalProductionPerSec: UILabel!
    @IBOutlet weak var factorySerial_ID: UILabel!
    
    // MARK: - FACTORY DETAILS ACTIONS
    @IBOutlet weak var sellFactoryButton: UIButton!
    @IBOutlet weak var insertFactoryButton: UIButton!
    
    // MARK: - CLOSE INVENTORY
    @IBAction func closeInventory(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    static let factoryID: String = "factory_cell"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        
        hideDisplayFactoryInfo(status: true)
        
        // Inventory Header
        inventoryHeader.text = NSLocalizedString("InventoryHeader", comment: "")
        purchaseFactoryButton.titleLabel?.text = NSLocalizedString("PurchaseMoreFactoryButton", comment: "")
        purchaseFactoryButton.layer.cornerRadius = 10
        
        // Info Factories
        factoryInfoView.layer.cornerRadius = 10
        totalProductionLabel.text = NSLocalizedString("TotalProductionLabel", comment: "")
        
        // Buttons
        sellFactoryButton.layer.cornerRadius = 10
        sellFactoryButton.titleLabel?.text = NSLocalizedString("SellFactoryButton", comment: "")
        insertFactoryButton.layer.cornerRadius = 10
        insertFactoryButton.titleLabel?.text = NSLocalizedString("InsertFactoryButton", comment: "")
    }
    
    
    /**
     Hide all factory detail info if player selects a empty box on inventory. Receives a status of type Bool.
     */
    func hideDisplayFactoryInfo(status: Bool) {
        factoryImage.isHidden = status
        typeImage1.isHidden = status
        coinImage1.isHidden = status
        quantityType1.isHidden = status
        generatePerSecType1.isHidden = status
        
        typeImage2.isHidden = status
        quantityType2.isHidden = status
        coinImage2.isHidden = status
        generatePerSecType2.isHidden = status
        
        typeImage3.isHidden = status
        quantityType3.isHidden = status
        coinImage3.isHidden = status
        generatePerSecType3.isHidden = status
        factorySerial_ID.isHidden = status
        
        totalProductionLabel.isHidden = status
        coinImage4.isHidden = status
        totalProductionPerSec.isHidden = status
        
        sellFactoryButton.isHidden = status
        insertFactoryButton.isHidden = status
    }

}


extension GameInventorySceneController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let generatorsSize = (GameScene.user?.generators.count)!
        
        if indexPath.row >= generatorsSize {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.factoryID, for: indexPath) as! GameInventoryViewCell
            cell.pullFactoryData(texture: "", resources: [])
            cell.configureCell()

            return cell
        } else {
            let generator = GameScene.user?.generators[indexPath.row]
            
            let generatorResources = (generator?.resourcesArray)!
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.factoryID, for: indexPath) as! GameInventoryViewCell
            cell.pullFactoryData(texture: generator!.textureName, resources: generatorResources)
            cell.configureCell()
            return cell
        }
    }
}


extension GameInventorySceneController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GameInventoryViewCell else { return }
                cell.layer.borderWidth = 0
                cell.layer.borderColor = UIColor.black.cgColor
                cell.layer.cornerRadius = 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? GameInventoryViewCell else { return }
                cell.layer.borderWidth = 2
                cell.layer.borderColor = UIColor.black.cgColor
                cell.layer.cornerRadius = 10
        
        guard let myFactories = GameScene.user?.generators else {
            return
        }
        
        var resources: [Resource] = []
        if indexPath.row < myFactories.count {
            resources = myFactories[indexPath.row].resourcesArray
        }
        
        switch resources.count {
        case 1:
            hideDisplayFactoryInfo(status: false)
            factoryImage.image = UIImage(named: myFactories[indexPath.row].textureName)
            typeImage1.isHidden = true
            coinImage1.isHidden = true
            quantityType1.text = ""
            generatePerSecType1.text = ""
            
            typeImage2.image = UIImage(systemName: getResourceImageName(resource: resources[0].type))
            coinImage2.image = UIImage(named: "Coin")
            quantityType2.text = "\(resources[0].baseQtt) \(resources[0].type)"
            generatePerSecType2.text = doubleToString(value: resources[0].perSec)
            
            typeImage3.isHidden = true
            coinImage3.isHidden = true
            quantityType3.text = ""
            generatePerSecType3.text = ""
            
            totalProductionPerSec.text = doubleToString(value: resources[0].perSec)
            
            factorySerial_ID.text = "ID: "
            factorySerial_ID.text!.append(myFactories[indexPath.row].id!)
        case 2:
            hideDisplayFactoryInfo(status: false)
            factoryImage.image = UIImage(named: myFactories[indexPath.row].textureName)
            typeImage1.image = UIImage(systemName: getResourceImageName(resource: resources[0].type))
            coinImage1.image = UIImage(named: "Coin")
            quantityType1.text = "\(resources[0].baseQtt) \(resources[0].type)"
            generatePerSecType1.text = doubleToString(value: resources[0].perSec)
            
            typeImage2.image = UIImage(systemName: getResourceImageName(resource: resources[1].type))
            coinImage2.image = UIImage(named: "Coin")
            quantityType2.text = "\(resources[1].baseQtt) \(resources[1].type)"
            generatePerSecType2.text = doubleToString(value: resources[1].perSec)
            
            typeImage3.isHidden = true
            coinImage3.isHidden = true
            quantityType3.text = ""
            generatePerSecType3.text = "0"
            
            let total = resources[0].perSec + resources[1].perSec
            totalProductionPerSec.text = doubleToString(value:total)
            
            factorySerial_ID.text = "ID: "
            factorySerial_ID.text!.append(myFactories[indexPath.row].id!)

        case 3:
            hideDisplayFactoryInfo(status: false)
            factoryImage.image = UIImage(named: myFactories[indexPath.row].textureName)
            typeImage1.image = UIImage(systemName: getResourceImageName(resource: resources[0].type))
            coinImage1.image = UIImage(named: "Coin")
            quantityType1.text = "\(resources[0].baseQtt) \(resources[0].type)"
            generatePerSecType1.text = doubleToString(value: resources[0].perSec)
            
            typeImage2.image = UIImage(systemName: getResourceImageName(resource: resources[1].type))
            coinImage2.image = UIImage(named: "Coin")
            quantityType2.text = "\(resources[1].baseQtt) \(resources[1].type)"
            generatePerSecType2.text = doubleToString(value: resources[1].perSec)
            
            typeImage3.image = UIImage(systemName: getResourceImageName(resource: resources[2].type))
            coinImage3.image = UIImage(named: "Coin")
            quantityType3.text = "\(resources[2].baseQtt) \(resources[2].type)"
            generatePerSecType3.text = doubleToString(value: resources[2].perSec)
            
            let total = resources[0].perSec + resources[1].perSec + resources[2].perSec
            totalProductionPerSec.text = doubleToString(value:total)
            
            factorySerial_ID.text = "ID: "
            factorySerial_ID.text!.append(myFactories[indexPath.row].id!)

        default:
            hideDisplayFactoryInfo(status: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: 93, height: 90)
        return cellSize
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}


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
    @IBOutlet weak var factoryId: UILabel!
    
    // First Product Generation
    @IBOutlet weak var typeImage1: UIImageView!
    @IBOutlet weak var quantityType1: UILabel!
    @IBOutlet weak var generatePerSecType1: UILabel!
    
    // Second Product Generation
    @IBOutlet weak var typeImage2: UIImageView!
    @IBOutlet weak var quantityType2: UILabel!
    @IBOutlet weak var generatePerSecType2: UILabel!
    
    // Third Product Generation
    @IBOutlet weak var typeImage3: UIImageView!
    @IBOutlet weak var quantityType3: UILabel!
    @IBOutlet weak var generatePerSecType3: UILabel!
    
    // Total Production Info
    @IBOutlet weak var totalProductionLabel: UILabel!
    @IBOutlet weak var totalProductionPerSec: UILabel!
    @IBOutlet weak var factorySerial_ID: UILabel!
    
    // MARK: - FACTORY DETAILS ACTIONS
    @IBOutlet weak var sellFactoryButton: UIButton!
    @IBOutlet weak var insertFactoryButton: UIButton!
    
    // MARK: - CLOSE INVENTORY
    @IBAction func closeInventory(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    static let factoryID: String = "factory_cell"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        inventoryHeader.text = NSLocalizedString("InventoryHeader", comment: "")
        purchaseFactoryButton.titleLabel?.text = NSLocalizedString("PurchaseMoreFactoryButton", comment: "")
        purchaseFactoryButton.layer.cornerRadius = 10
        factoryInfoView.layer.cornerRadius = 10
        totalProductionLabel.text = NSLocalizedString("TotalProductionLabel", comment: "")
        sellFactoryButton.layer.cornerRadius = 10
        sellFactoryButton.titleLabel?.text = NSLocalizedString("SellFactoryButton", comment: "")
        
        insertFactoryButton.layer.cornerRadius = 10
        insertFactoryButton.titleLabel?.text = NSLocalizedString("InsertFactoryButton", comment: "")
        
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
            cell.pullFactoryData(texture: "Basic_Factory_level_1", id:"abcde", resources: [])
            return cell
        } else {
            let generator = GameScene.user?.generators[indexPath.row]
            
            let generatorResources = (generator?.resourcesArray)!
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.factoryID, for: indexPath) as! GameInventoryViewCell
            cell.pullFactoryData(texture: generator!.textureName, id: generator!.id!, resources: generatorResources)
        
            return cell
        }
    }
}

extension GameInventorySceneController: UICollectionViewDelegateFlowLayout {
    
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


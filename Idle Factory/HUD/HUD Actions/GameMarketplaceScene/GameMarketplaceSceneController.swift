//
//  GameMarketplaceSceneController.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 21/10/21.
//

import UIKit

class GameMarketplaceSceneController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - MARKETPLACE HEADER
    @IBOutlet weak var marketplaceHeaderLabel: UILabel!
    @IBOutlet weak var mainCurrencyHeaderView: UIView!
    @IBOutlet weak var mainCurrencyLabel: UILabel!
    @IBOutlet weak var premiumCurrencyHeaderView: UIView!
    @IBOutlet weak var premiumCurrencyLabel: UILabel!
    
    @IBOutlet weak var itemTypeSelector: UISegmentedControl!
    @IBOutlet weak var sellAItemButton: UIButton!
    @IBOutlet weak var myAnnouncesButton: UIButton!
    
    // MARK: - CONTROLLERS
    static let factoryID: String = "purchasebleFactory_cell"
    
    // Selected Factory control
    private(set) var selectedFactory: Factory? = nil
    private(set) var selectedFactoryIndex: Int = -1 // Index of the cell
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Design components
        mainCurrencyHeaderView.layer.cornerRadius = 10
        premiumCurrencyHeaderView.layer.cornerRadius = 10
        sellAItemButton.layer.cornerRadius = 10
        myAnnouncesButton.layer.cornerRadius = 10
        
        // Setting text
        marketplaceHeaderLabel.text = NSLocalizedString("MarketplaceHeaderLabel", comment: "")
        itemTypeSelector.setTitle(NSLocalizedString("BasicSelectorItem", comment: ""), forSegmentAt: 0)
        itemTypeSelector.setTitle(NSLocalizedString("PremiumSelectorItem", comment: ""), forSegmentAt: 1)
        sellAItemButton.setTitle(NSLocalizedString("SellAItemButton", comment: ""), for: .normal)
        myAnnouncesButton.setTitle(NSLocalizedString("MyAnnouncesButton", comment: ""), for: .normal)
        loadPlayerCurrencies()
    }
    
    
    // MARK: - ACTIONS
    /**
     Close Marketplace scene.
     */
    @IBAction func closeMarketplace(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    /**
     Call player inventory scene if clicks to sell a item.
     */
    @IBAction func displayInventory(_ sender: Any) {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "GameInventoryScene", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "InventoryStoryboard") as UIViewController
        self.present(viewcontroller, animated: false)
    }
    
    
    /**
     Call player announce scene.
     */
    @IBAction func displayMyAnnounces(_ sender: Any) {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "GameMarketplaceScene", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "AnnounceStoryboard") as UIViewController
        self.present(viewcontroller, animated: false)
    }


    /**
     Load player actual currencies value.
     */
    func loadPlayerCurrencies() {
        mainCurrencyLabel.text = doubleToString(value: GameScene.user?.mainCurrency ?? 0.0)
        premiumCurrencyLabel.text = doubleToString(value: GameScene.user?.premiumCurrency ?? 0.0)
    }
    
}


// MARK: - COLLECTIONVIEW DATASOURCE
extension GameMarketplaceSceneController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        #warning("CHANGE FROM WHERE IT PULLS")
        let generatorsSize = (GameScene.user?.generators.count)!
        
        if indexPath.row >= generatorsSize {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.factoryID, for: indexPath) as! GameMarketplaceViewCell
            cell.pullMarketplaceFactories(texture: "", resources: [])
            cell.configureCell()

            return cell
        } else {
            #warning("CHANGE FROM WHERE IT PULLS")
            let generator = GameScene.user?.generators[indexPath.row]
            let generatorResources = (generator?.resourcesArray)!
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.factoryID, for: indexPath) as! GameMarketplaceViewCell

            // Check the item selector if Basic or Premium
            if itemTypeSelector.selectedSegmentIndex == 0 {
                self.collectionView.reloadData()
                cell.pullMarketplaceFactories(texture: generator!.textureName, resources: generatorResources)
                cell.configureCell()
                return cell
            } else {
                self.collectionView.reloadData()
                cell.pullMarketplaceFactories(texture: "", resources: [])
                cell.configureCell()
                return cell
            }

        }
    }
}


// MARK: - COLLECTIONVIEW DELEGATE
extension GameMarketplaceSceneController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GameMarketplaceViewCell else { return }
                cell.layer.borderWidth = 0
                cell.layer.borderColor = UIColor.black.cgColor
                cell.layer.cornerRadius = 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? GameMarketplaceViewCell else { return }
                cell.layer.borderWidth = 2
                cell.layer.borderColor = UIColor.black.cgColor
                cell.layer.cornerRadius = 10
        
        #warning("SELECTED DATA FROM MARKETPLACE??")
        guard let factory = GameScene.user?.generators else {
            return
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: 131, height: 201)
        return cellSize
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

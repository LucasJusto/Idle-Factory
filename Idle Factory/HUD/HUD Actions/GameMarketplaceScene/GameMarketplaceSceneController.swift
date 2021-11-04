//
//  GameMarketplaceSceneController.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 21/10/21.
//

import UIKit


/**
 Game Marketplace scene controller.
 */
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
    private(set) var offerArray: [Offer] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    private(set) var generatorDict: [String: Factory] = [:]
    
    
    // MARK: - INIT
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
        
        CKRepository.getMarketPlaceOffers(completion: { offers in
            let generatorsId: [String] = offers.map { offer in
                offer.generatorID
            }
            let semaphore = DispatchSemaphore(value: 0)
            CKRepository.getGeneratorsByIDs(generatorsIDs: generatorsId) { factories in
                for factory in factories {
                    self.generatorDict[factory.id!] = factory
                }
                semaphore.signal()
            }
            semaphore.wait()

            self.offerArray = offers.filter({ offer in
                offer.currencyType == .basic
            })
        })
    }
    
    
    // MARK: - ACTIONS
    /**
     Close Marketplace scene.
     */
    @IBAction func closeMarketplace(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
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

    
    #warning("BOTÃO SEE MORE")
    @IBAction func seeMore(_ sender: Any) {
        FactoryDetailSceneController.isBlue = false
        FactoryDetailSceneController.generator = generatorDict[offerArray[0].generatorID]
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "FactoryDetailScene", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "FactoryDetailScene") as UIViewController
        self.present(viewcontroller, animated: false)
    }
    
    
    /**
     Return all offers selected in segmented control.
     */
    @IBAction func indexChanged(_ sender: Any) {
        switch itemTypeSelector.selectedSegmentIndex {
        case 0:
            CKRepository.getMarketPlaceOffers(completion: { offers in
                self.offerArray = offers.filter({ offer in
                    offer.currencyType == .basic
                })
            })
        case 1:
            CKRepository.getMarketPlaceOffers(completion: { offers in
                self.offerArray = offers.filter({ offer in
                    offer.currencyType == .premium
                })
            })
        default: break
        }
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
        return offerArray.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let generator = generatorDict[offerArray[indexPath.row].generatorID]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.factoryID, for: indexPath) as! GameMarketplaceViewCell

        // Check the item selector if Basic or Premium
        if itemTypeSelector.selectedSegmentIndex == 0 {
            cell.pullMarketplaceFactories(factory: generator!, offer: offerArray[indexPath.row])
            cell.configureCell()
            return cell
        } else {
            cell.pullMarketplaceFactories(factory: generator!, offer: offerArray[indexPath.row])
            cell.configureCell()
            return cell
        }
    }
}


// MARK: - COLLECTIONVIEW DELEGATE
extension GameMarketplaceSceneController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: 131, height: 195)
        return cellSize
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

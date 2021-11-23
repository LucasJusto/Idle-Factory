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
class GameMarketplaceSceneController: UIViewController, NavigationCellDelegate {
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
    
    // MARK: - EMPTY MARKETPLACE LABEL
    @IBOutlet weak var emptyMarketplaceLabel: UILabel!
    
    // MARK: - CONTROLLERS
    static let factoryID: String = "purchasebleFactory_cell"
    
    // Selected Factory control
    private(set) var timeToRefreshCurrency: Timer?
    private(set) var selectedFactory: Factory? = nil
    private(set) var selectedFactoryIndex: Int = -1 // Index of the cell
    fileprivate(set) var offerArray: [Offer] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                if self.offerArray.count != 0 {
                    self.emptyMarketplaceLabel.isHidden = true
                } else {
                    self.emptyMarketplaceLabel.isHidden = false
                }
            }
        }
    }
    private(set) var generatorDict: [String: Factory] = [:]
    

    // MARK: - INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        loadOutletCustomizations()
        loadCustomFont()

        // Setting text
        marketplaceHeaderLabel.text = NSLocalizedString("MarketplaceHeaderLabel", comment: "")
        itemTypeSelector.setTitle(NSLocalizedString("BasicSelectorItem", comment: ""), forSegmentAt: 0)
        itemTypeSelector.setTitle(NSLocalizedString("PremiumSelectorItem", comment: ""), forSegmentAt: 1)
        sellAItemButton.setTitle(NSLocalizedString("SellAItemButton", comment: ""), for: .normal)
        myAnnouncesButton.setTitle(NSLocalizedString("MyAnnouncesButton", comment: ""), for: .normal)
        emptyMarketplaceLabel.text = NSLocalizedString("EmptyMarketplaceLabel", comment: "")

        loadPlayerCurrencies()
        
        DispatchQueue.global().async {
            self.loadMarketplace()
        }

        timeToRefreshCurrency = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(loadPlayerCurrencies), userInfo: nil, repeats: true)
        
    }
    
    
    // MARK: - DESIGN FUNCTIONS
    /**
     Load outlet customizations.
     */
    func loadOutletCustomizations() {
        // INVENTORY HEADER
        mainCurrencyHeaderView.layer.cornerRadius = 10
        premiumCurrencyHeaderView.layer.cornerRadius = 10
        
        // BUTTONS
        sellAItemButton.layer.cornerRadius = 10
        myAnnouncesButton.layer.cornerRadius = 10
        
        // UI SEGMENTED CONTROL
        itemTypeSelector.backgroundColor = UIColor(named: "Marketplace_background")
        itemTypeSelector.layer.borderColor = UIColor.white.cgColor
        itemTypeSelector.layer.borderWidth = 1
        itemTypeSelector.layer.masksToBounds = true
    }
    
    
    /**
     Load custom font to all labels and button text.
     */
    func loadCustomFont() {
        // LABELS
        marketplaceHeaderLabel.font = UIFont(name: "AustralSlabBlur-Regular", size: 27)
        mainCurrencyLabel.font = UIFont(name: "AustralSlabBlur-Regular", size: 14)
        premiumCurrencyLabel.font = UIFont(name: "AustralSlabBlur-Regular", size: 14)
        emptyMarketplaceLabel.font = UIFont(name: "AustralSlabBlur-Regular", size: 27)
        
        // BUTTONS
        sellAItemButton.titleLabel?.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
        myAnnouncesButton.titleLabel?.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
        
        // UI SEGMENTED CONTROL
        let attr = NSDictionary(object: UIFont(name: "AustralSlabBlur-Regular", size: 10)!, forKey: NSAttributedString.Key.font as NSCopying)
        itemTypeSelector.setTitleTextAttributes(attr as? [NSAttributedString.Key: Any] , for: .normal)
    }
    
    
    // MARK: - ACTIONS
    /**
     Close Marketplace scene.
     */
    @IBAction func closeMarketplace(_ sender: Any) {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        Haptics.shared.activateHaptics(sound: .sucess)
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    
    /**
     Call player inventory scene if clicks to sell a item.
     */
    @IBAction func displayInventory(_ sender: Any) {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        Haptics.shared.activateHaptics(sound: .sucess)
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "GameInventoryScene", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "InventoryStoryboard") as UIViewController
        self.present(viewcontroller, animated: false)
    }
    
    
    /**
     Call player announce scene.
     */
    @IBAction func displayMyAnnounces(_ sender: Any) {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        Haptics.shared.activateHaptics(sound: .sucess)
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "GameMarketplaceScene", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "AnnounceStoryboard") as UIViewController
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
    
    
    func didButtonPressed() {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        Haptics.shared.activateHaptics(sound: .sucess)
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "FactoryDetailScene", bundle: nil)
        guard let viewcontroller = mainView.instantiateViewController(withIdentifier: "FactoryDetailScene") as? FactoryDetailSceneController
        else {fatalError("deveria ser do tipo FactoryDetailSceneController.")}
        viewcontroller.delegate = self
        
        self.present(viewcontroller, animated: false)
    }
    
    
    //MARK: - LOAD DATA
    /**
     Load player actual currencies value.
     */
    @objc func loadPlayerCurrencies() {
        mainCurrencyLabel.text = doubleToString(value: GameScene.user?.mainCurrency ?? 0.0)
        premiumCurrencyLabel.text = doubleToString(value: GameScene.user?.premiumCurrency ?? 0.0)
    }
    
    
    /**
     Load marketplace offers. Marketplace contains a selector between basic and premium offers. The default option of the selector is Basic, so this function loads only the basic offers first.
     */
    func loadMarketplace() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
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
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
            
        })
    }
}


// MARK: - COLLECTIONVIEW DATASOURCE
extension GameMarketplaceSceneController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return offerArray.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.factoryID, for: indexPath) as! GameMarketplaceViewCell
        
        if let generator = generatorDict[offerArray[indexPath.row].generatorID] {
            // Check the item selector if Basic or Premium
            if itemTypeSelector.selectedSegmentIndex == 0 {
                cell.pullMarketplaceFactories(factory: generator, offer: offerArray[indexPath.row], premium: false)
                cell.configureCell()
                cell.delegate = self
                return cell
            } else {
                cell.pullMarketplaceFactories(factory: generator, offer: offerArray[indexPath.row], premium: true)
                cell.configureCell()
                cell.delegate = self
                return cell
            }
        } else {
            cell.hideCell()
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

protocol MarketPlaceRefresh: AnyObject {
    func refresh(offer: Offer)
}

extension GameMarketplaceSceneController: MarketPlaceRefresh {
    func refresh(offer: Offer) {
        offerArray.removeAll(where: { o in
            o.id == offer.id
        })
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

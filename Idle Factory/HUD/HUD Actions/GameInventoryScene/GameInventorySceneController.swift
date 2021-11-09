//
//  GameInventorySceneController.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 21/10/21.
//

import UIKit


/**
 Game Inventory scene controller. 
 */
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
    
    // Total Production & ID Info
    @IBOutlet weak var totalProductionLabel: UILabel!
    @IBOutlet weak var coinImage4: UIImageView!
    @IBOutlet weak var totalProductionPerSec: UILabel!
    @IBOutlet weak var factorySerial_ID: UILabel!
    
    
    // MARK: - EMPTY FACTORY DETAILS OUTLETS
    @IBOutlet weak var emptySlotLabel: UILabel!
    @IBOutlet weak var purchaseFactoryEmptySlotButton: UIButton!
    
    
    // MARK: - FACTORY DETAILS BUTTONS
    @IBOutlet weak var sellFactoryButton: UIButton!
    @IBOutlet weak var insertFactoryButton: UIButton!
    
    
    // MARK: - QUICK SELL OUTLETS
    @IBOutlet weak var quickSellBackground: UIView!
    @IBOutlet weak var quickSellView: UIView!
    @IBOutlet weak var quickSellQuestionLabel: UILabel!
    @IBOutlet weak var quickSellEarnLabel: UILabel!
    @IBOutlet weak var quickSellCoinImage: UIImageView!
    @IBOutlet weak var quickSellEarningLabel: UILabel!
    
    // Quick Sell Buttons
    @IBOutlet weak var cancelQuickSell: UIButton!
    @IBOutlet weak var confirmQuickSell: UIButton!
    
    
    // MARK: - CONTROLLERS
    static let factoryID: String = "factory_cell"
    
    // Selected Factory control
    private(set) var selectedFactory: Factory?
    private(set) var selectedFactoryIndex: Int? // Index of the cell
    var factoriesNotActive: [Factory] = []
    
    // Slot clicked from the GameScene (Default is .none)
    var clickedSlotPosition: GeneratorPositions = .none
    
    
    // MARK: - INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        
        hideDisplayFactoryInfo(status: true)
        hideQuickSellModal(status: true)
        
        loadOutletCustomizations()
        loadCustomFont()
        
        // Inventory Header
        inventoryHeader.text = NSLocalizedString("InventoryHeader", comment: "")
        purchaseFactoryButton.setTitle(NSLocalizedString("PurchaseMoreFactoryButton", comment: ""), for: .normal)
        purchaseFactoryEmptySlotButton.setTitle(NSLocalizedString("PurchaseAFactoryEmptySlotButton", comment: ""), for: .normal)
        
        // Info Factories
        totalProductionLabel.text = NSLocalizedString("TotalProductionLabel", comment: "")
        
        // Buttons
        sellFactoryButton.setTitle(NSLocalizedString("SellFactoryButton", comment: ""), for: .normal)
        insertFactoryButton.setTitle(clickedSlotPosition == .none ? NSLocalizedString("AnnounceFactoryButton", comment: "") : NSLocalizedString("InsertFactoryButton", comment: ""), for: .normal)
        
        // Quick Sell Modal
        quickSellQuestionLabel.text = NSLocalizedString("QuickSellQuestionConfirmationLabel", comment: "")
        quickSellEarnLabel.text = NSLocalizedString("QuickSellEarnLabel", comment: "")
        cancelQuickSell.setTitle(NSLocalizedString("QuickSellCancelButton", comment: ""), for: .normal)
        confirmQuickSell.setTitle(NSLocalizedString("QuickSellConfirmButton", comment: ""), for: .normal)
    
        // Load not active generators list.
        factoriesNotActive = (GameScene.user?.generators.filter( { factory in
            factory.isActive == .no
        }))!
    }
    
    // MARK: - DESIGN FUNCTIONS
    func loadOutletCustomizations() {
        // Inventory Header
        purchaseFactoryButton.layer.cornerRadius = 10

        // Info Factories
        factoryInfoView.layer.cornerRadius = 10
        
        // Buttons
        sellFactoryButton.layer.cornerRadius = 10
        insertFactoryButton.layer.cornerRadius = 10
        purchaseFactoryEmptySlotButton.layer.cornerRadius = 10
        
        // Quick Sell Modal
        quickSellView.layer.cornerRadius = 10
        cancelQuickSell.layer.cornerRadius = 10
        confirmQuickSell.layer.cornerRadius = 10
    }
    
    /**
     Load custom font to all labels and button text.
     */
    func loadCustomFont() {
        // LABELS
        inventoryHeader.font = UIFont(name: "AustralSlabBlur-Regular", size: 27)
        emptySlotLabel.font = UIFont(name: "AustralSlabBlur-Regular", size: 27)
        quantityType1.font = UIFont(name: "AustralSlabBlur-Regular", size: 7)
        generatePerSecType1.font = UIFont(name: "AustralSlabBlur-Regular", size: 7)
        quantityType2.font = UIFont(name: "AustralSlabBlur-Regular", size: 7)
        generatePerSecType2.font = UIFont(name: "AustralSlabBlur-Regular", size: 7)
        quantityType3.font = UIFont(name: "AustralSlabBlur-Regular", size: 7)
        generatePerSecType3.font = UIFont(name: "AustralSlabBlur-Regular", size: 7)
        totalProductionLabel.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
        totalProductionPerSec.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
        factorySerial_ID.font = UIFont(name: "AustralSlabBlur-Regular", size: 7)
        quickSellQuestionLabel.font = UIFont(name: "AustralSlabBlur-Regular", size: 27)
        quickSellEarnLabel.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
        quickSellEarningLabel.font = UIFont(name: "AustralSlabBlur-Regular", size: 17)
        
        // BUTTONS
        purchaseFactoryButton.titleLabel?.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
        purchaseFactoryEmptySlotButton.titleLabel?.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
        sellFactoryButton.titleLabel?.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
        insertFactoryButton.titleLabel?.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
        cancelQuickSell.titleLabel?.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
        confirmQuickSell.titleLabel?.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
    }
    
    
    // MARK: - ACTIONS
    /**
     Close Inventory scene.
     */
    @IBAction func closeInventory(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    
    /**
     Go to shop to purchase a factory.
     */
    @IBAction func goToShop(_ sender: Any) {
        let mainView = UIStoryboard(name: "GameShopScene", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "ShopStoryboard") as UIViewController
        self.present(viewcontroller, animated: false)
    }
    
    
    /**
     Modal message of Quick sell is displayed. Quick Sell is a way to earn main currency quickly. The gaining is calculated by 50% of the price paid for the generator.
     */
    @IBAction func quickSell(_ sender: Any) {
        hideQuickSellModal(status: false)
        quickSellEarningLabel.text = "\(calculateQuickSell(factory: selectedFactory!))"
    }
    
    
    /**
     Cancel the quick sell action.
     */
    @IBAction func cancelQuickSell(_ sender: Any) {
        hideQuickSellModal(status: true)
    }
    
    
    /**
     Confirm the quick sell action. Player lose the generator and cannot be recovered.
     */
    @IBAction func confirmQuickSell(_ sender: Any) {
        DispatchQueue.global().async {
            let earnings_sell: Double = calculateQuickSell(factory: self.selectedFactory!)
            let semaphore = DispatchSemaphore(value: 0)
            CKRepository.deleteGeneratorByID(generatorID: (self.selectedFactory?.id)!) { error in
                if error == nil {
                    GameScene.user?.addMainCurrency(value: earnings_sell)
                    GameScene.user?.generators.remove(at: self.selectedFactoryIndex!)
                    self.factoriesNotActive.remove(at: self.selectedFactoryIndex!)
                    CKRepository.storeUserData(id: GameScene.user!.id , name:  GameScene.user?.name ?? "", mainCurrency:  GameScene.user!.mainCurrency , premiumCurrency:  GameScene.user!.premiumCurrency, timeLeftApp: AppDelegate.gameSave.transformToSeconds(time: AppDelegate.gameSave.getCurrentTime()) , completion: {_,_ in
                        semaphore.signal()
                    })
                } else {
                    semaphore.signal()
                }
                semaphore.signal()
            }
            semaphore.wait()
            semaphore.wait()

            DispatchQueue.main.async {
                self.deselectCell(indexPath: IndexPath(row: self.selectedFactoryIndex!, section: 0))
                self.collectionView.reloadData()
                self.hideQuickSellModal(status: true)
            }
        }
    }
    
    
    /**
     Deselect a cell receiving the indexPath of this cell.
     */
    func deselectCell(indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: false)
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.layer.borderWidth = 0
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.cornerRadius = 10
        }
        hideDisplayFactoryInfo(status: true)
    }
    
    
    /**
     Action to insert ou announce a factory. This function depends from where user clicked to enter on this scene. This is controlled by the 'clickedSource' variable. If player comes by 'add factory', this action will place a factory from the Inventory to the scene. If player clicks by Inventory button, this action will make announce a factory possible to be announced on marketplace.
     */
    @IBAction func insertOrAnnounceFactory(_ sender: Any) {
        
        if clickedSlotPosition == .none {
            announceFactory()
        } else {
            insertOnPark()
        }
    }

    
    /**
     Announce a factory on the marketplace to other players.
     */
    func announceFactory() {
        print("Announce park")
    }
    
    
    /**
     Insert a factory from the Inventory to park. Turn the factory as active to generate resource to the Idle game.
     */
    func insertOnPark() {
        selectedFactory?.isActive = .yes
        selectedFactory?.position = clickedSlotPosition
        DispatchQueue.global().async {
            CKRepository.editGenerators(userID: GameScene.user!.id, generators: GameScene.user!.generators) { record, error in
                
                if error == nil {
                    DispatchQueue.main.async {
                        self.deselectCell(indexPath: IndexPath(row: self.selectedFactoryIndex!, section: 0))
                        GameViewController.scene!.addFactory(factory: self.selectedFactory!)
                        self.factoriesNotActive.remove(at: self.selectedFactoryIndex!)
                        self.collectionView.reloadData()
                    }
                } else {
                    self.selectedFactory?.position = .none
                    self.selectedFactory?.isActive = .no
                }
            }
        }
    }
    
    
    // MARK: - HIDE / UNHIDE DATA
    /**
     Hide / Unhide all factory detail info if player selects a empty box on inventory. Receives a status of type Bool.
     */
    func hideDisplayFactoryInfo(status: Bool) {
        // Factory Image
        factoryImage.isHidden = status
        
        // Factory Resource 1
        typeImage1.isHidden = status
        coinImage1.isHidden = status
        quantityType1.isHidden = status
        generatePerSecType1.isHidden = status
        
        // Factory Resource 2
        typeImage2.isHidden = status
        quantityType2.isHidden = status
        coinImage2.isHidden = status
        generatePerSecType2.isHidden = status
        
        // Factory Resource 3
        typeImage3.isHidden = status
        quantityType3.isHidden = status
        coinImage3.isHidden = status
        generatePerSecType3.isHidden = status
        
        // Factory totals
        totalProductionLabel.isHidden = status
        coinImage4.isHidden = status
        totalProductionPerSec.isHidden = status
        factorySerial_ID.isHidden = status

        // Actions
        sellFactoryButton.isHidden = status
        insertFactoryButton.isHidden = status
        
        // Empty Slot
        emptySlotLabel.isHidden = !status
        purchaseFactoryEmptySlotButton.isHidden = !status
    }
    
    
    /**
     Hide / Unhide quick sell modal. Is only displayed when user clicks to quick sell a factory.
     */
    func hideQuickSellModal(status: Bool) {
        quickSellBackground.isHidden = status
        quickSellView.isHidden = status
        quickSellQuestionLabel.isHidden = status
        quickSellEarnLabel.isHidden = status
        quickSellCoinImage.isHidden = status
        quickSellEarningLabel.isHidden = status
        cancelQuickSell.isHidden = status
        confirmQuickSell.isHidden = status
    }
}


// MARK: - COLLECTIONVIEW DATASOURCE
extension GameInventorySceneController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let generatorsSize = factoriesNotActive.count
        
        if indexPath.row >= generatorsSize {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.factoryID, for: indexPath) as! GameInventoryViewCell
            cell.pullFactoryData(texture: "empty-slot", resources: [])
            cell.configureCell()

            return cell
        } else {
            let generator = factoriesNotActive[indexPath.row]
            let generatorResources = (generator.resourcesArray)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.factoryID, for: indexPath) as! GameInventoryViewCell

            cell.pullFactoryData(texture: generator.textureName, resources: generatorResources)
            cell.configureCell()

            return cell
        }
    }
}


// MARK: - COLLECTIONVIEW DELEGATE
extension GameInventorySceneController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if factoriesNotActive.indices.contains(indexPath.row) {
            return true
        } else {
            if let indices = collectionView.indexPathsForSelectedItems {
                for indexPath in indices {
                    deselectCell(indexPath: indexPath)
                }
            }
            return false
        }
    }
    
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
        
        let myFactories = factoriesNotActive
        
        var resources: [Resource] = []
        if indexPath.row < myFactories.count {
            if myFactories[indexPath.row].isActive == .no {
                selectedFactory = myFactories[indexPath.row]
                selectedFactoryIndex = indexPath.row
                resources = myFactories[indexPath.row].resourcesArray
            }
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
            factorySerial_ID.text!.append(myFactories[indexPath.row].id ?? "-")
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
            generatePerSecType3.text = ""
            
            let total = resources[0].perSec + resources[1].perSec
            totalProductionPerSec.text = doubleToString(value:total)
            
            factorySerial_ID.text = "ID: "
            factorySerial_ID.text!.append(myFactories[indexPath.row].id ?? "-")

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
            factorySerial_ID.text!.append(myFactories[indexPath.row].id ?? "-")

        default:
            hideDisplayFactoryInfo(status: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: 94, height: 90)
        return cellSize
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9.63
    }
    
}


//
//  GameShopSceneViewController.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 03/11/21.
//

import UIKit


/**
 Game Shop scene controller.
 */
class GameShopSceneViewController: UIViewController, NavigationCellDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - MARKETPLACE HEADER
    @IBOutlet weak var shopHeaderLabel: UILabel!
    @IBOutlet weak var mainCurrencyHeaderView: UIView!
    @IBOutlet weak var mainCurrencyLabel: UILabel!
    @IBOutlet weak var premiumCurrencyHeaderView: UIView!
    @IBOutlet weak var premiumCurrencyLabel: UILabel!
    
    @IBOutlet weak var generateNFTButton: UIButton!
    @IBOutlet weak var openMarketplaceButton: UIButton!
    
    
    // MARK: - CONTROLLERS
    static let factoryID: String = "shopFactory_cell"
    private(set) var basicFactories: [Factory] = []
    
    
    func didButtonPressed() {
        print(#function)
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "FactoryDetailScene", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "FactoryDetailScene") as UIViewController
        self.present(viewcontroller, animated: false)
    }
    
    // MARK: - INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Design components
        mainCurrencyHeaderView.layer.cornerRadius = 10
        premiumCurrencyHeaderView.layer.cornerRadius = 10
        generateNFTButton.layer.cornerRadius = 10
        openMarketplaceButton.layer.cornerRadius = 10
        
        
        // Setting text
        shopHeaderLabel.text = NSLocalizedString("ShopHeaderLabel", comment: "")
        generateNFTButton.setTitle(NSLocalizedString("GenerateNFTButton", comment: ""), for: .normal)
        openMarketplaceButton.setTitle(NSLocalizedString("OpenMarketplaceButton", comment: ""), for: .normal)
        loadPlayerCurrencies()
        
        let resourceArray: [ResourceType] = [ResourceType.headphone, ResourceType.smartTV, ResourceType.smartphone, ResourceType.tablet, ResourceType.computer]

        
        for _ in 0..<20 {
            basicFactories.append(createBasicFactory(resourceTypeArray: resourceArray))
        }
    }
    
    
    // MARK: - ACTIONS
    /**
     Close Shop scene.
     */
    @IBAction func closeShop(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }

    
    /**
     Generate a random NFT generator.
     */
    @IBAction func generateNFT(_ sender: Any) {
        
    }
    
    
    /**
     Display Marketplace scene.
     */
    @IBAction func displayMarketplace(_ sender: Any) {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "GameMarketplaceScene", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "MarketplaceStoryboard") as UIViewController
        self.present(viewcontroller, animated: false)
    }
    
    
    
    func presentView(viewController: UIViewController){
        self.present(viewController, animated: false)
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
extension GameShopSceneViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return basicFactories.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let generator = basicFactories[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.factoryID, for: indexPath) as! GameShopViewCell

        cell.pullShopFactories(factory: generator)
            cell.configureCell()
        cell.delegate = self
            return cell
    }
}


// MARK: - COLLECTIONVIEW DELEGATE
extension GameShopSceneViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: 131, height: 201)
        return cellSize
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

}

//
//  GameAnnounceSceneViewController.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 02/11/21.
//

import UIKit

class GameAnnounceSceneViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - MARKETPLACE HEADER
    @IBOutlet weak var announceHeaderLabel: UILabel!
    @IBOutlet weak var mainCurrencyHeaderView: UIView!
    @IBOutlet weak var mainCurrencyLabel: UILabel!
    @IBOutlet weak var premiumCurrencyHeaderView: UIView!
    @IBOutlet weak var premiumCurrencyLabel: UILabel!
    
    // MARK: - CONTROLLERS
    static let factoryID: String = "announceFactory_cell"
    private(set) var playerAnnounces: [Factory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Design components
        mainCurrencyHeaderView.layer.cornerRadius = 10
        premiumCurrencyHeaderView.layer.cornerRadius = 10

        
        // Setting text
        announceHeaderLabel.text = NSLocalizedString("AnnounceHeaderLabel", comment: "")
        loadPlayerCurrencies()
    }
    
    
    // MARK: - ACTIONS
    
    /**
     Return to Marketplace scene.
     */
    @IBAction func returnToMarketplace(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
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
extension GameAnnounceSceneViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playerAnnounces.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        #warning("CHANGE FROM WHERE IT PULLS")
        let generator = GameScene.user?.generators[indexPath.row]
        let generatorResources = (generator?.resourcesArray)!
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.factoryID, for: indexPath) as! GameAnnounceViewCell

        #warning("IMPLEMENT HERE ")
        return cell
        
    }
}


// MARK: - COLLECTIONVIEW DELEGATE
extension GameAnnounceSceneViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: 131, height: 201)
        return cellSize
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}


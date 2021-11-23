//
//  GameAnnounceSceneViewController.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 02/11/21.
//

import UIKit


/**
 Game Announce scene controller.
 */
class GameAnnounceSceneViewController: UIViewController, NavigationCellDelegate, RefreshCollectionDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - ANNOUNCE HEADER
    @IBOutlet weak var announceHeaderLabel: UILabel!
    @IBOutlet weak var mainCurrencyHeaderView: UIView!
    @IBOutlet weak var mainCurrencyLabel: UILabel!
    @IBOutlet weak var premiumCurrencyHeaderView: UIView!
    @IBOutlet weak var premiumCurrencyLabel: UILabel!
    
    // MARK: - EMPTY ANNOUNCE LABEL
    @IBOutlet weak var emptyAnnounceLabel: UILabel!
    
    // MARK: - CONTROLLERS
    private(set) var timeToRefreshCurrency: Timer?
    static let factoryID: String = "announceFactory_cell"
    private(set) var playerAnnounces: [Offer] = []
    private(set) var announcesDict:  [String: Factory] = [:]
    
    // MARK: - INIT
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        loadOutletCustomizations()
        loadCustomFont()
        
        // Setting text
        announceHeaderLabel.text = NSLocalizedString("AnnounceHeaderLabel", comment: "")
        emptyAnnounceLabel.text = NSLocalizedString("EmptyAnnounceLabel", comment: "")
        
        loadPlayerCurrencies()
        
        // Load player announces
        DispatchQueue.global().async {
            self.loadPlayerAnnounces()
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
    }
    
    
    /**
     Load custom font to all labels and button text.
     */
    func loadCustomFont() {
        // LABELS
        announceHeaderLabel.font = UIFont(name: "AustralSlabBlur-Regular", size: 27)
        mainCurrencyLabel.font = UIFont(name: "AustralSlabBlur-Regular", size: 14)
        premiumCurrencyLabel.font = UIFont(name: "AustralSlabBlur-Regular", size: 14)
        emptyAnnounceLabel.font = UIFont(name: "AustralSlabBlur-Regular", size: 27)
    }
    
    
    // MARK: - ACTIONS
    /**
     Return to Marketplace scene.
     */
    @IBAction func returnToMarketplace(_ sender: Any) {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        Haptics.shared.activateHaptics(sound: .sucess)
        self.dismiss(animated: false, completion: nil)
    }
    
    
    func refresh() {
        CKRepository.getUserOffersByID(userID: GameScene.user!.id) { offers in
            let generatorsId: [String] = offers.map { offer in
                offer.generatorID
            }
            let semaphore = DispatchSemaphore(value: 0)
            CKRepository.getGeneratorsByIDs(generatorsIDs: generatorsId) { factories in
                for factory in factories {
                    self.announcesDict[factory.id!] = factory
                }
                semaphore.signal()
            }
            semaphore.wait()

            self.playerAnnounces = offers
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        DispatchQueue.main.async {
            if self.playerAnnounces.count != 0 {
                self.emptyAnnounceLabel.isHidden = true
            } else {
                self.emptyAnnounceLabel.isHidden = false
            }
        }
        
    }
    
    func didButtonPressed() {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "FactoryDetailScene", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "FactoryDetailScene") as UIViewController
        self.present(viewcontroller, animated: false)
    }
    
    
    // MARK: - LOAD DATA
    /**
     Load player actual currencies value.
     */
    @objc func loadPlayerCurrencies() {
        mainCurrencyLabel.text = doubleToString(value: GameScene.user?.mainCurrency ?? 0.0)
        premiumCurrencyLabel.text = doubleToString(value: GameScene.user?.premiumCurrency ?? 0.0)
    }
    
    
    /**
     Load player announced generators.
     */
    func loadPlayerAnnounces() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        let semaphore2 = DispatchSemaphore(value: 0)
        CKRepository.getUserOffersByID(userID: GameScene.user!.id) { offers in
            let generatorsId: [String] = offers.map { offer in
                offer.generatorID
            }
            let semaphore = DispatchSemaphore(value: 0)
            CKRepository.getGeneratorsByIDs(generatorsIDs: generatorsId) { factories in
                for factory in factories {
                    self.announcesDict[factory.id!] = factory
                }
                semaphore.signal()
            }
            semaphore.wait()

            self.playerAnnounces = offers
            semaphore2.signal()
        }
        semaphore2.wait()
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            if self.playerAnnounces.count != 0 {
                self.emptyAnnounceLabel.isHidden = true
                self.collectionView.reloadData()
            } else {
                self.emptyAnnounceLabel.isHidden = false
            }
        }
    }
}


// MARK: - COLLECTIONVIEW DATASOURCE
extension GameAnnounceSceneViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(playerAnnounces.count)
        return playerAnnounces.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.factoryID, for: indexPath) as! GameAnnounceViewCell

        if let generatorOffer = announcesDict[playerAnnounces[indexPath.row].generatorID] {
            cell.pullMyAnnouncesFactories(factory: generatorOffer, offer: playerAnnounces[indexPath.row], premium: generatorOffer.type == .Basic ? false : true)
            cell.configureCell()
            cell.delegate = self
            cell.delegate2 = self
            return cell

        } else {
            cell.hideCell()
            cell.delegate = self
            cell.delegate2 = self
            return cell
        }
    }
}


// MARK: - COLLECTIONVIEW DELEGATE
extension GameAnnounceSceneViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: 160, height: 225)
        return cellSize
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

protocol RefreshCollectionDelegate {
    func refresh()
}

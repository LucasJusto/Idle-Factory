//
//  UpgradeFactorySceneController.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 26/10/21.
//

import UIKit
import SpriteKit

class UpgradeFactorySceneController: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var upgradeHeader: UILabel!
    @IBOutlet weak var mainCurrencyView: UIView!
    @IBOutlet weak var premiumCurrencyView: UIView!
    @IBOutlet weak var mainCurrencyLabel: UILabel!
    @IBOutlet weak var premiumCurrencyLabel: UILabel!
    @IBOutlet weak var SKView: SKView!
    @IBOutlet weak var changeFactoryButton: UIButton!
    @IBOutlet weak var moveToInventoryButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    static var generator: Factory?
    private(set) var timeToRefreshCurrency: Timer?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        loadOutletCustomizations()
        loadCustomFont()
        loadPlayerCurrencies()

        upgradeHeader.text = NSLocalizedString("UpgradeHeaderLabel", comment: "")
        changeFactoryButton.setTitle(NSLocalizedString("ChangeFactory", comment: ""), for: UIControl.State.normal)
        moveToInventoryButton.setTitle(NSLocalizedString("MoveToInventory", comment: ""), for: UIControl.State.normal)
        
        let scene = FactoryScene(size: CGSize(width: 400, height: 400))
        scene.thisFactory = UpgradeFactorySceneController.generator
        scene.scaleMode = .aspectFill
        SKView.presentScene(scene)
        
        timeToRefreshCurrency = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(loadPlayerCurrencies), userInfo: nil, repeats: true)
    }
    
    
    // MARK: - DESIGN FUNCTIONS
    /**
     Load outlet customizations.
     */
    func loadOutletCustomizations() {
        // INVENTORY HEADER
        mainCurrencyView.layer.cornerRadius = 10
        mainCurrencyView.layer.borderColor = UIColor.black.cgColor
        mainCurrencyView.layer.borderWidth = 1
        
        premiumCurrencyView.layer.cornerRadius = 10
        premiumCurrencyView.layer.borderColor = UIColor.black.cgColor
        premiumCurrencyView.layer.borderWidth = 1
        
        // BUTTONS
        changeFactoryButton.layer.cornerRadius = 10
        moveToInventoryButton.layer.cornerRadius = 10
        changeFactoryButton.backgroundColor = UIColor(named: "actionColor1")
        moveToInventoryButton.backgroundColor = UIColor(named: "HudActions-background")
    }
    
    
    /**
     Load custom font to all labels and button text.
     */
    func loadCustomFont() {
        // LABELS
        upgradeHeader.font = UIFont(name: "AustralSlabBlur-Regular", size: 27)
        mainCurrencyLabel.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
        premiumCurrencyLabel.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
        
        // BUTTONS
        changeFactoryButton.titleLabel?.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
        moveToInventoryButton.titleLabel?.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
    }
    
    
    // MARK: - ACTIONS
    @IBAction func close(_ sender: Any) {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        self.dismiss(animated: false, completion: nil)
    }
    
    
    /**
     Move a active factory of the GameScene to the Inventory.
     */
    @IBAction func moveToInventory(_ sender: Any) {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        if let factory = UpgradeFactorySceneController.generator {
            let position = factory.position
            factory.position = .none
            factory.isActive = .no
            self.dismiss(animated: false, completion: nil)
            DispatchQueue.global().async {
                CKRepository.editGenerators(userID: GameScene.user!.id, generators: GameScene.user!.generators) { record, error in
                    
                    if error == nil {
                        DispatchQueue.main.async {
                            GameViewController.scene!.removeFactory(position: position)
                        }
                    } else {
                        factory.position = position
                        factory.isActive = .yes
                    }
                }
            }
        }
    }
    
    // MARK: - LOAD DATA
    /**
     Load player actual currencies value.
     */
    @objc func loadPlayerCurrencies() {
        mainCurrencyLabel.text = doubleToString(value: GameScene.user?.mainCurrency ?? 0.0)
        premiumCurrencyLabel.text = doubleToString(value: GameScene.user?.premiumCurrency ?? 0.0)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let factory = UpgradeFactorySceneController.generator {
            return factory.resourcesArray.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpgradeCell", for: indexPath) as! UpgradeCell
        if let factory = UpgradeFactorySceneController.generator {
            let resource = factory.resourcesArray[indexPath.row]
            cell.qtdPerSec.text = "\(doubleToStringAsInt(value: resource.perSec))/s"
            cell.resourceImage.image = UIImage(systemName: getResourceImageName(resource: resource.type))
            // TODO: Change upgrade cost
            cell.setFactory(factory: factory, resourceID: indexPath.row)
            cell.tableView = tableView
            cell.upgradeCostLabel.text = "\(doubleToString(value: (resource.currentPrice)))"
            let qtd = (resource.qttPLevel * Double(resource.currentLevel)) + resource.baseQtt
            cell.resourceNameAndQtdPerSec.text = "\(doubleToString(value: qtd)) \(resource.type.description)/s - \(NSLocalizedString("level", comment: "")): \(resource.currentLevel)"
        }

        return cell
    }



}

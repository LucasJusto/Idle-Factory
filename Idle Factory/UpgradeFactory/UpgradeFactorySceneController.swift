//
//  UpgradeFactorySceneController.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 26/10/21.
//

import UIKit
import SpriteKit

class UpgradeFactorySceneController: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBOutlet weak var SKView: SKView!
    @IBOutlet weak var changeFactoryButton: UIButton!
    @IBOutlet weak var moveToInventoryButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    static var generator: Factory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        changeFactoryButton.layer.cornerRadius = 10
        moveToInventoryButton.layer.cornerRadius = 10
        
        changeFactoryButton.setTitle(NSLocalizedString("ChangeFactory", comment: ""), for: UIControl.State.normal)
        moveToInventoryButton.setTitle(NSLocalizedString("MoveToInventory", comment: ""), for: UIControl.State.normal)
        
        changeFactoryButton.titleLabel?.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
        moveToInventoryButton.titleLabel?.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
        
        changeFactoryButton.backgroundColor = UIColor(named: "actionColor1")
        moveToInventoryButton.backgroundColor = UIColor(named: "HudActions-background")
        
        //self.view.layoutIfNeeded()
        // Do any additional setup after loading the view.
        let scene = FactoryScene(size: CGSize(width: 400, height: 400))
        scene.thisFactory = UpgradeFactorySceneController.generator
        scene.scaleMode = .aspectFill
        SKView.presentScene(scene)
    }
    
    
    /**
     Move a active factory of the GameScene to the Inventory.
     */
    @IBAction func moveToInventory(_ sender: Any) {
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
            cell.upgradeCostLabel.text = "\(doubleToStringAsInt(value: (resource.currentPrice)))"
            let qtd = (resource.qttPLevel * Double(resource.currentLevel)) + resource.baseQtt
            cell.resourceNameAndQtdPerSec.text = "\(doubleToString(value: qtd)) \(resource.type.description)/s - \(NSLocalizedString("level", comment: "")): \(resource.currentLevel)"
        }

        return cell
    }



}

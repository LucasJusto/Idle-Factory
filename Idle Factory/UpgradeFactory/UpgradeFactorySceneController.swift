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
    
    var generatorID: Int = 0
    
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
        
        changeFactoryButton.backgroundColor = UIColor(named: "Inventory_background")
        moveToInventoryButton.backgroundColor = UIColor(named: "HudActions-background")
        
        //self.view.layoutIfNeeded()
        // Do any additional setup after loading the view.
        let scene = FactoryScene(size: CGSize(width: 400, height: 400))
        scene.scaleMode = .aspectFill
        SKView.presentScene(scene)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameScene.user?.generators[generatorID].resourcesArray.count ?? 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpgradeCell", for: indexPath) as! UpgradeCell
        if let resource =  GameScene.user?.generators[generatorID].resourcesArray[indexPath.row] {
            cell.qtdPerSec.text = "\(doubleToString(value: resource.perSec))/s"
            cell.resourceImage.image = UIImage(named: getResourceImageName(resource: resource.type))
            // TODO: Change upgrade cost
            cell.upgradeCostLabel.text = "\(doubleToString(value: resource.basePrice))"
            let qtd = (resource.qttPLevel * Double(resource.currentLevel)) + resource.baseQtt
            cell.resourceNameAndQtdPerSec.text = "\(doubleToString(value: qtd)) \(resource.type.description)/s"
        }
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

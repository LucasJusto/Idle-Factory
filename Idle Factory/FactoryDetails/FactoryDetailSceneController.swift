//
//  UpgradeFactorySceneController.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 26/10/21.
//

import UIKit

class FactoryDetailSceneController: UIViewController,  UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var view2: UIView!
    
    var generatorID: Int = 0
    
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceImage: UIImageView!
    
    @IBOutlet weak var priceValue: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        cancelButton.layer.cornerRadius = 10
        purchaseButton.layer.cornerRadius = 10
        
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: UIControl.State.normal)
        purchaseButton.setTitle(NSLocalizedString("Purchase", comment: ""), for: UIControl.State.normal)
        
        cancelButton.titleLabel?.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
        purchaseButton.titleLabel?.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
        
        cancelButton.backgroundColor = UIColor.white
        purchaseButton.backgroundColor = UIColor(named: "Inventory_background")
        
        id.text = GameScene.user?.generators[generatorID].id
        var resourceArray: [Resource] = []
        var price = 0.0
        for n in 0..<(GameScene.user?.generators[generatorID].resourcesArray.count ?? 0) {
            resourceArray.append((GameScene.user?.generators[generatorID].resourcesArray[n])!)
            price += resourceArray[n].basePrice
        }
        
        priceLabel.text = "\(NSLocalizedString("Price", comment: "Price")) "
        //view2.layer.borderColor = CGColor()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameScene.user?.generators[generatorID].resourcesArray.count ?? 1;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FactoryDetailCell", for: indexPath) as! FactoryDetailCell
        if let resource =  GameScene.user?.generators[generatorID].resourcesArray[indexPath.row] {
            let qtd = (resource.qttPLevel * Double(resource.currentLevel)) + resource.baseQtt
            cell.name.text = "\(doubleToString(value: qtd)) \(resource.type.description)/s"
            cell.price.text = "\(doubleToString(value: resource.perSec))/s"
            cell.imageInCell.image = UIImage(named: getResourceImageName(resource: resource.type))
            
        }
        return cell
    }
    
  
    
//    @IBAction func close(_ sender: Any) {
//        self.dismiss(animated: false, completion: nil)
//    }
    
    
   
}

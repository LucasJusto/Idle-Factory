//
//  UpgradeFactorySceneController.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 26/10/21.
//

import UIKit

class FactoryDetailSceneController: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var view2: UIView!
    
    static var generator: Factory? = nil
    static var offer: Offer? = nil
    static var isBlue: Bool = false
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
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
        tableView.backgroundColor = UIColor(named: FactoryDetailSceneController.isBlue ? "HudActions-background" : "Marketplace_background")
        
        
        if FactoryDetailSceneController.isBlue {
            mainView.backgroundColor = UIColor(named: "HudActions-background")
        }
        else {
            mainView.backgroundColor = UIColor(named: "Marketplace_background")
        }
        cancelButton.layer.cornerRadius = 10
        purchaseButton.layer.cornerRadius = 10
        
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: UIControl.State.normal)
        purchaseButton.setTitle(NSLocalizedString("Purchase", comment: ""), for: UIControl.State.normal)
        
        cancelButton.titleLabel?.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
        purchaseButton.titleLabel?.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
        
        cancelButton.backgroundColor = UIColor.white
        purchaseButton.backgroundColor = UIColor(named: "Inventory_background")
        if let generator = FactoryDetailSceneController.generator {
            id.text = "ID: \(generator.id ?? "")"
            var resourceArray: [Resource] = []
            var price = 0.0
            for n in 0..<(generator.resourcesArray.count) {
                resourceArray.append((generator.resourcesArray[n]))
                price += resourceArray[n].basePrice
            }
            
            priceLabel.text = "\(NSLocalizedString("Price", comment: "Price")) "
            priceLabel.backgroundColor = UIColor(named: FactoryDetailSceneController.isBlue ? "HudActions-background" : "Marketplace_background")
            priceValue.backgroundColor = UIColor(named: FactoryDetailSceneController.isBlue ? "HudActions-background" : "Marketplace_background")
            if generator.type == .NFT {
                priceImage.image = UIImage(named: "Money_premium")
            }
            else {
                priceImage.image = UIImage(named: "Coin")
            }
#warning("Trocar por valor da Offer")
            priceValue.text = "1000"
        }
        view2.layer.borderWidth = 1
        view2.layer.cornerRadius = 15
        view2.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let generator = FactoryDetailSceneController.generator {
            return generator.resourcesArray.count;
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FactoryDetailCell", for: indexPath) as! FactoryDetailCell
        if let generator = FactoryDetailSceneController.generator {
            let resource =  generator.resourcesArray[indexPath.row]
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

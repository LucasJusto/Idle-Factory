//
//  UpgradeCell.swift
//  Idle Factory
//
//  Created by Felipe Grosze Nipper de Oliveira on 27/10/21.
//

import UIKit

class UpgradeCell: UITableViewCell {
    
    @IBOutlet weak var resourceImage: UIImageView!
    @IBOutlet weak var upgradeCostLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var qtdPerSec: UILabel!
    @IBOutlet weak var resourceNameAndQtdPerSec: UILabel!
    @IBAction func UpgradeAction(_ sender: Any) {
        GameSound.shared.playSoundFXIfActivated(sound: .UPGRADE)

        var value = (generator?.resourcesArray[thisResourceID].currentPrice ?? 0) * (generator?.resourcesArray[thisResourceID].pricePLevelIncreaseTax ?? 0)
       
        if(value <= GameScene.user!.mainCurrency) {
            
            GameScene.user?.removeMainCurrency(value: value)
            generator?.upgrade(index: thisResourceID)
            tableView?.reloadData()
        }
        value = (generator?.resourcesArray[thisResourceID].currentPrice ?? 0) * (generator?.resourcesArray[thisResourceID].pricePLevelIncreaseTax ?? 0)
        upgradeCostLabel.text = "\(doubleToString(value: value))"
    }
    
    
    var generator: Factory? = nil
    var thisResourceID: Int = 0
    var tableView: UITableView? = nil
    func setFactory(factory: Factory, resourceID: Int){
        thisResourceID = resourceID
        generator = factory
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
        button.titleLabel?.textColor = UIColor.black
        button.backgroundColor = UIColor(named: "actionColor1")
    }
}

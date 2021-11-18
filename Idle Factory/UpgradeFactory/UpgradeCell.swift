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
    @IBOutlet weak var button: UIButton! {
        didSet {
            button.backgroundColor = (value <= GameScene.user!.mainCurrency) ? UIColor(named:"actionColor1")! : UIColor(named:"deactivatedActionColor1")!
        }
    }
    @IBOutlet weak var qtdPerSec: UILabel!
    @IBOutlet weak var resourceNameAndQtdPerSec: UILabel!
    
    private(set) var timeToRefreshCurrency: Timer?

    var value: Double = 0 {
        didSet {
            button.backgroundColor = (value <= GameScene.user!.mainCurrency) ? UIColor(named:"actionColor1")! : UIColor(named:"deactivatedActionColor1")!
        }
    }
    
    @IBAction func UpgradeAction(_ sender: Any) {
        value = (generator?.resourcesArray[thisResourceID].currentPrice ?? 0)
        
        if(value <= GameScene.user!.mainCurrency) {
            GameSound.shared.playSoundFXIfActivated(sound: .UPGRADE)
            GameScene.user?.removeMainCurrency(value: value)
            generator?.upgrade(index: thisResourceID)
            tableView?.reloadData()
        } else {
            GameSound.shared.playSoundFXIfActivated(sound: .DEACTIVATE_BUTTON)
        }
        value = (generator?.resourcesArray[thisResourceID].currentPrice ?? 0)
        upgradeCostLabel.text = "\(doubleToString(value: value))"
    }
    
    
    var generator: Factory? = nil
    var thisResourceID: Int = 0
    var tableView: UITableView? = nil
    func setFactory(factory: Factory, resourceID: Int){
        thisResourceID = resourceID
        generator = factory
        value = factory.resourcesArray[resourceID].currentPrice
        upgradeCostLabel.text = "\(doubleToString(value: value))"

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
        button.titleLabel?.textColor = UIColor.black
        timeToRefreshCurrency = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(loadPlayerCurrencies), userInfo: nil, repeats: true)
    }
    
    @objc func loadPlayerCurrencies () {
        if GameScene.user!.mainCurrency >= value {
            button.backgroundColor = UIColor(named:"actionColor1")
        } else {
            button.backgroundColor = UIColor(named:"deactivatedActionColor1")!

        }
    }
}

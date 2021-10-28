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
        print(#function)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
        button.titleLabel?.textColor = UIColor.black
        button.backgroundColor = UIColor(named: "Inventory_background")
    }
}

//
//  FactoryDetailCell.swift
//  Idle Factory
//
//  Created by Felipe Grosze Nipper de Oliveira on 03/11/21.
//

import UIKit

class FactoryDetailCell: UITableViewCell {
    
    
    @IBOutlet weak var imageInCell: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(named: FactoryDetailSceneController.isBlue ? "HudActions-background" : "Marketplace_background")
    }
}

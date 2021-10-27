//
//  GameInventoryViewCell.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 26/10/21.
//

import UIKit

class GameInventoryViewCell: UICollectionViewCell {
    
    @IBOutlet weak var factoryTexture: UIImageView!
    @IBOutlet weak var factoryId: UILabel!
    
    func pullFactoryData(texture: String, id: String, resources: [Resource]) {
        factoryTexture.image = UIImage(named: texture)
        factoryId.numberOfLines = 0
        factoryId.translatesAutoresizingMaskIntoConstraints = false
        factoryId.lineBreakMode = .byWordWrapping
        factoryId.text = "20"
        
    }
}

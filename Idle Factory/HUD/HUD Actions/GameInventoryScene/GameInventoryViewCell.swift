//
//  GameInventoryViewCell.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 26/10/21.
//

import UIKit

class GameInventoryViewCell: UICollectionViewCell {
    
    @IBOutlet weak var factoryTexture: UIButton!
    @IBOutlet weak var factoryId: UILabel!
    
    func pullFactoryData(texture: String, id: String) {
        factoryTexture.setImage(UIImage(named: texture), for: .normal)
        factoryId.numberOfLines = 0
        factoryId.translatesAutoresizingMaskIntoConstraints = false
        factoryId.lineBreakMode = .byWordWrapping
        factoryId.text = id
    }
}

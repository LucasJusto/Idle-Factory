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
    
    
    /**
     Pull factory data for each cell. Receives a texture of the Factory.
     */
    func pullFactoryData(texture: String, resources: [Resource]) {
        factoryTexture.image = UIImage(named: texture)

        
    }
}

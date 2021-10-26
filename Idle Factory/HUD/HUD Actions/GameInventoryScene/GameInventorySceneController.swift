//
//  GameInventorySceneController.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 21/10/21.
//

import UIKit

class GameInventorySceneController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    static let factoryID: String = "factory_cell"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }

}


extension GameInventorySceneController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let generatorsSize = (GameScene.user?.generators.count)!
        
        if indexPath.row >= generatorsSize {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.factoryID, for: indexPath) as! GameInventoryViewCell
            cell.pullFactoryData(texture: "Button-inventory", id:"abcde")
            return cell
        } else {
            let playerGenerator = GameScene.user?.generators[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.factoryID, for: indexPath) as! GameInventoryViewCell
            cell.pullFactoryData(texture: playerGenerator!.textureName, id: playerGenerator!.id!)
        
            return cell
        }
    }
}

extension GameInventorySceneController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: 91, height: 91)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 24, left: 5, bottom: 12, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.41
    }
    
}


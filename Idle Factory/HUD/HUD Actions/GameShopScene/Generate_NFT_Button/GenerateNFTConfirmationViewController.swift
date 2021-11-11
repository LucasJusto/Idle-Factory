//
//  GenerateNFTConfirmationViewController.swift
//  Idle Factory
//
//  Created by João Gabriel Biazus de Quevedo on 10/11/21.
//

import UIKit

class GenerateNFTConfirmationViewController: UIViewController {

    @IBOutlet weak var backgroung: UIView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroung.layer.cornerRadius = 16
        backgroung.backgroundColor = .white
        
        firstLabel.text = NSLocalizedString("firstLabel", comment: "")
        firstLabel.font = UIFont(name: "AustralSlabBlur-Regular", size: 28)
        
        moneyLabel.text = doubleToString(value: 25)
        moneyLabel.font = UIFont(name: "AustralSlabBlur-Regular", size: 17)
        
        warningLabel.text = NSLocalizedString("warningLabel", comment: "")
        warningLabel.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
        
        cancelButton.layer.cornerRadius = 10.5
        cancelButton.setTitle(NSLocalizedString("cancelButton", comment: ""), for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "AustralSlabBlur-Regular", size: 13)
        
        confirmButton.layer.cornerRadius = 10.5
        confirmButton.setTitle(NSLocalizedString("confirmButton", comment: ""), for: .normal)
        confirmButton.titleLabel?.font = UIFont(name: "AustralSlabBlur-Regular", size: 13)
        
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func confirmAction(_ sender: Any) {
        
        let resourceArray: [ResourceType] = [ResourceType.headphone, ResourceType.smartTV, ResourceType.smartphone, ResourceType.tablet, ResourceType.computer]
        
        let nftFactories = createNFTFactory(resourceTypeArray: resourceArray)
        
        DispatchQueue.global().async {
            if(GameScene.user!.premiumCurrency >= 50){
                CKRepository.storeNewGenerator(userID: GameScene.user!.id, generator: nftFactories){ record ,error  in
                    if error == nil && record != nil {
                        let semaphore = DispatchSemaphore(value: 0)
                        nftFactories.id = record[0]!.recordID.recordName
                        for r in nftFactories.resourcesArray {
                            for r2 in record {
                                let type = r2?.value(forKey: ResourceTable.type.description) as? String ?? ""
                                let id = r2?.recordID.recordName
                                if r.type.key == type {
                                    r.id = id
                                }
                            }
                        }
                        
                        GameScene.user?.generators.append(nftFactories)
                        GameScene.user?.removePremiumCurrency(value: 50)
                        CKRepository.storeUserData(id: GameScene.user!.id , name:  GameScene.user?.name ?? "", mainCurrency:  GameScene.user!.mainCurrency , premiumCurrency:  GameScene.user!.premiumCurrency, timeLeftApp: AppDelegate.gameSave.transformToSeconds(time: AppDelegate.gameSave.getCurrentTime()) , completion: {_,_ in
                            semaphore.signal()
                        })
                        semaphore.wait()
                        
                        DispatchQueue.main.async {
                            var mainView: UIStoryboard!
                            mainView = UIStoryboard(name: "GameShopScene", bundle: nil)
                            let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "ShopStoryboard") as UIViewController
                            self.present(viewcontroller, animated: false)
                        }
                    }
                }
            }
        }
    }
    
}

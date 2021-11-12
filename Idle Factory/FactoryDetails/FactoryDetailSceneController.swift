//
//  UpgradeFactorySceneController.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 26/10/21.
//

import UIKit
import SpriteKit

class FactoryDetailSceneController: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var premiumCurrencyLabel: UILabel!
    
    @IBOutlet weak var HeaderViewPreminumCurrency: UIView!
    @IBOutlet weak var headerViewMainCurrency: UIView!
    @IBOutlet weak var mainCurrencyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceStack: UIStackView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var SKview: SKView!
    static var generator: Factory? = nil
    static var offer: Offer? = nil
    static var isBlue: Bool = false
    static var thiscolor = "HudActions-background"
    
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
    
    @IBAction func BackAction(_ sender: Any) {
        if FactoryDetailSceneController.isBlue {
            var mainView: UIStoryboard!
            mainView = UIStoryboard(name: "GameShopScene", bundle: nil)
            let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "ShopStoryboard") as UIViewController
            self.present(viewcontroller, animated: false)
        }
        else {
            let mainView = UIStoryboard(name: "GameMarketplaceScene", bundle: nil)
            let viewcontroller : GameMarketplaceSceneController = mainView.instantiateViewController(withIdentifier: "MarketplaceStoryboard") as! GameMarketplaceSceneController
            self.present(viewcontroller, animated: false)
        }
    }
    
    @IBAction func buyAction(_ sender: Any) {
        if FactoryDetailSceneController.isBlue {
            if let generator = FactoryDetailSceneController.generator {
                var resourceArray: [Resource] = []
                var price = 0.0
                for n in 0..<(generator.resourcesArray.count) {
                    resourceArray.append((generator.resourcesArray[n]))
                    price += resourceArray[n].basePrice
                }
                self.dismiss(animated: false, completion: nil)
                DispatchQueue.global().async {
                    if(GameScene.user!.mainCurrency >= price){
                        CKRepository.storeNewGenerator(userID: GameScene.user!.id, generator: generator){ record ,error  in
                            if error == nil && record != nil {
                                let semaphore = DispatchSemaphore(value: 0)
                                generator.id = record[0]!.recordID.recordName
                                for r in generator.resourcesArray {
                                    for r2 in record {
                                        let type = r2?.value(forKey: ResourceTable.type.description) as? String ?? ""
                                        let id = r2?.recordID.recordName
                                        if r.type.key == type {
                                            r.id = id
                                        }
                                    }
                                }
                                
                                GameScene.user?.generators.append(generator)
                                GameScene.user?.removeMainCurrency(value: price)
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
    }
    override func viewDidLoad() {
        headerViewMainCurrency.layer.cornerRadius = 10
        HeaderViewPreminumCurrency.layer.cornerRadius = 10
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        if !FactoryDetailSceneController.isBlue {
            nameLabel.text = NSLocalizedString("MarketplaceHeaderLabel", comment: "")
        }
        else {
            nameLabel.text = NSLocalizedString("ShopHeaderLabel", comment: "")
        }
        
        mainCurrencyLabel.text = "\(doubleToString(value: GameScene.user!.mainCurrency))"
        premiumCurrencyLabel.text = "\(doubleToString(value: GameScene.user!.premiumCurrency))"
        
        priceStack.backgroundColor =  UIColor(named: FactoryDetailSceneController.isBlue ? "HudActions-background" : "Marketplace_background")
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
        purchaseButton.backgroundColor = UIColor(named: "actionColor1")
        if let generator = FactoryDetailSceneController.generator {
            if let id = generator.id {
                self.id.text = "ID: \(id)"
            }
            else {
                id.text = ""
            }
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
            if !FactoryDetailSceneController.isBlue {
                priceValue.text = "\(doubleToString(value: FactoryDetailSceneController.offer!.price))"
            }
            else {
                priceValue.text = "\(doubleToString(value: price))"
            }
        }
        view2.layer.borderWidth = 1
        view2.layer.cornerRadius = 15
        view2.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        let scene = FactoryScene(size: CGSize(width: 500, height: 500))
        if FactoryDetailSceneController.isBlue {
            FactoryDetailSceneController.thiscolor = "HudActions-background"
            scene.thisYPosition = 65
            
        }
        else {
            FactoryDetailSceneController.thiscolor = "Marketplace_background"
            if FactoryDetailSceneController.generator?.type == .NFT {
                scene.thisYPosition = 25
            }
            else {
                scene.thisYPosition = 65
            }
        }
        scene.thiscolor = FactoryDetailSceneController.thiscolor
        //scene.isSmall = true
        scene.thisFactory = FactoryDetailSceneController.generator
        scene.scaleMode = .aspectFill
        SKview.presentScene(scene)
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


extension UIStackView {
    private func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.tag = -1
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
    
    func setBackgroundColor(color: UIColor) {
        if #available(iOS 14, *) {
            backgroundColor = color
        } else {
            guard let backgroundView = viewWithTag(-1) else {
                addBackground(color: color)
                return
            }
            backgroundView.backgroundColor = color
        }
    }
}

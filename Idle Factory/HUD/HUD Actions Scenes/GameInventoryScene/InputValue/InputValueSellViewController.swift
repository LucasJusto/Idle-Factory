//
//  InfoViewController.swift
//  Idle Factory
//
//  Created by Marcelo Diefenbach on 05/11/21.
//

import UIKit

class InputValueSellViewController: UIViewController, ComeBackData, ConfirmSell{
    
    var factory: Factory?
    var typeOfMoney: CurrencyType = .basic
    var valueSell: Double = 0
    
    func confirmSell() {
        CKRepository.getUserId { id in
            if let id = id {
                if let generatorID = self.factory?.id {
                    CKRepository.storeMarketPlaceOffer(sellerID: id, generatorID: generatorID, currencyType: self.typeOfMoney, price: self.valueSell, completion: { savedRecord, error in
                        if error == nil {
                            var index = 0
                            for i in 0..<GameScene.user!.generators.count {
                                if GameScene.user!.generators[i].id == self.factory?.id {
                                    index = i
                                    break
                                }
                            }
                            GameScene.user!.generators.remove(at: index)
                        }
                    })
                }
            }
        }
        self.dismiss(animated: false, completion: nil)
        self.dismiss(animated: false, completion: nil)

    }
    

    func comeValueInputed(type: Double) {
        valueSell = type
        setValueOnLabel(text: doubleToString(value: valueSell))
    }
    
    @IBOutlet weak var typeOfMoneyImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet var buttons: [UIButton]!
    
    // MARK: - BUTTONS THAT ADD VALUE
    @IBAction func button1(_ sender: Any) {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        valueSell = 0.0
        setValueOnLabel(text: doubleToString(value: valueSell))
    }
    @IBAction func button2(_ sender: Any) {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        valueSell += 100
        setValueOnLabel(text: doubleToString(value: valueSell))
        
    }
    @IBAction func button3(_ sender: Any) {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        valueSell += 1000
        setValueOnLabel(text: doubleToString(value: valueSell))
        
    }
    @IBAction func button4(_ sender: Any) {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        valueSell += 10000
        setValueOnLabel(text: doubleToString(value: valueSell))
        
    }
    @IBAction func button5(_ sender: Any) {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        valueSell += 100000
        setValueOnLabel(text: doubleToString(value: valueSell))
        
    }
    @IBAction func button6(_ sender: Any) {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        valueSell += 1000000
        setValueOnLabel(text: doubleToString(value: valueSell))
        
    }
    @IBAction func button7(_ sender: Any) {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        valueSell += 1000000000
        setValueOnLabel(text: doubleToString(value: valueSell))
        
    }
    @IBAction func button8(_ sender: Any) {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        valueSell += 1000000000000
        setValueOnLabel(text: doubleToString(value: valueSell))
        
    }
    @IBAction func button9(_ sender: Any) {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        valueSell += 1000000000000000
        setValueOnLabel(text: doubleToString(value: valueSell))
        
    }
    @IBAction func button10(_ sender: Any) {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        valueSell += 1000000000000000000
        setValueOnLabel(text: doubleToString(value: valueSell))
        
    }
    @IBAction func editValueWithKeyboard(_ sender: Any) {
        if let infoViewController = storyboard?.instantiateViewController(identifier: "HowMuch") as? InputValueKeyboardViewController {
            infoViewController.modalPresentationStyle = .overCurrentContext
            infoViewController.delegate = self
            infoViewController.modalTransitionStyle = .crossDissolve
            present(infoViewController, animated: true)
        }
    }
    
    @IBAction func closeScreen(_ sender: Any) {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func cancelButton(_ sender: Any) {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func confirmButton(_ sender: Any) {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        if let infoViewController = storyboard?.instantiateViewController(identifier: "ConfirmSell") as? ConfirmSellViewController {
            infoViewController.modalPresentationStyle = .overCurrentContext
            infoViewController.delegate = self
            infoViewController.value = valueSell
            infoViewController.typeOfMoney = typeOfMoney
            infoViewController.modalTransitionStyle = .crossDissolve
            present(infoViewController, animated: true)
        }
    }
    
    
    // MARK: - SELECTOR TYPE OF MONEY
    @IBOutlet weak var valueSellLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupButtons()
        setValueOnLabel(text: "0.0")
        
        titleLabel.text = NSLocalizedString("TitleInputValueSell", comment: "")

        // MARK: - Configs
        backgroundView.layer.cornerRadius = 15
        
        if factory?.type == .NFT {
            typeOfMoney = .premium
            typeOfMoneyImage.image = UIImage(named: "Money_premium")
        } else if factory?.type == .Basic {
            typeOfMoney = .basic
            typeOfMoneyImage.image = UIImage(named: "Coin")
        }
    }
    
    func setValueOnLabel(text: String) {
        valueSellLabel.layer.cornerRadius = 10
        valueSellLabel.layer.backgroundColor = UIColor.systemGray6.cgColor
        valueSellLabel.layer.borderWidth = 1
        valueSellLabel.layer.borderColor = UIColor.lightGray.cgColor
        
        let font =  UIFont(name: "AustralSlabBlur-Regular", size: 10)!
        
        let fontAttribute = [NSAttributedString.Key.font: font]
        
        let title = text
        
        let attributedString = NSAttributedString(string: title, attributes: fontAttribute)
        
        valueSellLabel.setAttributedTitle(attributedString, for: .normal)
    }
    
    //MARK: - Blurred view to show another
    
    lazy var blurredView: UIView = {
        // 1. create container view
        let containerView = UIView()
        // 2. create custom blur view
        let blurEffect = UIBlurEffect(style: .light)
        let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.2)
        customBlurEffectView.frame = self.view.bounds
        // 3. create semi-transparent black view
        let dimmedView = UIView()
        dimmedView.backgroundColor = .black.withAlphaComponent(0.6)
        dimmedView.frame = self.view.bounds
        
        // 4. add both as subviews
        containerView.addSubview(customBlurEffectView)
        containerView.addSubview(dimmedView)
        return containerView
    }()
    
    func setupView() {
        view.addSubview(blurredView)
        view.sendSubviewToBack(blurredView)
    }
    
    func setupButtons() {
        for button in buttons {
            button.layer.cornerRadius = 10
            
            let font =  UIFont(name: "AustralSlabBlur-Regular", size: 10)!
            
            let fontAttribute = [NSAttributedString.Key.font: font]
            
            let title = textForButtonTag(tag: button.tag)
            
            let attributedString = NSAttributedString(string: title, attributes: fontAttribute)
            
            button.setAttributedTitle(attributedString, for: .normal)
        }
        
    }
    
    private func textForButtonTag(tag: Int) -> String {
        
        switch tag {
        case 0:
            return NSLocalizedString("ToZeroButton", comment: "")
        case 1:
            return "+ 100"
        case 2:
            return "+ 1.000"
        case 3:
            return "+ 10.000"
        case 4:
            return "+ 100.000"
        case 5:
            return "+ 1M"
        case 6:
            return  "+ 1B"
        case 7:
            return "+ 1T"
        case 8:
            return  "+ 1AA"
        case 9:
            return  "+ 1AB"
        case 10:
            return NSLocalizedString("CancelButton", comment: "")
        case 11:
            return NSLocalizedString("AnnounceConfirmButton", comment: "")
        default:
            fatalError("Invalid tag for button")
        }
        
    }

}

protocol ComeBackData: AnyObject {
    func comeValueInputed(type: Double)
}

protocol ConfirmSell: AnyObject {
    func confirmSell()
}

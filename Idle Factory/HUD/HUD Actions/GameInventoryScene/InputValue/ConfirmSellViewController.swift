//
//  ConfirmSellViewController.swift
//  Idle Factory
//
//  Created by Marcelo Diefenbach on 10/11/21.
//

import UIKit

class ConfirmSellViewController: UIViewController {

    weak var delegate: ConfirmSell?
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var valueSellLabel: UILabel!
    @IBOutlet weak var typeOfMoneyImage: UIImageView!
    
    @IBAction func confirmSellButton(_ sender: Any) {
        delegate?.confirmSell()
    }
    
    @IBAction func cancellButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    var value: Double?
    var typeOfMoney: CurrencyType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButton(text: NSLocalizedString("CancelButton", comment: ""), button: cancelButton)
        setButton(text: NSLocalizedString("ConfirmButton", comment: ""), button: confirmButton)
        headerLabel.text = NSLocalizedString("HeaderLabelConfirmSell", comment: "")
        subtitleLabel.text = NSLocalizedString("SubtitleLabelConfirmSell", comment: "")
        valueSellLabel.text = doubleToString(value: value ?? 0.0)
        
        if typeOfMoney?.key == "premium" {
            typeOfMoneyImage.image = UIImage(named: "Money_premium")
        } else if typeOfMoney?.key == "basic" {
            typeOfMoneyImage.image = UIImage(named: "Coin")
        }
        

        // Do any additional setup after loading the view.
    }

    func setButton(text: String, button: UIButton){
        button.layer.cornerRadius = 10
        
        let font =  UIFont(name: "AustralSlabBlur-Regular", size: 10)!
        
        let fontAttribute = [NSAttributedString.Key.font: font]
        
        let title = text
        
        let attributedString = NSAttributedString(string: title, attributes: fontAttribute)
        
        button.setAttributedTitle(attributedString, for: .normal)
    }

}

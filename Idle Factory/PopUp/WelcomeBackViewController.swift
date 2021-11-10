//
//  WelcomeBackViewController.swift
//  Idle Factory
//
//  Created by João Gabriel Biazus de Quevedo on 09/11/21.
//

import UIKit

class WelcomeBackViewController: UIViewController {

    static var gameSave: GameSave = GameSave()
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var youWonLabel: UILabel!
    @IBOutlet weak var totalMoneyLabel: UILabel!
    @IBOutlet weak var outOfTownLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        background.backgroundColor = .white
        background.layer.cornerRadius = 20
        
        youWonLabel.text = NSLocalizedString("YouWon", comment: "")
        youWonLabel.font = UIFont(name: "AustralSlabBlur-Regular", size: 28)
        
        totalMoneyLabel.text = doubleToString(value: calculateCurrencyAway())
        totalMoneyLabel.font = UIFont(name: "AustralSlabBlur-Regular", size: 17)
        
        outOfTownLabel.text = NSLocalizedString("OutOfTown", comment: "")
        outOfTownLabel.font = UIFont(name: "AustralSlabBlur-Regular", size: 20)
        
        okButton.setTitle(NSLocalizedString("ok", comment: ""), for: .normal)
        okButton.layer.cornerRadius = 10.5
        okButton.titleLabel?.font = UIFont(name: "AustralSlabBlur-Regular", size: 13)
    }
    @IBAction func closePopUp(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
}


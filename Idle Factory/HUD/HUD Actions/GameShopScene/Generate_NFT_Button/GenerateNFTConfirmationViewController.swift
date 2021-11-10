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
    }
    
}

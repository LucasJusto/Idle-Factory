//
//  ConfirmResetPersonalDataViewController.swift
//  Idle Factory
//
//  Created by Marcelo Diefenbach on 11/11/21.
//

import UIKit

class ConfirmResetPersonalDataViewController: UIViewController {

    weak var delegate: ResetPersonalData?
    
    @IBOutlet weak var confirmResetLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func confirmResetButton(_ sender: Any) {
        delegate?.resetPersonalData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmResetLabel.text = NSLocalizedString("confirmResetTitle", comment: "")
        
        setupButtons(button: cancelButton, text: NSLocalizedString("cancelButtonSettings", comment: ""))
        setupButtons(button: confirmButton, text: NSLocalizedString("confirmButtonSettings", comment: ""))

    }
    
   func setupButtons(button: UIButton, text: String) {
        
            button.layer.cornerRadius = 10
            
            let font =  UIFont(name: "AustralSlabBlur-Regular", size: 10)!
            
            let fontAttribute = [NSAttributedString.Key.font: font]
            
            let title = text
            
            let attributedString = NSAttributedString(string: title, attributes: fontAttribute)
            
            button.setAttributedTitle(attributedString, for: .normal)
        
    }
}

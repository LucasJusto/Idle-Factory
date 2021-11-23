//
//  InputValueKeyboardViewController.swift
//  Idle Factory
//
//  Created by Marcelo Diefenbach on 08/11/21.
//

import UIKit

class InputValueKeyboardViewController: UIViewController {
 
    @IBOutlet weak var inputField: UITextField!
    weak var delegate: ComeBackData?

    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var buttonDone: UIButton!
    @IBAction func confirmButton(_ sender: Any) {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        Haptics.shared.activateHaptics(sound: .sucess)
        guard let validText = inputField.text else {return}
        
        if let x = Double(validText) {
            delegate?.comeValueInputed(type: x)
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    var value: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonDone.layer.cornerRadius = 10
        
        let font =  UIFont(name: "AustralSlabBlur-Regular", size: 10)!
        
        let fontAttribute = [NSAttributedString.Key.font: font]
        
        let title = NSLocalizedString("DoneButton", comment: "")
        
        let attributedString = NSAttributedString(string: title, attributes: fontAttribute)
        
        buttonDone.setAttributedTitle(attributedString, for: .normal)
        
        backgroundView.layer.cornerRadius = 10


    }
}

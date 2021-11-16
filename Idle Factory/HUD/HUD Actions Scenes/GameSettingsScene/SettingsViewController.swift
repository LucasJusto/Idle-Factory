//
//  SettingsViewController.swift
//  Idle Factory
//
//  Created by Marcelo Diefenbach on 11/11/21.
//

import UIKit

class SettingsViewController: UIViewController, ResetPersonalData {
    
    func resetPersonalData() {
        //apagar dados e trocar para um nome aleatório
        self.dismiss(animated: false, completion: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var soundEffectsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameUserLabel: NSLayoutConstraint!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBAction func resetButton(_ sender: Any) {
        if let infoViewController = storyboard?.instantiateViewController(identifier: "ConfirmResetPersonalData") as? ConfirmResetPersonalDataViewController {
            infoViewController.modalPresentationStyle = .overCurrentContext
            infoViewController.delegate = self
            infoViewController.modalTransitionStyle = .crossDissolve
            present(infoViewController, animated: true)
        }
        
    }
    
    @IBAction func SoundEffectsSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("turn off SFX")
            
        case 1:
            print("turn on SFX")
            
        default:
            print("default")
        }
    }
    
    @IBAction func songSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("turn off the music")

        case 1:
            print("turn on the music")
            
        default:
            print("default")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons(button: resetButton, text: NSLocalizedString("resetButtonLabelText", comment: ""))
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

protocol ResetPersonalData: AnyObject {
    func resetPersonalData()
}

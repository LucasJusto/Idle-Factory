//
//  ConfirmResetPersonalDataViewController.swift
//  Idle Factory
//
//  Created by Marcelo Diefenbach on 11/11/21.
//

import UIKit

class ConfirmResetPersonalDataViewController: UIViewController {

    weak var delegate: ResetPersonalData?
    
    // MARK: - OUTLETS
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var confirmResetQuestionLabel: UILabel!
    @IBOutlet weak var cancelResetButton: UIButton!
    @IBOutlet weak var confirmResetButton: UIButton!
    

    // MARK: - INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadOutletCustomizations()
        loadCustomFont()
        
        confirmResetQuestionLabel.text = NSLocalizedString("ConfirmResetQuestionTitle", comment: "")
        cancelResetButton.setTitle(NSLocalizedString("CancelResetAction", comment: ""), for: .normal)
        confirmResetButton.setTitle(NSLocalizedString("ConfirmResetAction", comment: ""), for: .normal)
    }
    
    
    // MARK: - DESIGN FUNCTIONS
    func loadOutletCustomizations() {
        backgroundView.layer.cornerRadius = 10
        cancelResetButton.layer.cornerRadius = 10
        confirmResetButton.layer.cornerRadius = 10
    }
    
    
    /**
     Load custom font to all labels and button text.
     */
    func loadCustomFont() {
        // LABELS
        confirmResetQuestionLabel.font = UIFont(name: "AustralSlabBlur-Regular", size: 27)
        
        // BUTTONS
        cancelResetButton.titleLabel?.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
        confirmResetButton.titleLabel?.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
    }
    
    
    // MARK: - ACTIONS
    /**
     Cancel reset action.
     */
    @IBAction func cancelReset(_ sender: Any) {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        Haptics.shared.activateHaptics(sound: .sucess)
        self.dismiss(animated: false, completion: nil)
    }
    
    
    /**
     Confirm reset data.
     */
    @IBAction func confirmReset(_ sender: Any) {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        Haptics.shared.activateHaptics(sound: .sucess)
        delegate?.resetPersonalData()
    }
}

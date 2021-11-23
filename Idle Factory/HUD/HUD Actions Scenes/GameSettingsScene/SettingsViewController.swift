//
//  SettingsViewController.swift
//  Idle Factory
//
//  Created by Marcelo Diefenbach on 11/11/21.
//

import UIKit

class SettingsViewController: UIViewController, ResetPersonalData {
    
    // MARK: - OUTLETS
    @IBOutlet weak var settingsHeader: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var soundEffectsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var hapticslabel: UILabel!
    
    // MARK: - SEGMENTED CONTROL
    @IBOutlet weak var songSegmentedControl: UISegmentedControl!
    @IBOutlet weak var soundFXSegmentedControl: UISegmentedControl!
    @IBOutlet weak var hapticsSegmentedControl: UISegmentedControl!
    
    
    // MARK: - INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadOutletCustomizations()
        loadCustomFont()
        
        if GameSound.shared.backgroundMusicStatus {
            songSegmentedControl.selectedSegmentIndex = 1
        } else {
            songSegmentedControl.selectedSegmentIndex = 0
        }
        
        if GameSound.shared.soundFXStatus {
            soundFXSegmentedControl.selectedSegmentIndex = 1
        } else {
            soundFXSegmentedControl.selectedSegmentIndex = 0
        }
        
        if Haptics.shared.hapticStatus {
            hapticsSegmentedControl.selectedSegmentIndex = 1
        } else {
            hapticsSegmentedControl.selectedSegmentIndex = 0
        }
        
        // Setting Header
        settingsHeader.text = NSLocalizedString("SettingHeader", comment: "")
        
        // Settings options
        songLabel.text = NSLocalizedString("SongLabel", comment: "")
        soundEffectsLabel.text = NSLocalizedString("SoundEffectsLabel", comment: "")
        nameLabel.text = NSLocalizedString("NameLabel", comment: "")
        resetButton.setTitle(NSLocalizedString("ResetPersonalDataLabel", comment: ""), for: .normal)
        hapticslabel.text = NSLocalizedString("HapticsLabel", comment: "")
    }
    
    
    // MARK: - DESIGN FUNCTIONS
    func loadOutletCustomizations() {
        resetButton.layer.cornerRadius = 10
    }
    
    
    /**
     Load custom font to all labels and button text.
     */
    func loadCustomFont() {
        // LABELS
        songLabel.font = UIFont(name: "AustralSlabBlur-Regular", size: 24)
        soundEffectsLabel.font = UIFont(name: "AustralSlabBlur-Regular", size: 24)
        nameLabel.font = UIFont(name: "AustralSlabBlur-Regular", size: 24)
        
        // BUTTONS
        resetButton.titleLabel?.font = UIFont(name: "AustralSlabBlur-Regular", size: 10)
    }
    
    
    // MARK: - ACTIONS
    /**
     Close Inventory scene.
     */
    @IBAction func closeSettings(_ sender: Any) {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        Haptics.shared.activateHaptics(sound: .sucess)
        self.dismiss(animated: false, completion: nil)
    }
    
    
    /**
     Turn on / off the game background music.
     */
    @IBAction func songSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            GameSound.shared.stopBackgroundMusic()
            GameSound.shared.saveBackgroundMusicSettings(status: false)
        case 1:
            GameSound.shared.startBackgroundMusic()
            GameSound.shared.saveBackgroundMusicSettings(status: true)
        default:
            break
        }
    }
    @IBAction func hapticSegmentedControlAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            Haptics.shared.activateHaptics(sound: .error)
            Haptics.shared.saveHapticsSettings(status: false)
        case 1:
            Haptics.shared.saveHapticsSettings(status: true)
        default:
            break
        }
    }
    
    
    /**
     Turn on / off the game sound effects.
     */
    @IBAction func SoundEffectsSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            GameSound.shared.playSoundFXIfActivated(sound: .DEACTIVATE_BUTTON)
            Haptics.shared.activateHaptics(sound: .sucess)
            GameSound.shared.saveSoundFXSettings(status: false)
        case 1:
            GameSound.shared.saveSoundFXSettings(status: true)

        default:
            break
        }
    }
    
    
    /**
     Resets all personal informations allowed before by user.
     */
    @IBAction func resetPersonalInformation(_ sender: Any) {
        GameSound.shared.playSoundFXIfActivated(sound: .BUTTON_CLICK)
        Haptics.shared.activateHaptics(sound: .sucess)
        if let infoViewController = storyboard?.instantiateViewController(identifier: "ConfirmResetPersonalData") as? ConfirmResetPersonalDataViewController {
            infoViewController.modalPresentationStyle = .overCurrentContext
            infoViewController.delegate = self
            infoViewController.modalTransitionStyle = .crossDissolve
            present(infoViewController, animated: true)
        }
    }
    
    
    func resetPersonalData() {
        //apagar dados e trocar para um nome aleatório
        self.dismiss(animated: false, completion: nil)
        self.dismiss(animated: false, completion: nil)
    }
}


protocol ResetPersonalData: AnyObject {
    func resetPersonalData()
}

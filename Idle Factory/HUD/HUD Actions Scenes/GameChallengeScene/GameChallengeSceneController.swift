//
//  GameChallengeSceneController.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 21/10/21.
//

import UIKit

class GameChallengeSceneController: UIViewController {
    
    @IBOutlet weak var warning: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCustomFont()
        
        warning.text = NSLocalizedString("UnderConstructionLabel", comment: "")

    }
    
    
    // MARK: - DESIGN FUNCTIONS
    /**
     Load custom font to all labels and button text.
     */
    func loadCustomFont() {
        // LABELS
        warning.font = UIFont(name: "AustralSlabBlur-Regular", size: 27)
    }
    
    
    // MARK: - ACTIONS
    /**
     Close Challenge scene.
     */
    @IBAction func closeChallenge(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
}

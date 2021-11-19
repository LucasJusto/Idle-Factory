//
//  ThirdViewController.swift
//  Idle Factory
//
//  Created by Felipe Grosze Nipper de Oliveira on 16/11/21.
//

import UIKit

class ThirdViewController: UIViewController {
    

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBAction func startAction(_ sender: Any) {
        activityIndicator.isHidden = false
        startButton.isEnabled = false
        startButton.isHidden = true
        activityIndicator.startAnimating()
        DispatchQueue.global().async {
            CKRepository.refreshCurrentUser { user in
                if let userNotnull = user {
                    GameScene.user = userNotnull
                    userNotnull.addMainCurrency(value: 10000)
                    userNotnull.addPremiumCurrency(value: 150)
                    CKRepository.storeUserData(id: userNotnull.id, name: userNotnull.name, mainCurrency: userNotnull.mainCurrency, premiumCurrency: userNotnull.premiumCurrency, timeLeftApp: nil) { _, error in
                        guard error == nil
                        else {
                            return
                        }
                        OnboardingManager.shared.isFirstLaunch = true
                        DispatchQueue.main.async {
                            let storyboard = UIStoryboard(name: "Main", bundle: .main)
                            let viewcontroller = storyboard.instantiateInitialViewController()
                            (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = viewcontroller
                        }
                    }
                }
                else {
                    print("userNotFound")
                }
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var Label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        Label.text = NSLocalizedString("Onboarding3", comment: "")
        startButton.backgroundColor = UIColor(named: "actionColor1")
        startButton.layer.cornerRadius = 15
        startButton.setTitle(NSLocalizedString("startPlaying", comment: ""), for: .normal)
        activityIndicator.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

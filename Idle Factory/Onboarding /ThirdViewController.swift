//
//  ThirdViewController.swift
//  Idle Factory
//
//  Created by Felipe Grosze Nipper de Oliveira on 16/11/21.
//

import UIKit

class ThirdViewController: UIViewController {

    @IBAction func startAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var Label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        Label.text = NSLocalizedString("Onboarding2", comment: "")
        startButton.backgroundColor = UIColor(named: "actionColor1")
        startButton.layer.cornerRadius = 15
        startButton.setTitle(NSLocalizedString("startPlaying", comment: ""), for: .normal) 
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

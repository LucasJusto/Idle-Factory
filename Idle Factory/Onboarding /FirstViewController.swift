//
//  FirstViewController.swift
//  Idle Factory
//
//  Created by Felipe Grosze Nipper de Oliveira on 16/11/21.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var Label1: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Label1.text = NSLocalizedString("Onboarding1", comment: "")
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

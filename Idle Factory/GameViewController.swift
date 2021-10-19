import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var gifView: UIImageView!
    
    @IBOutlet weak var backgroundLoadingView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gifView.loadGif(asset: "Loader-transparent")
        CKRepository.getUserId { id in
            if let idNotNull = id {
                CKRepository.getUserById(id: idNotNull) { user in
                    if let userNotnull = user {
                        GameScene.user = userNotnull
                        DispatchQueue.main.async {
                            self.didLoadUser()
                        }
                    }
                }
            }
        }
    }
    
    
    func didLoadUser(){
        Thread.sleep(forTimeInterval: 2)
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            
            let screenSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            
            //semaphore.wait()
            //Thread.sleep(forTimeInterval: 5)
            view.isHidden = false
            let scene = GameScene(size: screenSize)
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill

            // Present the scene
            view.presentScene(scene)

            view.ignoresSiblingOrder = true

            view.showsFPS = true
            view.showsNodeCount = true
            gifView.isHidden = true
            backgroundLoadingView.isHidden = true
        }
    }
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

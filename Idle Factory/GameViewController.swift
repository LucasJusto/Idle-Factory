import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var gifView: UIImageView!
    
    @IBOutlet weak var backgroundLoadingView: UIImageView!
    
    static var notFirstTime: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundLoadingView.loadGif(asset: "fundo-faster")
    }
    
    
    func reload(gameSave: GameSave){
        gifView.isHidden = false
        backgroundLoadingView.isHidden = false
        CKRepository.getUserId { id in
            if let idNotNull = id {
                CKRepository.getUserById(id: idNotNull) { [self] user in
                    if let userNotnull = user {
                        GameScene.user = userNotnull
                        if let timeAway = gameSave.getTimeAway() {
                            print(timeAway)
                            DispatchQueue.main.async {
                                self.gifView.isHidden = true
                                self.backgroundLoadingView.isHidden = true
                                self.didLoadUser()
                            }
                            //GameScene.user?.addMainCurrency(value: 2 * timeAway)
                        }
        
        DispatchQueue.global().async {
            CKRepository.refreshCurrentUser { user in
                if let userNotnull = user {
                    GameScene.user = userNotnull
                    DispatchQueue.main.async {
                        self.didLoadUser()
                    }
                }
            }

        }
    }
    
    func didLoadUser(){
        if (!GameViewController.notFirstTime){
            Thread.sleep(forTimeInterval: 3)
            GameViewController.notFirstTime = true
            
        }
        else {
            Thread.sleep(forTimeInterval: 1.5)
        }
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

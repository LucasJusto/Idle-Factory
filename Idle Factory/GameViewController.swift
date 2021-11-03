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
        
        DispatchQueue.global().async {
            CKRepository.refreshCurrentUser { user in
                if let userNotnull = user {
                    GameScene.user = userNotnull
                    if let timeAway = gameSave.getTimeAway() {
                        if var generators = GameScene.user?.generators {
                            var perSecTotal: Double = 0.0
                            for n in 0..<generators.count {
                                if(generators[n].isActive == IsActive.yes){
                                    let perSec : Double = generators[n].getCurrencyPerSec()
                                    GameScene.user?.addMainCurrency(value: perSec * timeAway * 0.05)
                                    perSecTotal += perSec
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            self.gifView.isHidden = true
                            self.backgroundLoadingView.isHidden = true
                            self.didLoadUser()
                        }
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
    
    
    func displayUpgradeFactory() {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "UpgradeFactoryScene", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "UpgradeFactoryStoryboard") as UIViewController
        self.present(viewcontroller, animated: false)
    }
    
    
    // MARK: - HUD ACTION SCENES
    /**
     Calls GameInventory storyboard to display the actual players inventory.
     */
    func displayInventory() {
        
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "GameInventoryScene", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "InventoryStoryboard") as UIViewController
        self.present(viewcontroller, animated: false)
    }
    
    
    /**
     Calls GameMarkeplace storyboard to display the game Marketplace.
     */
    func displayMarketplace() {
        
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "GameMarketplaceScene", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "MarketplaceStoryboard") as UIViewController
        self.present(viewcontroller, animated: false)
    }
    
    
    /**
     Calls GameChallenge storyboard to display the Challenges.
     */
    func displayChallenge() {
        
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "GameChallengeScene", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "ChallengeStoryboard") as UIViewController
        self.present(viewcontroller, animated: false)
    }
    
}

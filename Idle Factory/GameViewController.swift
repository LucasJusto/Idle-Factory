import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var gifView: UIImageView!
    @IBOutlet weak var backgroundLoadingView: UIImageView!
    
    static var notFirstTime: Bool = false
    static var scene: GameScene?
    
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
                    GameScene.user?.addMainCurrency(value: calculateCurrencyAway())
                        DispatchQueue.main.async {
                            self.gifView.isHidden = true
                            self.backgroundLoadingView.isHidden = true
                            self.didLoadUser()
                        }
                }
                else {
                    print("userNotFound")
                }
            }
        }
    }
    
    func didLoadUser(){
        if (!GameViewController.notFirstTime){
            GameViewController.notFirstTime = true
        }

        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            
            let screenSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            
            //semaphore.wait()
            //Thread.sleep(forTimeInterval: 5)
            view.isHidden = false
            GameViewController.scene = GameScene(size: screenSize)
            // Set the scale mode to scale to fit the window
            GameViewController.scene?.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(GameViewController.scene)
            view.ignoresSiblingOrder = true
            
//            view.showsFPS = true
//            view.showsNodeCount = true
            gifView.isHidden = true
            backgroundLoadingView.isHidden = true
            
            if OnboardingManager.shared.isFirstLaunch, let user = GameScene.user {
                user.addMainCurrency(value: 10000)
                user.addPremiumCurrency(value: 150)
                CKRepository.storeUserData(id: user.id, name: user.name, mainCurrency: user.mainCurrency, premiumCurrency: user.premiumCurrency, timeLeftApp: nil) { _, _ in
                }
                var mainView: UIStoryboard!
                mainView = UIStoryboard(name: "OnboardingScene", bundle: nil)
                let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "welcome") as UIViewController
                self.present(viewcontroller, animated: false)
                GameSound.shared.saveBackgroundMusicSettings(status: true)
                GameSound.shared.startBackgroundMusic()
                GameSound.shared.saveSoundFXSettings(status: true)

                OnboardingManager.shared.isFirstLaunch = true
           } else {
               self.displayWelcomeBackPopUp()
           }
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
    
    
    func displayWelcomeBackPopUp() {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "WelcomeBack", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "WelcomeBackStoryBoard") as UIViewController
        self.present(viewcontroller, animated: false)
    }
    
    
    /**
     Calls GameInventory storyboard to select what generator player wants to insert on the scene (if contains).
     */
    func selectGeneratorToInsert(position: GeneratorPositions) {
        let mainView = UIStoryboard(name: "GameInventoryScene", bundle: nil)
        let viewcontroller : GameInventorySceneController = mainView.instantiateViewController(withIdentifier: "InventoryStoryboard") as! GameInventorySceneController
        viewcontroller.clickedSlotPosition = position
        self.present(viewcontroller, animated: false)
    }
    
    
    // MARK: - HUD ACTION SCENES
    /**
     Calls GameSettings storyboard to display the game settings.
     */
    func displaySettings() {
        
        let mainView = UIStoryboard(name: "Settings", bundle: nil)
        let viewcontroller : SettingsViewController = mainView.instantiateViewController(withIdentifier: "GameSettingsScene") as! SettingsViewController
        self.present(viewcontroller, animated: false)
    }
    
    
    /**
     Calls GameInventory storyboard to display the actual players inventory.
     */
    func displayInventory() {
        
        let mainView = UIStoryboard(name: "GameInventoryScene", bundle: nil)
        let viewcontroller : GameInventorySceneController = mainView.instantiateViewController(withIdentifier: "InventoryStoryboard") as! GameInventorySceneController
        self.present(viewcontroller, animated: false)
    }
    
    
    /**
     Calls GameShop storyboard to display the game shop.
     */
    func displayShop() {
        
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "GameShopScene", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "ShopStoryboard") as UIViewController
        self.present(viewcontroller, animated: false)
    }
    
    
    /**
     Calls GameMarkeplace storyboard to display the game Marketplace.
     */
    func displayMarketplace() {
        
        let mainView = UIStoryboard(name: "GameMarketplaceScene", bundle: nil)
        let viewcontroller : GameMarketplaceSceneController = mainView.instantiateViewController(withIdentifier: "MarketplaceStoryboard") as! GameMarketplaceSceneController
        self.present(viewcontroller, animated: false)
    }
    
    
    /**
     Calls GameChallenge storyboard to display the Challenges.
     */
    func displayChallenge() {
        
        let mainView = UIStoryboard(name: "GameChallengeScene", bundle: nil)
        let viewcontroller : GameChallengeSceneController = mainView.instantiateViewController(withIdentifier: "ChallengeStoryboard") as! GameChallengeSceneController
        self.present(viewcontroller, animated: false)
    }
    
}

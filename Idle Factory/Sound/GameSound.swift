//
//  GameSound.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 16/11/21.
//

import AVFoundation

enum SoundFX {
    case UPGRADE, BUTTON_CLICK, DEACTIVATE_BUTTON;
}

class GameSound {
    static let shared = GameSound()
    private(set) var backgroundMusicStatus = UserDefaults.standard.bool(forKey: "background-music")
    private(set) var soundFXStatus = UserDefaults.standard.bool(forKey: "sound-effects")
    private(set) var audioPlayer: AVAudioPlayer?

    
    /**
     Start playing backbround music.
     */
    func startBackgroundMusic() {
        if let bundle = Bundle.main.path(forResource: "bkg_music", ofType: "mp3") {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf:backgroundMusic as URL)
                guard let audioPlayer = audioPlayer else { return }
                audioPlayer.numberOfLoops = -1
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch {
                print(error)
            }
        }
    }
    
    
    /**
     Stop playing background music
     */
    func stopBackgroundMusic() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.stop()
    }
    
    
    /**
     Play a sound effect based on what is received as argument.
     */
    func playSoundFXIfActivated(sound: SoundFX) {
        if soundFXStatus {
            switch sound {
            case .UPGRADE:
                if let bundle = Bundle.main.path(forResource: "upgrade", ofType: "mp3") {
                    let upgradeSound = NSURL(fileURLWithPath: bundle)
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf:upgradeSound as URL)
                        guard let audioPlayer = audioPlayer else { return }
                        audioPlayer.numberOfLoops = 0
                        audioPlayer.prepareToPlay()
                        audioPlayer.play()
                    } catch {
                        print(error)
                    }
                }
            case .BUTTON_CLICK:
                if let bundle = Bundle.main.path(forResource: "clicked_button", ofType: "mp3") {
                    let clickButton = NSURL(fileURLWithPath: bundle)
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf:clickButton as URL)
                        guard let audioPlayer = audioPlayer else { return }
                        audioPlayer.numberOfLoops = 0
                        audioPlayer.prepareToPlay()
                        audioPlayer.play()
                    } catch {
                        print(error)
                    }
                }
            case .DEACTIVATE_BUTTON:
                if let bundle = Bundle.main.path(forResource: "deactivated_button", ofType: "mp3") {
                    let deactivateButton = NSURL(fileURLWithPath: bundle)
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf:deactivateButton as URL)
                        guard let audioPlayer = audioPlayer else { return }
                        audioPlayer.numberOfLoops = 0
                        audioPlayer.prepareToPlay()
                        audioPlayer.play()
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    
    /**
     Save background music settings status.
     */
    func saveBackgroundMusicSettings(status: Bool) {
        UserDefaults.standard.setValue(status, forKey: "background-music")
        backgroundMusicStatus = UserDefaults.standard.bool(forKey: "background-music")
    }
    
    
    /**
     Save sound effects settings status.
     */
    func saveSoundFXSettings(status: Bool) {
        UserDefaults.standard.setValue(status, forKey: "sound-effects")
        soundFXStatus = UserDefaults.standard.bool(forKey: "sound-effects")
    }
    
    
    func isPlaying() -> Bool {
        if let audioStatus = audioPlayer?.isPlaying {
            return audioStatus
        } else {
            return false
        }
    }
    
}

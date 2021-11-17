//
//  GameSound.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 16/11/21.
//

import AVFoundation

/**
 SoundFX. List of all sound effects of the game.
 */
enum SoundFX {
    case UPGRADE, BUTTON_CLICK, DEACTIVATE_BUTTON;
}


/**
 Class responsible to manage all the audio of the game.
 */
class GameSound {
    static let shared = GameSound()
    private(set) var backgroundMusicStatus = UserDefaults.standard.bool(forKey: "background-music")
    private(set) var soundFXStatus = UserDefaults.standard.bool(forKey: "sound-effects")
    private(set) var soundFXPlayer: AVAudioPlayer?
    private(set) var musicPlayer: AVAudioPlayer?

    
    // MARK: - BACKGROUND MUSIC
    /**
     Start playing backbround music.
     */
    func startBackgroundMusic() {
        if let bundle = Bundle.main.path(forResource: "bkg_music", ofType: "mp3") {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            do {
                musicPlayer = try AVAudioPlayer(contentsOf:backgroundMusic as URL)
                guard let audioPlayer = musicPlayer else { return }
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
        guard let audioPlayer = soundFXPlayer else { return }
        audioPlayer.stop()
    }
    
    
    // MARK: - SOUND FX
    /**
     Play a sound effect based on what is received as argument.
     */
    func playSoundFXIfActivated(sound: SoundFX) {
        if soundFXStatus {
            switch sound {
            case .UPGRADE:
                playFXAudio(filename: "upgrade")
            case .BUTTON_CLICK:
                playFXAudio(filename: "clicked_button")
            case .DEACTIVATE_BUTTON:
                playFXAudio(filename: "deactivated_button")
            }
        }
    }
    
    
    /**
     Play an Sound FX based on the filename received as argument.
     */
    func playFXAudio(filename: String) {
        if let bundle = Bundle.main.path(forResource: "\(filename)", ofType: "mp3") {
            let audio = NSURL(fileURLWithPath: bundle)
            do {
                soundFXPlayer = try AVAudioPlayer(contentsOf: audio as URL)
                guard let audioPlayer = soundFXPlayer else { return }
                audioPlayer.numberOfLoops = 0
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch {
                print(error)
            }
        }
    }
    
    
    // MARK: - SAVE SETTINGS
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
        if let audioStatus = soundFXPlayer?.isPlaying {
            return audioStatus
        } else {
            return false
        }
    }
}

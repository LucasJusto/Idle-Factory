//
//  GameSound.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 16/11/21.
//

import AVFoundation

class GameSound {
    static let shared = GameSound()
    var backgroundStatus = UserDefaults.standard.bool(forKey: "sound")
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
     Save background music settings status.
     */
    func saveBackgroundMusicSettings(status: Bool) {
        UserDefaults.standard.setValue(status, forKey: "sound")
        backgroundStatus = UserDefaults.standard.bool(forKey: "sound")
    }
    
    
    /**
     Save sound effects settings status.
     */
    func saveSoundEffectsSettings(status: Bool) {
        UserDefaults.standard.setValue(status, forKey: "sound-effects")
        backgroundStatus = UserDefaults.standard.bool(forKey: "sound-effects")
    }
    
    
    func isPlaying() -> Bool {
        if let audioStatus = audioPlayer?.isPlaying {
            return audioStatus
        } else {
            return false
        }
    }
    
}

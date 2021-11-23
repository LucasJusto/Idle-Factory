//
//  Haptic.swift
//  Idle Factory
//
//  Created by João Gabriel Biazus de Quevedo on 23/11/21.
//

import UIKit

enum HapticFeedbackCase {
    case sucess, error;
}

class Haptics {
    static let shared = Haptics()
    private(set) var hapticStatus = UserDefaults.standard.bool(forKey: "HapticsFeedback")
    
    
    func activateHaptics(sound: HapticFeedbackCase) {
        if hapticStatus {
            switch sound {
            case .sucess:
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            case .error:
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
            }
        }
    }
    
    func saveHapticsSettings(status: Bool) {
        UserDefaults.standard.setValue(status, forKey: "HapticsFeedback")
        hapticStatus = UserDefaults.standard.bool(forKey: "HapticsFeedback")
    }
}

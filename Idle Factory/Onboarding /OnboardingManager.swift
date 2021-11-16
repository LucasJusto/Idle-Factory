//
//  OnboardingManager.swift
//  Idle Factory
//
//  Created by Felipe Grosze Nipper de Oliveira on 16/11/21.
//
import Foundation

class OnboardingManager {
    static let shared = OnboardingManager()
    var isFirstLaunch: Bool {
        get {
            UserDefaults.standard.bool(forKey: #function)
        } set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
}

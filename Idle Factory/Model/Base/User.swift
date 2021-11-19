//
//  User.swift
//  Idle Factory
//
//  Created by Felipe Grosze Nipper de Oliveira on 14/10/21.
//

import Foundation

class User {
    
    private(set) var id: String
    private(set) var name: String
    private(set) var mainCurrency: Double
    private(set) var premiumCurrency: Double
    var timeLeftApp: Double
    
    var offers: [Offer] = []
    var generators: [Factory] = []
    /**
     TODO: Change the type of generators
     */
    init(id: String, name: String, mainCurrency: Double, premiumCurrency: Double, timeLeftApp: Double){
        self.id = id
        self.mainCurrency = mainCurrency
        self.premiumCurrency = premiumCurrency
        self.name = name
        self.timeLeftApp = timeLeftApp
    }
    
    /**
     Changes the name
     */
    func setName(newName: String){
        self.name = newName
    }
    /**
     Add a value to the current amount of mainCurrency. Receives a value as argument and need to be > 0.
     */
    func addMainCurrency(value: Double) {
        if value > 0 {
            mainCurrency += value
        }
    }
    
    
    /**
     Remove a value from the current amount of mainCurrency.
     */
    func removeMainCurrency(value: Double) {
        if value > 0 && value <= mainCurrency {
            mainCurrency -= value
        }
    }
    
    /**
     Add a value to the current amount of premiumCurrency. Receives a value as argument and need to be > 0.
     */
    func addPremiumCurrency(value: Double) {
        if value > 0 {
            premiumCurrency += value
        }
    }
    
    
    /**
     Remove a value from the current amount of premiumCurrency.
     */
    func removePremiumCurrency(value: Double) {
        if value > 0 && value <= premiumCurrency {
            premiumCurrency -= value
        }
    }
}

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
    private(set) var generators: [String]
    
    /**
        Substituir o tipo de generators!
     */
    init(id:String, name:String, mainCurrency: Double, premiumCurrency: Double, generators:[String]){
        self.id = id
        self.mainCurrency = mainCurrency
        self.premiumCurrency = premiumCurrency
        self.name = name
        self.generators = generators
    }
    
    
    func setName(newName: String){
        self.name = newName
    }
    /**
     Add a value to the current amount. Receives a value as argument and need to be > 0.
     */
    func addMainCurrency(value: Double) {
        if value > 0 {
            mainCurrency += value
        }
    }
    
    
    /**
     Remove a value from the current amount.
     */
    func removeMainCurrency(value: Double) {
        if value > 0 && value <= mainCurrency {
            mainCurrency -= value
        }
    }
    
    
    func addPremiumCurrency(value: Double) {
        if value > 0 {
            premiumCurrency += value
        }
    }
    
    
    /**
     Remove a value from the current amount.
     */
    func removePremiumCurrency(value: Double) {
        if value > 0 && value <= premiumCurrency {
            premiumCurrency -= value
        }
    }
}

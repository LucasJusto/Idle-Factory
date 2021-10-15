//
//  User.swift
//  Idle Factory
//
//  Created by Felipe Grosze Nipper de Oliveira on 14/10/21.
//

import Foundation
import CloudKit

class User {
    
    private(set) var id: CKRecord.ID
    private(set) var name: String
    private(set) var mainCurrency: Double = 0
    private(set) var premiumCurrency: Double = 0
    
    init(){
        id = CKRecord.ID()
        mainCurrency = 0
        premiumCurrency = 0
        name = ""
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

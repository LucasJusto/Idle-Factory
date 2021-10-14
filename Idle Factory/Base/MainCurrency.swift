//
//  MainCurrency.swift
//  Idle Factory
//
//  Created by Rodrigo Yukio Okido on 14/10/21.
//

import Foundation


/**
 MainCurrency class. Represents the basic currency of the game.
 */
class MainCurrency {
    
    private(set) static var amount: Int64 = 0
    
    
    /**
     Add a value to the current amount. Receives a value as argument and need to be > 0.
     */
    func add(value: Int64) {
        if value > 0 {
            MainCurrency.amount += value
        }
    }
    
    
    /**
     Remove a value from the current amount.
     */
    func remove(value: Int64) {
        if value > 0 && value < MainCurrency.amount {
            MainCurrency.amount -= value
        }
    }
}

//
//  Resource.swift
//  Idle Factory
//
//  Created by Lucas Dimer Justo on 18/10/21.
//

import Foundation

class Resource: Upgradable {
    var id: String
    
    var currentLevel: Int
    
    var currentPrice: Double
    
    var basePrice: Double
    
    var pricePLevelIncreaseTax: Double
    
    var baseQtt: Double
    
    var perSec: Double
    
    var type: String
    
    var qttPLevel: Double
    
    init(id: String, basePrice: Double, baseQtt: Double, currentLevel: Int, qttPLevel: Double, type: String, pricePLevelIncreaseTax: Double) {
        self.id = id
        self.currentLevel = currentLevel
        self.basePrice = basePrice
        self.pricePLevelIncreaseTax = pricePLevelIncreaseTax
        self.baseQtt = baseQtt
        self.qttPLevel = qttPLevel
        self.type = type
        
        currentPrice = basePrice * pow(pricePLevelIncreaseTax, Double(currentLevel))
        perSec = baseQtt + (Double(currentLevel) * qttPLevel)
    }
}

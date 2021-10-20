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
    
    var type: ResourceType
    
    var qttPLevel: Double
    
    init(id: String, basePrice: Double, baseQtt: Double, currentLevel: Int, qttPLevel: Double, type: ResourceType, pricePLevelIncreaseTax: Double) {
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

enum ResourceType: CustomStringConvertible {
    case computador
    
    var description: String {
        switch self {
            case .computador:
                return NSLocalizedString("ResourceTypeComputador", comment: "Computador")
        }
    }
    
    var key: String {
        switch self {
            case .computador:
                return "Computador"
        }
    }
    
    static func getKey(key: String) -> ResourceType{
        switch key {
            case "Computador":
                return ResourceType.computador
            default:
                return ResourceType.computador
        }
    }
}
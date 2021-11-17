//
//  Resource.swift
//  Idle Factory
//
//  Created by Lucas Dimer Justo on 18/10/21.
//

import Foundation

class Resource: Upgradable {
    
    var id: String?
    
    var currentLevel: Int
    
    var currentPrice: Double
    
    var basePrice: Double
    
    var pricePLevelIncreaseTax: Double
    
    var baseQtt: Double
    
    var perSec: Double
    
    var type: ResourceType
    
    var qttPLevel: Double
    
    var generatorType: FactoryType
    
    var typeMultiplier: Double
    
    init(id: String? = nil, basePrice: Double, baseQtt: Double, currentLevel: Int, qttPLevel: Double, type: ResourceType, pricePLevelIncreaseTax: Double, generatorType: FactoryType) {
        self.id = id
        self.currentLevel = currentLevel
        self.basePrice = basePrice
        self.pricePLevelIncreaseTax = pricePLevelIncreaseTax
        self.baseQtt = baseQtt
        self.qttPLevel = qttPLevel
        self.type = type
        self.generatorType = generatorType
        
        switch type {
        case .computer:
            typeMultiplier = 2
            perSec = (baseQtt + (Double(currentLevel) * qttPLevel)) * typeMultiplier
        case .tablet:
            typeMultiplier = 1.5
            perSec = (baseQtt + (Double(currentLevel) * qttPLevel)) * typeMultiplier
        case .smartphone:
            typeMultiplier = 1
            perSec = (baseQtt + (Double(currentLevel) * qttPLevel)) * typeMultiplier
        case .smartTV:
            typeMultiplier = 2.5
            perSec = (baseQtt + (Double(currentLevel) * qttPLevel)) * typeMultiplier
        case .headphone:
            typeMultiplier = 0.5
            perSec = (baseQtt + (Double(currentLevel) * qttPLevel)) * typeMultiplier
        }
        
        if generatorType == .NFT{
            currentPrice = (basePrice * 100) * pow(pricePLevelIncreaseTax, Double(currentLevel)) * typeMultiplier
        }else{
            currentPrice = basePrice * pow(pricePLevelIncreaseTax, Double(currentLevel)) * typeMultiplier
        }
        
    }
    
    func upgrade() {
        if currentLevel < 100 {
            
            currentLevel += 1
            currentPrice *= pricePLevelIncreaseTax
            perSec += qttPLevel
            
        }
    }
}

enum ResourceType: CustomStringConvertible {
    case computer, tablet, smartphone, smartTV, headphone
    
    var description: String {
        switch self {
            case .computer:
                return NSLocalizedString("ResourceTypeComputador", comment: "Computador")
        case .tablet:
            return NSLocalizedString("ResourceTypeTablet", comment: "Tablet")
        case .smartphone:
            return NSLocalizedString("ResourceTypeSmartphone", comment: "Smartphone")
        case .smartTV:
            return NSLocalizedString("ResourceTypeSmarttv", comment: "SmartTV")
        case .headphone:
            return NSLocalizedString("ResourceTypeHeadphone", comment: "Headphone")
        }
    }
    
    var key: String {
        switch self {
            case .computer:
                return "Computador"
        case .tablet:
            return "Tablet"
        case .smartphone:
            return "Smartphone"
        case .smartTV:
            return "SmartTV"
        case .headphone:
            return "Headphone"
        }
    }
    
    static func getKey(key: String) -> ResourceType{
        switch key {
            case "Computador":
                return ResourceType.computer
            case "Tablet":
                return ResourceType.tablet
            case "Smartphone":
                return ResourceType.smartphone
            case "SmartTV":
                return ResourceType.smartTV
            case "Headphone":
                return ResourceType.headphone
            default:
                return ResourceType.computer
        }
    }
}

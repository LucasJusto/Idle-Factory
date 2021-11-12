//
//  MarketPlaceOffer.swift
//  Idle Factory
//
//  Created by Lucas Dimer Justo on 03/11/21.
//

import Foundation

class Offer {
    let id: String
    let sellerID: String
    let generatorID: String
    var buyerID: String?
    let price: Double
    let currencyType: CurrencyType
    var isCollected: IsCollected
    
    public init(id: String, sellerID: String, generatorID: String, buyerID: String?, price: Double, currencyType: CurrencyType, isCollected: IsCollected) {
        self.id = id
        self.sellerID = sellerID
        self.generatorID = generatorID
        if let buyerID = buyerID {
            self.buyerID = buyerID
        }
        self.price = price
        self.currencyType = currencyType
        self.isCollected = isCollected
    }
}

enum IsCollected: CustomStringConvertible {
    case yes, no
    
    var description: String {
        switch self {
            case .yes:
                return "yes"
            case .no:
                return "no"
        }
    }
    
    var key: String {
        switch self {
            case .yes:
                return "yes"
            case .no:
                return "no"
        }
    }
    
    static func getKey(isCollected: String) -> IsCollected {
        switch isCollected {
        case "yes":
            return IsCollected.yes
        case "no":
            return IsCollected.no
        default:
            return IsCollected.no
        }
    }
}

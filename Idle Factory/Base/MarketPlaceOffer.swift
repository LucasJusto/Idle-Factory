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
    
    public init(id: String, sellerID: String, generatorID: String, buyerID: String?, price: Double, currencyType: CurrencyType) {
        self.id = id
        self.sellerID = sellerID
        self.generatorID = generatorID
        if let buyerID = buyerID {
            self.buyerID = buyerID
        }
        self.price = price
        self.currencyType = currencyType
    }
}

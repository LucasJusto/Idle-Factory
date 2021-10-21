//
//  Upgradable.swift
//  Idle Factory
//
//  Created by Lucas Dimer Justo on 12/10/21.
//

import Foundation

protocol Upgradable: AnyObject {
    var id: String? { get }
    var currentPrice: Double { get set} //price to upgrade it now | starts with basePrice
    var basePrice: Double { get set} //price to buy it and calculate next upgrades
    var currentLevel: Int { get set} //current upgrade level | starts at 1
    var pricePLevelIncreaseTax: Double { get set } //how much will increase the next price when upgrading
    var baseQtt: Double { get set} //base generation of resources
    var qttPLevel: Double { get set } //value that increases the generation per sec, based at the level
    var perSec: Double { get set } //how much it is generating per sec
    //var observer: MainCurrency { get set } //the MainCurrency class needs to know when it is upgraded to recalculate the currencypPerSec.
    
    func upgrade()
}

extension Upgradable {
    func upgrade() {
        currentLevel += 1
        currentPrice = basePrice * pow(pricePLevelIncreaseTax, Double(currentLevel))
        perSec += qttPLevel
    }
}

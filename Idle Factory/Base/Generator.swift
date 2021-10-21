//
//  Generator.swift
//  Idle Factory
//
//  Created by Lucas Dimer Justo on 12/10/21.
//

import Foundation

protocol Generator {
    
    var perSec: Double { get set } //generate this amount of currency per sec
    
    var resourcesArray : [Resource] { get set }
}

extension Generator {
    mutating func getCurrencyPerSec() -> Double {
        perSec = 0
        for n in 0..<resourcesArray.count {
            self.perSec += resourcesArray[n].perSec
        }
        return perSec
    }
}


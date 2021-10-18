//
//  Generator.swift
//  Idle Factory
//
//  Created by Lucas Dimer Justo on 12/10/21.
//

import Foundation

protocol Generator {
    
    var perSec: Double { get set } //generate this amount of currency per sec
    
    var resourcesArray : [String] { get set }
}

extension Generator {
    func getCurrencyPerSec() -> Double {
        // TODO: Multiply all resources
        return perSec
    }
}


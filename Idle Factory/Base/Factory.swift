//
//  Factory.swift
//  Idle Factory
//
//  Created by Felipe Grosze Nipper de Oliveira on 15/10/21.
//

import Foundation
import SpriteKit


enum FactoryType: CustomStringConvertible, CaseIterable {
    case Basic, NFT
    
    var description: String {
        switch self {
            case .NFT:
                return NSLocalizedString("NFT", comment: "")
            case .Basic:
                return NSLocalizedString("Basic", comment: "")
            
        }
    }
    
    var key: String {
        switch self {
            case .NFT:
            return "NFT"
        case .Basic:
            return "Basic"
            
        }
    }
    
    static func getFactoryType(factoryType: String) -> FactoryType {
        switch factoryType {
            case "NFT":
                return .NFT
            case "Basic":
                return .Basic
            default:
                return .Basic
        }
    }
}

class Factory: SKNode, Generator  {
        
    var id: String
    var perSec: Double
    var type: FactoryType
    var energy: Int
    var resourcesArray: [String]
    
    init(id: String,perSec: Double, resourcesArray:[String] , energy: Int, type: FactoryType){
        self.id = id
        self.perSec = perSec
        self.resourcesArray = resourcesArray
        self.energy = energy
        self.type = type
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

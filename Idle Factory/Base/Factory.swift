//
//  Factory.swift
//  Idle Factory
//
//  Created by Felipe Grosze Nipper de Oliveira on 15/10/21.
//

import Foundation
import SpriteKit

class Factory: Generator  {
    
    var id: String
    var perSec: Double
    var type: FactoryType
    var isActive: IsActive
    var energy: Int
    var resourcesArray: [Resource]
    var position: GeneratorPositions
    var node: SKSpriteNode
    
    init(id: String,perSec: Double, resourcesArray:[String] , energy: Int, type: String, texture: SKTexture?, position: String, isActive: String){
        self.id = id
        self.perSec = perSec
        self.resourcesArray = resourcesArray
        self.energy = energy
        self.type = FactoryType.getFactoryType(factoryType: type)
        self.node = SKSpriteNode(texture: texture)
        self.position = getGeneratorPositions(position: position)
        self.isActive = IsActive.getKey(isActive: isActive)
    }
}

enum IsActive: CustomStringConvertible {
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
    
    static func getKey(isActive: String) -> IsActive {
        switch isActive {
            case "yes":
                return IsActive.yes
            case "no":
                return IsActive.no
            default:
                return IsActive.no
        }
    }
}

enum GeneratorPositions: CustomStringConvertible, CaseIterable {
    case first
    case second
    case third
    case fourth
    case fifth
    case sixth
    
    var description: String {
        switch self {
        case .first:
            return "first"
        case .second:
            return "second"
        case .third:
            return "third"
        case .fourth:
            return "fourth"
        case .fifth:
            return "fifth"
        case .sixth:
            return "sixth"
        }
    }
    
    var key: String {
        switch self {
        case .first:
            return "first"
        case .second:
            return "second"
        case .third:
            return "third"
        case .fourth:
            return "fourth"
        case .fifth:
            return "fifth"
        case .sixth:
            return "sixth"
        }
    }
    
}

func getGeneratorPositions(position: String) -> GeneratorPositions {
    switch position {
    case "first":
        return .first
    case "second":
        return .second
    case "third":
        return .third
    case "fourth":
        return .fourth
    case "fifth":
        return .fifth
    case "sixth":
        return .sixth
    default:
        return .first
    }
}

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




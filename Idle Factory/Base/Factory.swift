//
//  Factory.swift
//  Idle Factory
//
//  Created by Felipe Grosze Nipper de Oliveira on 15/10/21.
//

import Foundation
import SpriteKit

class Factory: Generator  {
    
    var id: String?
    var perSec: Double?
    var type: FactoryType
    var isActive: IsActive
    var energy: Int
    var resourcesArray: [Resource]
    var position: GeneratorPositions
    var node: SKSpriteNode
    var textureName: String
    
    init(id: String? = nil, resourcesArray:[Resource] , energy: Int, type: FactoryType, texture: String, position: GeneratorPositions, isActive: IsActive){
        self.id = id
        self.resourcesArray = resourcesArray
        self.energy = energy
        self.type = type
        self.node = SKSpriteNode(texture: SKTexture(imageNamed: texture))
        self.position = position
        self.isActive = isActive
        self.textureName = texture
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
    case none //if the generator is not active
    
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
            case .none:
                return "none"
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
            case .none:
                return "none"
        }
    }
    static func getGeneratorPositions(position: String) -> GeneratorPositions {
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




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
    var perSec: Double
    var type: FactoryType
    var isActive: IsActive
    var energy: Int
    var resourcesArray: [Resource]
    var position: GeneratorPositions
    var node: SKSpriteNode
    var textureName: String
    var visual: Visual?
    var isOffer: IsOffer
    var userID: String
    
    init(id: String? = nil, resourcesArray:[Resource] , energy: Int, type: FactoryType, texture: String? = nil, position: GeneratorPositions, isActive: IsActive, isOffer: IsOffer, userID: String){
        self.id = id
        self.resourcesArray = resourcesArray
        self.energy = energy
        self.type = type
        if(type == .NFT) {
            let v = FactoryVisualGenerator.generateVisual()
            self.node = v.0
            self.visual = v.1
            self.textureName = ""
        }
        else {
            self.node = SKSpriteNode(texture: SKTexture(imageNamed: texture ?? "Basic_Factory_level_1"))
            self.textureName = texture ?? "Basic_Factory_level_1"
        }
        self.position = position
        self.isActive = isActive
        self.perSec = 0
        self.isOffer = isOffer
        self.userID = userID
    }
    
    init(id: String? = nil, resourcesArray:[Resource] , energy: Int, type: FactoryType, texture: String? = nil, position: GeneratorPositions, isActive: IsActive, visual: Visual, isOffer: IsOffer, userID: String){
        self.id = id
        self.resourcesArray = resourcesArray
        self.energy = energy
        self.type = type
        if(type == .NFT) {
            self.node = FactoryVisualGenerator.getNode(visual: visual)
            self.visual = visual
            self.textureName = ""
        }
        else {
            self.node = SKSpriteNode(texture: SKTexture(imageNamed: texture ?? "Basic_Factory_level_1"))
            self.textureName = texture ?? "Basic_Factory_level_1"
        }
        self.position = position
        self.isActive = isActive
        self.perSec = 0
        self.isOffer = isOffer
        self.userID = userID
    }
    
    func upgrade(index: Int) {
        
        var level: Double = 0.0
        var media: Double = 0.0
        
        for n in 0..<resourcesArray.count{
            level += Double(resourcesArray[n].currentLevel)
        }
        media = level/Double(resourcesArray.count)
        
        if media < 100 {
            
            level += 1
            resourcesArray[index].upgrade()

            media = level/Double(resourcesArray.count)
            
            if type == .Basic {
                if media == 100{
                    node.texture = SKTexture(imageNamed: "Basic_Factory_level_6")
                    textureName = "Basic_Factory_level_6"
                }
                else if media >= 80{
                    node.texture = SKTexture(imageNamed: "Basic_Factory_level_5")
                    textureName = "Basic_Factory_level_5"
                }
                else if media >= 60{
                    node.texture = SKTexture(imageNamed: "Basic_Factory_level_4")
                    textureName = "Basic_Factory_level_4"
                }
                else if media >= 40{
                    node.texture = SKTexture(imageNamed: "Basic_Factory_level_3")
                    textureName = "Basic_Factory_level_3"
                }
                else if media >= 20{
                    node.texture = SKTexture(imageNamed: "Basic_Factory_level_2")
                    textureName = "Basic_Factory_level_2"
                }
            }
        }
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

enum IsOffer: CustomStringConvertible {
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
    
    static func getKey(isOffer: String) -> IsOffer {
        switch isOffer {
        case "yes":
            return IsOffer.yes
        case "no":
            return IsOffer.no
        default:
            return IsOffer.no
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




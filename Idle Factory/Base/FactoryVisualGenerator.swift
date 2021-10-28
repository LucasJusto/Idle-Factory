//
//  FactoryVisualGenerator.swift
//  Idle Factory
//
//  Created by Lucas Dimer Justo on 28/10/21.
//

import Foundation
import UIKit
import SpriteKit

class FactoryVisualGenerator {
    static func getRandomColor() -> UIColor {
        let r = CGFloat.random(in: 0...1)
        let g = CGFloat.random(in: 0...1)
        let b = CGFloat.random(in: 0...1)
        
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
    
    static func adjustComponent(node: SKSpriteNode) -> SKSpriteNode {
        node.zPosition = 3
        node.colorBlendFactor = 1
        node.color = getRandomColor()
        
        return node
    }
    
    static func generateVisual() -> SKSpriteNode {
        //create the base ground
        let visual = SKSpriteNode(imageNamed: "ground")
        visual.anchorPoint = CGPoint(x: 0.5, y: 0)
        visual.zPosition = 1
//        visual.colorBlendFactor = 1
//        visual.color = getRandomColor()
        
        //base: choose, create and add as child to ground
        let randomBase = Bool.random()
        var baseName = "base_big"
        var selectedBase = SelectedBase.big
        if false {
            baseName = "base_small"
            selectedBase = SelectedBase.small
        }
        let base = SKSpriteNode(imageNamed: baseName)
        base.anchorPoint = CGPoint(x: 0.5, y: 0)
        base.zPosition = 2
        base.position = CGPoint(x: visual.size.width * selectedBase.multipliersForPosition.x, y: visual.size.height * selectedBase.multipliersForPosition.y)
        visual.addChild(base)
        
        let window2 = SKSpriteNode(imageNamed: "door_big_left")
        window2.zPosition = 3
        window2.position = CGPoint(x: base.size.width * -0.25, y: base.size.height * 0.255)
        base.addChild(window2)
        
//        let window3 = SKSpriteNode(imageNamed: "door_small_left")
//        window3.zPosition = 3
//        window3.position = CGPoint(x: base.size.width * -0.1, y: base.size.height * 0.18)
//        base.addChild(window3)
        
        return visual
    }
}

enum SelectedBase {
    case small, big
    
    var multipliersForPosition: CGPoint {
        //positions relative to ground
        switch self {
            case .big:
                return CGPoint(x: 0, y: 0.2)
            case .small:
                return CGPoint(x: 0, y: 0.15)
        }
    }
}

enum BaseBigRelatedPositions {
    case windowLeft1, windowLeft2, windowLeft3, windowRight1, windowRight2, windowRight3,
    windowBigLeft1, windowBigLeft2, windowBigLeft3, windowBigRight1, windowBigRight2, windowBigRight3,
    doorBigLeft, doorBigRight,
    doorGarageLeft, doorGarageRight,
    doorSmallLeft1, doorSmallLeft2, doorSmallLeft3, doorSmallRight1, doorSmallRight2, doorSmalRight3
    
    var multipliersForPosition: CGPoint {
        //3 = closer to center corner , 2 = mid, 1 = far to center corner (talking about the number in the end of names)
        //positions relative to base
        switch self {
            case .windowLeft1:
                return CGPoint(x: -0.4, y: 0.43)
            case .windowLeft2:
                return CGPoint(x: -0.25, y: 0.36)
            case .windowLeft3:
                return CGPoint(x: -0.1, y: 0.29)
            case .windowRight1:
                return CGPoint(x: 0.4, y: 0.43)
            case .windowRight2:
                return CGPoint(x: 0.25, y: 0.36)
            case .windowRight3:
                return CGPoint(x: 0.1, y: 0.29)
            case .windowBigLeft1:
                return CGPoint(x: -0.4, y: 0.43)
            case .windowBigLeft2:
                return CGPoint(x: -0.25, y: 0.36)
            case .windowBigLeft3:
                return CGPoint(x: -0.1, y: 0.29)
            case .windowBigRight1:
                return CGPoint(x: 0.4, y: 0.43)
            case .windowBigRight2:
                return CGPoint(x: 0.25, y: 0.36)
            case .windowBigRight3:
                return CGPoint(x: 0.1, y: 0.29)
            case .doorBigLeft:
                return CGPoint(x: -0.25, y: 0.255)
            case .doorBigRight:
                return CGPoint(x: 0.25, y: 0.255)
            case .doorGarageLeft:
                return CGPoint(x: -0.25, y: 0.26)
            case .doorGarageRight:
                return CGPoint(x: 0.25, y: 0.26)
            case .doorSmallLeft1:
                return CGPoint(x: -0.4, y: 0.33)
            case .doorSmallLeft2:
                return CGPoint(x: -0.25, y: 0.255)
            case .doorSmallLeft3:
                return CGPoint(x: -0.1, y: 0.18)
            case .doorSmallRight1:
                return CGPoint(x: 0.4, y: 0.33)
            case .doorSmallRight2:
                return CGPoint(x: 0.25, y: 0.255)
            case .doorSmalRight3:
                return CGPoint(x: 0.1, y: 0.18)
        }
    }
}

enum BaseSmallRelatedPositions {
    case windowLeft1, windowLeft2, windowLeft3, windowRight1, windowRight2, windowRight3,
    windowBigLeft1, windowBigLeft2, windowBigLeft3, windowBigRight1, windowBigRight2, windowBigRight3,
    doorBigLeft, doorBigRight,
    doorGarageLeft, doorGarageRight,
    doorSmallLeft1, doorSmallLeft2, doorSmallLeft3, doorSmallRight1, doorSmallRight2, doorSmalRight3
    
    var multipliersForPosition: CGPoint {
        //3 = closer to center corner , 2 = mid, 1 = far to center corner (talking about the number in the end of names)
        //positions relative to base
        switch self {
            case .windowLeft1:
                return CGPoint(x: -0.4, y: 0.43)
            case .windowLeft2:
                return CGPoint(x: -0.25, y: 0.36)
            case .windowLeft3:
                return CGPoint(x: -0.1, y: 0.29)
            case .windowRight1:
                return CGPoint(x: 0.4, y: 0.43)
            case .windowRight2:
                return CGPoint(x: 0.25, y: 0.36)
            case .windowRight3:
                return CGPoint(x: 0.1, y: 0.29)
            case .windowBigLeft1:
                return CGPoint(x: -0.4, y: 0.43)
            case .windowBigLeft2:
                return CGPoint(x: -0.25, y: 0.36)
            case .windowBigLeft3:
                return CGPoint(x: -0.1, y: 0.29)
            case .windowBigRight1:
                return CGPoint(x: 0.4, y: 0.43)
            case .windowBigRight2:
                return CGPoint(x: 0.25, y: 0.36)
            case .windowBigRight3:
                return CGPoint(x: 0.1, y: 0.29)
            case .doorBigLeft:
                return CGPoint(x: -0.25, y: 0.255)
            case .doorBigRight:
                return CGPoint(x: 0.25, y: 0.255)
            case .doorGarageLeft:
                return CGPoint(x: -0.25, y: 0.26)
            case .doorGarageRight:
                return CGPoint(x: 0.25, y: 0.26)
            case .doorSmallLeft1:
                return CGPoint(x: -0.4, y: 0.33)
            case .doorSmallLeft2:
                return CGPoint(x: -0.25, y: 0.255)
            case .doorSmallLeft3:
                return CGPoint(x: -0.1, y: 0.18)
            case .doorSmallRight1:
                return CGPoint(x: 0.4, y: 0.33)
            case .doorSmallRight2:
                return CGPoint(x: 0.25, y: 0.255)
            case .doorSmalRight3:
                return CGPoint(x: 0.1, y: 0.18)
        }
    }
}

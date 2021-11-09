//
//  FactoryVisualGenerator.swift
//  Idle Factory
//
//  Created by Lucas Dimer Justo on 28/10/21.
//

import Foundation
import UIKit
import SpriteKit

struct Visual {
    var bottom: [BaseSmallRelatedPositions]
    var top: [BaseBigRelatedPositions]
    var bottomColor: UIColor
    var topColor: UIColor
    
    init(bottomColor: UIColor, topColor: UIColor) {
        bottom = [BaseSmallRelatedPositions]()
        top = [BaseBigRelatedPositions]()
        self.bottomColor = bottomColor
        self.topColor = topColor
    }
}

class FactoryVisualGenerator {
    static var smallBaseColors = [UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1),
                                  UIColor(red: 255/255, green: 242/255, blue: 140/255, alpha: 1),
                                  UIColor(red: 242/255, green: 129/255, blue: 87/255, alpha: 1),
                                  UIColor(red: 242/255, green: 177/255, blue: 57/255, alpha: 1),
                                  UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1),
                                  UIColor(red: 242/255, green: 129/255, blue: 87/255, alpha: 1),
                                  UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1),
                                  UIColor(red: 2/255, green: 76/255, blue: 139/255, alpha: 1),
                                  UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1),
                                  UIColor(red: 206/255, green: 34/255, blue: 90/255, alpha: 1),
                                  UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1),
                                  UIColor(red: 243/255, green: 90/255, blue: 56/255, alpha: 1),
                                  UIColor(red: 5/255, green: 190/255, blue: 195/255, alpha: 1),
                                  UIColor(red: 2/255, green: 76/255, blue: 139/255, alpha: 1),
                                  UIColor(red: 192/255, green: 93/255, blue: 12/255, alpha: 1),
                                  UIColor(red: 192/255, green: 93/255, blue: 12/255, alpha: 1),
                                  UIColor(red: 5/255, green: 190/255, blue: 195/255, alpha: 1),
                                  UIColor(red: 206/255, green: 34/255, blue: 90/255, alpha: 1),
                                  UIColor(red: 2/255, green: 76/255, blue: 139/255, alpha: 1),
                                  UIColor(red: 243/255, green: 90/255, blue: 56/255, alpha: 1)]
    static var bigBaseColors = [UIColor(red: 255/255, green: 242/255, blue: 140/255, alpha: 1),
                                UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1),
                                UIColor(red: 242/255, green: 177/255, blue: 57/255, alpha: 1),
                                UIColor(red: 242/255, green: 129/255, blue: 87/255, alpha: 1),
                                UIColor(red: 242/255, green: 129/255, blue: 87/255, alpha: 1),
                                UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1),
                                UIColor(red: 2/255, green: 76/255, blue: 139/255, alpha: 1),
                                UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1),
                                UIColor(red: 206/255, green: 34/255, blue: 90/255, alpha: 1),
                                UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1),
                                UIColor(red: 243/255, green: 90/255, blue: 56/255, alpha: 1),
                                UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1),
                                UIColor(red: 2/255, green: 76/255, blue: 139/255, alpha: 1),
                                UIColor(red: 5/255, green: 190/255, blue: 195/255, alpha: 1),
                                UIColor(red: 192/255, green: 93/255, blue: 12/255, alpha: 1),
                                UIColor(red: 192/255, green: 93/255, blue: 12/255, alpha: 1),
                                UIColor(red: 206/255, green: 34/255, blue: 90/255, alpha: 1),
                                UIColor(red: 5/255, green: 190/255, blue: 195/255, alpha: 1),
                                UIColor(red: 243/255, green: 90/255, blue: 56/255, alpha: 1),
                                UIColor(red: 2/255, green: 76/255, blue: 139/255, alpha: 1)]
    
    static func getRandomColors() -> [UIColor] {
        let randomIndex = Int.random(in: 0...bigBaseColors.count-1)
        var colors = [UIColor]()
        colors.append(smallBaseColors[randomIndex])
        colors.append(bigBaseColors[randomIndex])
        return colors
    }
    
    static func adjustComponent(node: SKSpriteNode) -> SKSpriteNode {
        node.zPosition = (node.parent?.zPosition ?? 2) + 1
        
        return node
    }
    
    static func getNodePosition(base: SKSpriteNode, nodeType: BaseBigRelatedPositions) -> CGPoint {
        return CGPoint(x: base.size.width * nodeType.multipliersForPosition.x, y: base.size.height * nodeType.multipliersForPosition.y)
    }
    
    static func getNodePosition(base: SKSpriteNode, nodeType: BaseSmallRelatedPositions) -> CGPoint {
        return CGPoint(x: base.size.width * nodeType.multipliersForPosition.x, y: base.size.height * nodeType.multipliersForPosition.y)
    }
    
    static func getRandomAvailablePosition(positions: [Bool]) -> Int {
        //identifies if there is at least one available position in the array parameter
        var existsAvailablePosition = false
        for b in positions {
            if b {
                existsAvailablePosition = true
            }
        }
        
        if existsAvailablePosition {
            //if exists at least one available position choose a random available position.
            var position = Int.random(in: 0...positions.count-1)
            
            while !positions[position] {
                if position == positions.count-1 {
                    position = 0
                }
                else {
                    position += 1
                }
                
            }
            return position
        }
        //else returns 0
        return 0
    }
    
    static func generateVisual() -> (SKSpriteNode, Visual) {
        //create the base ground
        let node = SKSpriteNode(imageNamed: "ground")
        node.anchorPoint = CGPoint(x: 0.5, y: 0)
        node.zPosition = 1
        
        let colors = getRandomColors()
        var visual = Visual(bottomColor: colors[0], topColor: colors[1])
        
        //build baseBottom
        let baseBottom = SKSpriteNode(imageNamed: "base_small")
        baseBottom.anchorPoint = CGPoint(x: 0.5, y: 0)
        baseBottom.zPosition = 2
        baseBottom.position = CGPoint(x: node.size.width * SelectedBase.small.multipliersForPosition.x, y: node.size.height * SelectedBase.small.multipliersForPosition.y)
        baseBottom.colorBlendFactor = 1
        baseBottom.color = colors[0]
        
        //randomly build left wall for baseBottom
        let randomOnly1Object = Bool.random()
        if randomOnly1Object {
            let randomGarageOrBigDoor = Bool.random()
            if randomGarageOrBigDoor {
                var garage = SKSpriteNode(imageNamed: BaseSmallRelatedPositions.doorGarageLeft.image)
                garage = adjustComponent(node: garage)
                garage.position = getNodePosition(base: baseBottom, nodeType: BaseSmallRelatedPositions.doorGarageLeft)
                baseBottom.addChild(garage)
                visual.bottom.append(BaseSmallRelatedPositions.doorGarageLeft)
            }
            else {
                var bigDoor = SKSpriteNode(imageNamed: BaseSmallRelatedPositions.doorBigLeft.image)
                bigDoor = adjustComponent(node: bigDoor)
                bigDoor.position = getNodePosition(base: baseBottom, nodeType: BaseSmallRelatedPositions.doorBigLeft)
                baseBottom.addChild(bigDoor)
                visual.bottom.append(BaseSmallRelatedPositions.doorBigLeft)
            }
        }
        else {
            let qttComponents = Int.random(in: 1...2)//how many objects will we insert
            var arrayOfAvailablePositions = [Bool]()//which position is available? (starts with all true)
            for _ in 0...2 {
                arrayOfAvailablePositions.append(true)
            }
            var doorComponent = BaseSmallRelatedPositions.doorSmallLeft1
            let posi = getRandomAvailablePosition(positions: arrayOfAvailablePositions)
            arrayOfAvailablePositions[posi] = false
            if posi == 0 {
                doorComponent = BaseSmallRelatedPositions.doorSmallLeft1
            }
            else if posi == 1 {
                doorComponent = BaseSmallRelatedPositions.doorSmallLeft2
            }
            else {
                doorComponent = BaseSmallRelatedPositions.doorSmallLeft3
            }
            var d = SKSpriteNode(imageNamed: doorComponent.image)
            d = adjustComponent(node: d)
            d.position = getNodePosition(base: baseBottom, nodeType: doorComponent)
            baseBottom.addChild(d)
            visual.bottom.append(doorComponent)
            //create and add to base the components
            for _ in 0...qttComponents-1 {
                let pos = getRandomAvailablePosition(positions: arrayOfAvailablePositions)
                arrayOfAvailablePositions[pos] = false
                var component: BaseSmallRelatedPositions = BaseSmallRelatedPositions.windowLeft1
                let r = Int.random(in: 1...2)
                if r == 1 {
                    if pos == 0 {
                        component = BaseSmallRelatedPositions.windowBigLeft1
                    }
                    else if pos == 1 {
                        component = BaseSmallRelatedPositions.windowBigLeft2
                    }
                    else {
                        component = BaseSmallRelatedPositions.windowBigLeft3
                    }
                }
                else if r == 2 {
                    if pos == 0 {
                        component = BaseSmallRelatedPositions.windowLeft1
                    }
                    else if pos == 1 {
                        component = BaseSmallRelatedPositions.windowLeft2
                    }
                    else {
                        component = BaseSmallRelatedPositions.windowLeft3
                    }
                }
                var n = SKSpriteNode(imageNamed: component.image)
                n = adjustComponent(node: n)
                n.position = getNodePosition(base: baseBottom, nodeType: component)
                baseBottom.addChild(n)
                visual.bottom.append(component)
            }

        }
        //randomly build right wall for baseBottom
        let randomOnly1ObjectR = Bool.random()
        if randomOnly1ObjectR {
            let randomGarageOrBigDoor = Bool.random()
            if randomGarageOrBigDoor {
                var garage = SKSpriteNode(imageNamed: BaseSmallRelatedPositions.doorGarageRight.image)
                garage = adjustComponent(node: garage)
                garage.position = getNodePosition(base: baseBottom, nodeType: BaseSmallRelatedPositions.doorGarageRight)
                baseBottom.addChild(garage)
                visual.bottom.append(BaseSmallRelatedPositions.doorGarageRight)
            }
            else {
                var bigDoor = SKSpriteNode(imageNamed: BaseSmallRelatedPositions.doorBigRight.image)
                bigDoor = adjustComponent(node: bigDoor)
                bigDoor.position = getNodePosition(base: baseBottom, nodeType: BaseSmallRelatedPositions.doorBigRight)
                baseBottom.addChild(bigDoor)
                visual.bottom.append(BaseSmallRelatedPositions.doorBigRight)
            }
        }
        else {
            let qttComponents = Int.random(in: 1...2)//how many objects will we insert
            var arrayOfAvailablePositions = [Bool]()//which position is available? (starts with all true)
            for _ in 0...2 {
                arrayOfAvailablePositions.append(true)
            }
            var doorComponent = BaseSmallRelatedPositions.doorSmallRight1
            let posi = getRandomAvailablePosition(positions: arrayOfAvailablePositions)
            arrayOfAvailablePositions[posi] = false
            if posi == 0 {
                doorComponent = BaseSmallRelatedPositions.doorSmallRight1
            }
            else if posi == 1 {
                doorComponent = BaseSmallRelatedPositions.doorSmallRight2
            }
            else {
                doorComponent = BaseSmallRelatedPositions.doorSmallRight3
            }
            var d = SKSpriteNode(imageNamed: doorComponent.image)
            d = adjustComponent(node: d)
            d.position = getNodePosition(base: baseBottom, nodeType: doorComponent)
            baseBottom.addChild(d)
            visual.bottom.append(doorComponent)
            //create and add to base the components
            for _ in 0...qttComponents-1 {
                let pos = getRandomAvailablePosition(positions: arrayOfAvailablePositions)
                arrayOfAvailablePositions[pos] = false
                var component: BaseSmallRelatedPositions = BaseSmallRelatedPositions.windowRight1
                let r = Int.random(in: 1...2)
                if r == 1 {
                    if pos == 0 {
                        component = BaseSmallRelatedPositions.windowBigRight1
                    }
                    else if pos == 1 {
                        component = BaseSmallRelatedPositions.windowBigRight2
                    }
                    else {
                        component = BaseSmallRelatedPositions.windowBigRight3
                    }
                }
                else if r == 2 {
                    if pos == 0 {
                        component = BaseSmallRelatedPositions.windowRight1
                    }
                    else if pos == 1 {
                        component = BaseSmallRelatedPositions.windowRight2
                    }
                    else {
                        component = BaseSmallRelatedPositions.windowRight3
                    }
                }
                var n = SKSpriteNode(imageNamed: component.image)
                n = adjustComponent(node: n)
                n.position = getNodePosition(base: baseBottom, nodeType: component)
                baseBottom.addChild(n)
                visual.bottom.append(component)
            }

        }
        node.addChild(baseBottom)
        
        //build baseTop
        let baseTop = SKSpriteNode(imageNamed: "base_big")
        baseTop.anchorPoint = CGPoint(x: 0.5, y: 0)
        baseTop.zPosition = 3
        baseTop.position = CGPoint(x: node.size.width * SelectedBase.big.multipliersForPosition.x, y: node.size.height * SelectedBase.big.multipliersForPosition.y)
        baseTop.colorBlendFactor = 1
        baseTop.color = colors[1]
        
        let qttComponents = Int.random(in: 2...3)//how many objects will we insert
        var arrayOfAvailablePositions = [Bool]()//which position is available? (starts with all true)
        for _ in 0...2 {
            arrayOfAvailablePositions.append(true)
        }
        
        //randomly creates left wall for baseTop
        //create and add to base the components
        for _ in 0...qttComponents-1 {
            let pos = getRandomAvailablePosition(positions: arrayOfAvailablePositions)
            arrayOfAvailablePositions[pos] = false
            var component: BaseBigRelatedPositions = BaseBigRelatedPositions.windowLeft1
            let r = Int.random(in: 1...2)
            if r == 1 {
                if pos == 0 {
                    component = BaseBigRelatedPositions.windowBigLeft1
                }
                else if pos == 1 {
                    component = BaseBigRelatedPositions.windowBigLeft2
                }
                else {
                    component = BaseBigRelatedPositions.windowBigLeft3
                }
            }
            else if r == 2 {
                if pos == 0 {
                    component = BaseBigRelatedPositions.windowLeft1
                }
                else if pos == 1 {
                    component = BaseBigRelatedPositions.windowLeft2
                }
                else {
                    component = BaseBigRelatedPositions.windowLeft3
                }
            }
            var n = SKSpriteNode(imageNamed: component.image)
            n = adjustComponent(node: n)
            n.position = getNodePosition(base: baseTop, nodeType: component)
            baseTop.addChild(n)
            visual.top.append(component)
        }

        //randomly build right wall for baseBottom
        let qttComponents2 = Int.random(in: 2...3)//how many objects will we insert
        var arrayOfAvailablePositions2 = [Bool]()//which position is available? (starts with all true)
        for _ in 0...2 {
            arrayOfAvailablePositions2.append(true)
        }
        
        //create and add to base the components
        for _ in 0...qttComponents2-1 {
            let pos = getRandomAvailablePosition(positions: arrayOfAvailablePositions2)
            arrayOfAvailablePositions2[pos] = false
            var component: BaseBigRelatedPositions = BaseBigRelatedPositions.windowRight1
            let r = Int.random(in: 1...2)
            if r == 1 {
                if pos == 0 {
                    component = BaseBigRelatedPositions.windowBigRight1
                }
                else if pos == 1 {
                    component = BaseBigRelatedPositions.windowBigRight2
                }
                else {
                    component = BaseBigRelatedPositions.windowBigRight3
                }
            }
            else if r == 2 {
                if pos == 0 {
                    component = BaseBigRelatedPositions.windowRight1
                }
                else if pos == 1 {
                    component = BaseBigRelatedPositions.windowRight2
                }
                else {
                    component = BaseBigRelatedPositions.windowRight3
                }
            }
            var n = SKSpriteNode(imageNamed: component.image)
            n = adjustComponent(node: n)
            n.position = getNodePosition(base: baseTop, nodeType: component)
            baseTop.addChild(n)
            visual.top.append(component)
        }

        node.addChild(baseTop)
        
        //randomly generates roof
        var chimneyComponent = BaseBigRelatedPositions.chimney1
        let rand = Int.random(in: 1...4)
        if rand == 1 {
            chimneyComponent = BaseBigRelatedPositions.chimney2
        }
        else if rand == 2 {
            chimneyComponent = BaseBigRelatedPositions.chimney3
        }
        else if rand == 3 {
            chimneyComponent = BaseBigRelatedPositions.chimney4
        }
        var chimney = SKSpriteNode(imageNamed: chimneyComponent.image)
        chimney = adjustComponent(node: chimney)
        chimney.position = CGPoint(x: baseTop.size.width * chimneyComponent.multipliersForPosition.x, y: baseTop.size.height * chimneyComponent.multipliersForPosition.y)
        baseTop.addChild(chimney)
        visual.top.append(chimneyComponent)

        
        return (node, visual)
    }
    
    static func getNode(visual: Visual) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: "ground")
        node.anchorPoint = CGPoint(x: 0.5, y: 0)
        node.zPosition = 1
        
        //fill bottom
        let baseBottom = SKSpriteNode(imageNamed: "base_small")
        baseBottom.anchorPoint = CGPoint(x: 0.5, y: 0)
        baseBottom.zPosition = 2
        baseBottom.position = CGPoint(x: node.size.width * SelectedBase.small.multipliersForPosition.x, y: node.size.height * SelectedBase.small.multipliersForPosition.y)
        baseBottom.colorBlendFactor = 1
        baseBottom.color = visual.bottomColor
        
        for bottomComponent in visual.bottom {
            var n = SKSpriteNode(imageNamed: bottomComponent.image)
            n = adjustComponent(node: n)
            n.position = getNodePosition(base: baseBottom, nodeType: bottomComponent)
            baseBottom.addChild(n)
        }
        
        node.addChild(baseBottom)
        
        //fill top
        let baseTop = SKSpriteNode(imageNamed: "base_big")
        baseTop.anchorPoint = CGPoint(x: 0.5, y: 0)
        baseTop.zPosition = 3
        baseTop.position = CGPoint(x: node.size.width * SelectedBase.big.multipliersForPosition.x, y: node.size.height * SelectedBase.big.multipliersForPosition.y)
        baseTop.colorBlendFactor = 1
        baseTop.color = visual.topColor
        
        for topComponent in visual.bottom {
            var n = SKSpriteNode(imageNamed: topComponent.image)
            n = adjustComponent(node: n)
            n.position = getNodePosition(base: baseTop, nodeType: topComponent)
            baseTop.addChild(n)
        }
        
        node.addChild(baseTop)
        
        return node
    }
}

enum SelectedBase {
    case small, big
    
    var multipliersForPosition: CGPoint {
        //positions relative to ground
        switch self {
            case .big:
                return CGPoint(x: 0, y: 0.6)
            case .small:
                return CGPoint(x: 0, y: 0.15)
        }
    }
}

enum BaseBigRelatedPositions: CustomStringConvertible {
    case windowLeft1, windowLeft2, windowLeft3, windowRight1, windowRight2, windowRight3,
    windowBigLeft1, windowBigLeft2, windowBigLeft3, windowBigRight1, windowBigRight2, windowBigRight3,
    doorBigLeft, doorBigRight,
    doorGarageLeft, doorGarageRight,
    doorSmallLeft1, doorSmallLeft2, doorSmallLeft3, doorSmallRight1, doorSmallRight2, doorSmallRight3,
    chimney1, chimney2, chimney3, chimney4
    
    var description: String {
        switch self {
            case .windowLeft1:
                return "window1_left"
            case .windowLeft2:
                return "window2_left"
            case .windowLeft3:
                return "window3_left"
            case .windowRight1:
                return "window1_right"
            case .windowRight2:
                return "window2_right"
            case .windowRight3:
                return "window3_right"
            case .windowBigLeft1:
                return "window1_big_left"
            case .windowBigLeft2:
                return "window2_big_left"
            case .windowBigLeft3:
                return "window3_big_left"
            case .windowBigRight1:
                return "window1_big_right"
            case .windowBigRight2:
                return "window2_big_right"
            case .windowBigRight3:
                return "window3_big_right"
            case .doorBigLeft:
                return "door_big_left"
            case .doorBigRight:
                return "door_big_right"
            case .doorGarageLeft:
                return "door_garage_left"
            case .doorGarageRight:
                return "door_garage_right"
            case .doorSmallLeft1:
                return "door1_small_left"
            case .doorSmallLeft2:
                return "door2_small_left"
            case .doorSmallLeft3:
                return "door3_small_left"
            case .doorSmallRight1:
                return "door1_small_right"
            case .doorSmallRight2:
                return "door2_small_right"
            case .doorSmallRight3:
                return "door3_small_right"
            case .chimney1:
                return "chimney1"
            case .chimney2:
                return "chimney2"
            case .chimney3:
                return "chimney3"
            case .chimney4:
                return "chimney4"
                
        }
    }
    
    var image: String {
        switch self {
            case .windowLeft1:
                return "window_left"
            case .windowLeft2:
                return "window_left"
            case .windowLeft3:
                return "window_left"
            case .windowRight1:
                return "window_right"
            case .windowRight2:
                return "window_right"
            case .windowRight3:
                return "window_right"
            case .windowBigLeft1:
                return "window_big_left"
            case .windowBigLeft2:
                return "window_big_left"
            case .windowBigLeft3:
                return "window_big_left"
            case .windowBigRight1:
                return "window_big_right"
            case .windowBigRight2:
                return "window_big_right"
            case .windowBigRight3:
                return "window_big_right"
            case .doorBigLeft:
                return "door_big_left"
            case .doorBigRight:
                return "door_big_right"
            case .doorGarageLeft:
                return "door_garage_left"
            case .doorGarageRight:
                return "door_garage_right"
            case .doorSmallLeft1:
                return "door_small_left"
            case .doorSmallLeft2:
                return "door_small_left"
            case .doorSmallLeft3:
                return "door_small_left"
            case .doorSmallRight1:
                return "door_small_right"
            case .doorSmallRight2:
                return "door_small_right"
            case .doorSmallRight3:
                return "door_small_right"
            case .chimney1:
                return "Chimney"
            case .chimney2:
                return "Chimney"
            case .chimney3:
                return "Chimney"
            case .chimney4:
                return "Chimney"
        }
    }
    
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
                return CGPoint(x: -0.4, y: 0.3)
            case .doorSmallLeft2:
                return CGPoint(x: -0.25, y: 0.23)
            case .doorSmallLeft3:
                return CGPoint(x: -0.1, y: 0.155)
            case .doorSmallRight1:
                return CGPoint(x: 0.4, y: 0.3)
            case .doorSmallRight2:
                return CGPoint(x: 0.25, y: 0.23)
            case .doorSmallRight3:
                return CGPoint(x: 0.1, y: 0.155)
            case .chimney1:
                return CGPoint(x: 0, y: 0.75)
            case .chimney2:
                return CGPoint(x: 0, y: 1)
            case .chimney3:
                return CGPoint(x: 0.25, y: 0.88)
            case .chimney4:
                return CGPoint(x: -0.25, y: 0.88)
        }
    }
}

enum BaseSmallRelatedPositions: CustomStringConvertible {
    case windowLeft1, windowLeft2, windowLeft3, windowRight1, windowRight2, windowRight3,
    windowBigLeft1, windowBigLeft2, windowBigLeft3, windowBigRight1, windowBigRight2, windowBigRight3,
    doorBigLeft, doorBigRight,
    doorGarageLeft, doorGarageRight,
    doorSmallLeft1, doorSmallLeft2, doorSmallLeft3, doorSmallRight1, doorSmallRight2, doorSmallRight3
    
    var description: String {
        switch self {
            case .windowLeft1:
                return "window1_left"
            case .windowLeft2:
                return "window2_left"
            case .windowLeft3:
                return "window3_left"
            case .windowRight1:
                return "window1_right"
            case .windowRight2:
                return "window2_right"
            case .windowRight3:
                return "window3_right"
            case .windowBigLeft1:
                return "window1_big_left"
            case .windowBigLeft2:
                return "window2_big_left"
            case .windowBigLeft3:
                return "window3_big_left"
            case .windowBigRight1:
                return "window1_big_right"
            case .windowBigRight2:
                return "window2_big_right"
            case .windowBigRight3:
                return "window3_big_right"
            case .doorBigLeft:
                return "door_big_left"
            case .doorBigRight:
                return "door_big_right"
            case .doorGarageLeft:
                return "door_garage_left"
            case .doorGarageRight:
                return "door_garage_right"
            case .doorSmallLeft1:
                return "door1_small_left"
            case .doorSmallLeft2:
                return "door2_small_left"
            case .doorSmallLeft3:
                return "door3_small_left"
            case .doorSmallRight1:
                return "door1_small_right"
            case .doorSmallRight2:
                return "door2_small_right"
            case .doorSmallRight3:
                return "door3_small_right"
        }
    }
    
    var image: String {
        switch self {
            case .windowLeft1:
                return "window_left"
            case .windowLeft2:
                return "window_left"
            case .windowLeft3:
                return "window_left"
            case .windowRight1:
                return "window_right"
            case .windowRight2:
                return "window_right"
            case .windowRight3:
                return "window_right"
            case .windowBigLeft1:
                return "window_big_left"
            case .windowBigLeft2:
                return "window_big_left"
            case .windowBigLeft3:
                return "window_big_left"
            case .windowBigRight1:
                return "window_big_right"
            case .windowBigRight2:
                return "window_big_right"
            case .windowBigRight3:
                return "window_big_right"
            case .doorBigLeft:
                return "door_big_left"
            case .doorBigRight:
                return "door_big_right"
            case .doorGarageLeft:
                return "door_garage_left"
            case .doorGarageRight:
                return "door_garage_right"
            case .doorSmallLeft1:
                return "door_small_left"
            case .doorSmallLeft2:
                return "door_small_left"
            case .doorSmallLeft3:
                return "door_small_left"
            case .doorSmallRight1:
                return "door_small_right"
            case .doorSmallRight2:
                return "door_small_right"
            case .doorSmallRight3:
                return "door_small_right"
        }
    }
    
    var multipliersForPosition: CGPoint {
        //3 = closer to center corner , 2 = mid, 1 = far to center corner (talking about the number in the end of names)
        //positions relative to base
        switch self {
            case .windowLeft1:
                return CGPoint(x: -0.4, y: 0.42)
            case .windowLeft2:
                return CGPoint(x: -0.25, y: 0.33)
            case .windowLeft3:
                return CGPoint(x: -0.1, y: 0.24)
            case .windowRight1:
                return CGPoint(x: 0.4, y: 0.42)
            case .windowRight2:
                return CGPoint(x: 0.25, y: 0.33)
            case .windowRight3:
                return CGPoint(x: 0.1, y: 0.24)
            case .windowBigLeft1:
                return CGPoint(x: -0.4, y: 0.4)
            case .windowBigLeft2:
                return CGPoint(x: -0.25, y: 0.31)
            case .windowBigLeft3:
                return CGPoint(x: -0.1, y: 0.22)
            case .windowBigRight1:
                return CGPoint(x: 0.4, y: 0.4)
            case .windowBigRight2:
                return CGPoint(x: 0.25, y: 0.31)
            case .windowBigRight3:
                return CGPoint(x: 0.1, y: 0.22)
            case .doorBigLeft:
                return CGPoint(x: -0.25, y: 0.281)
            case .doorBigRight:
                return CGPoint(x: 0.25, y: 0.281)
            case .doorGarageLeft:
                return CGPoint(x: -0.25, y: 0.285)
            case .doorGarageRight:
                return CGPoint(x: 0.25, y: 0.285)
            case .doorSmallLeft1:
                return CGPoint(x: -0.4, y: 0.35)
            case .doorSmallLeft2:
                return CGPoint(x: -0.25, y: 0.25)
            case .doorSmallLeft3:
                return CGPoint(x: -0.1, y: 0.155)
            case .doorSmallRight1:
                return CGPoint(x: 0.4, y: 0.35)
            case .doorSmallRight2:
                return CGPoint(x: 0.25, y: 0.25)
            case .doorSmallRight3:
                return CGPoint(x: 0.1, y: 0.155)
        }
    }
}

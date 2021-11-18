//
//  functions.swift
//  Idle Factory
//
//  Created by Felipe Grosze Nipper de Oliveira on 21/10/21.
//

import Foundation
import SpriteKit
import SwiftUI

func doubleToString(value: Double) -> String {
    //convert devCoins or devCoinsPerSec to String using K, M, B, T, AA, AB...
    var str: String = ""
    var n: String = "0"
    
    if value < pow(10, 3) {
        str = ""
        n = "\(value)"
    }
    else if value < pow(10, 6) {
        str = "K"
        n = "\(value/pow(10, 3))"
    }
    else if value < pow(10, 9) {
        str = "M"
        n = "\(value/pow(10, 6))"
    }
    else if value < pow(10, 12) {
        str = "B"
        n = "\(value/pow(10, 9))"
    }
    else if value < pow(10, 15) {
        str = "T"
        n = "\(value/pow(10, 12))"
    }
    else if value < pow(10, 18) {
        str = "AA"
        n = "\(value/pow(10, 15))"
    }
    else if value < pow(10, 21) {
        str = "AB"
        n = "\(value/pow(10, 18))"
    }
    else if value < pow(10, 24) {
        str = "AC"
        n = "\(value/pow(10, 21))"
    }
    else if value < pow(10, 27) {
        str = "AD"
        n = "\(value/pow(10, 24))"
    }
    else if value < pow(10, 30) {
        str = "AE"
        n = "\(value/pow(10, 27))"
    }
    
    
    let splitedN = n.split(separator: ".")
    let nInteger: String = "\(splitedN[0])"
    var nDecimal: String = "00"
    if splitedN.count > 1  {
        nDecimal = "\(splitedN[1].prefix(2))"
    }
    return "\(nInteger).\(nDecimal)\(str)"
}

func checkMyOffers(semaphore: DispatchSemaphore){
    CKRepository.getUserId { id in
        CKRepository.getUserOffersByID(userID: id!) { offers in
            let generatorsIDs = offers.map { offer in
                offer.generatorID
            }
            CKRepository.getGeneratorsByIDs(generatorsIDs: generatorsIDs) { generators in
                guard let user = GameScene.user
                else {
                    semaphore.signal()
                    return
                }
                let myGeneratorsIDs = user.generators.map { generator in
                    generator.id
                }
                var generatorsToDelete: [Factory] = []
                for generator in generators {
                    for offer in offers {
                        if generator.id == offer.generatorID {
                            if offer.buyerID != "none" {
                                if myGeneratorsIDs.contains(generator.id) {
                                    generatorsToDelete.append(generator)
                                }
                            }
                        }
                    }
                }
                for g in generatorsToDelete {
                    removeGenerator(generator: g)
                }
                semaphore.signal()
            }
        }
    }
}

func removeGenerator(generator: Factory) {
    var i = 0
    for j in 0..<GameScene.user!.generators.count {
        if GameScene.user!.generators[j].id == generator.id {
            i = j
        }
    }
    GameScene.user!.generators.remove(at: i)
}

func doubleToStringAsInt(value: Double) -> String {
    //convert devCoins or devCoinsPerSec to String using K, M, B, T, AA, AB...
    var str: String = ""
    var n: String = "0"
    
    if value < pow(10, 3) {
        str = ""
        n = "\(value)"
    }
    else if value < pow(10, 6) {
        str = "K"
        n = "\(value/pow(10, 3))"
    }
    else if value < pow(10, 9) {
        str = "M"
        n = "\(value/pow(10, 6))"
    }
    else if value < pow(10, 12) {
        str = "B"
        n = "\(value/pow(10, 9))"
    }
    else if value < pow(10, 15) {
        str = "T"
        n = "\(value/pow(10, 12))"
    }
    else if value < pow(10, 18) {
        str = "AA"
        n = "\(value/pow(10, 15))"
    }
    else if value < pow(10, 21) {
        str = "AB"
        n = "\(value/pow(10, 18))"
    }
    else if value < pow(10, 24) {
        str = "AC"
        n = "\(value/pow(10, 21))"
    }
    else if value < pow(10, 27) {
        str = "AD"
        n = "\(value/pow(10, 24))"
    }
    else if value < pow(10, 30) {
        str = "AE"
        n = "\(value/pow(10, 27))"
    }
    
    
    let splitedN = n.split(separator: ".")
    let nInteger: String = "\(splitedN[0])"
    var nDecimal: String = "00"
    if splitedN.count > 1  {
        nDecimal = "\(splitedN[1].prefix(2))"
    }
    return "\(nInteger)\(str)"
}

func getResourceImageName(resource: ResourceType) -> String{
    switch resource {
    case .computer:
        return "laptopcomputer"
    case .tablet:
        return "apps.ipad.landscape"
    case .smartphone:
        return "apps.iphone"
    case .smartTV:
        return "4k.tv"
    case .headphone:
        return "airpods"
    }
    
}

func getUserGeneratorOffers() -> [Factory] {
    return GameScene.user!.generators.filter { factory in
        factory.isOffer == .yes
    }
}

func getUserInventory() -> [Factory] {
    return GameScene.user!.generators.filter { factory in
        factory.isOffer == .no && factory.isActive == .no
    }
}

func createBasicFactory(resourceTypeArray: [ResourceType]) -> Factory {
    
    var resourceArray: [Resource] = []
    
    var shuffledArray: [ResourceType] = []
    
    for n in 0..<resourceTypeArray.count {
        shuffledArray.append(resourceTypeArray[n])
    }
    shuffledArray.shuffle()
    
    let maxInt = min(resourceTypeArray.count+1,4)
    var basicQtd = Int.random(in: 5..<8)
    let generatorQtd = Int.random(in: 1..<maxInt)
    var value = 0
    var generatorsLeft = generatorQtd
    for n in 0..<generatorQtd {
        let qttPLevel1 = Double(Int.random(in: 1..<5))
        if(generatorsLeft == 1){
            value = basicQtd
        }
        else {
            value = Int.random(in: 1..<(basicQtd - generatorsLeft))
            generatorsLeft -= 1
        }
        basicQtd -= value
        let levelAux1 = 1
        let levelAux2 = Int.random(in: 1..<4)
        let levelAux4 = Int.random(in: 1..<21)
        let levelAux5 = Int.random(in: 1..<31)
        let levelAux3 = [levelAux1,levelAux2,levelAux4,levelAux5]
        let level = levelAux3[Int.random(in: 0..<4)]
        let tax = 1.3
        resourceArray.append(Resource(basePrice: (Double(value) * qttPLevel1 * 100), baseQtt: Double(value), currentLevel: level, qttPLevel: qttPLevel1, type: shuffledArray[n], pricePLevelIncreaseTax: tax, generatorType: .Basic))
    }
    var aux = 0
    var media = 0.0
    var txtName = ""
    for n in 0..<resourceArray.count{
        aux += resourceArray[n].currentLevel
    }
    media = Double(aux)/Double(resourceArray.count)
    
    if media == 100{
        txtName = "Basic_Factory_level_6"
    }
    else if media >= 80{
        txtName = "Basic_Factory_level_5"
    }
    else if media >= 60{
        txtName = "Basic_Factory_level_4"
    }
    else if media >= 40{
        txtName = "Basic_Factory_level_3"
    }
    else if media >= 20{
        txtName = "Basic_Factory_level_2"
    }
    else {
        txtName = "Basic_Factory_level_1"
    }
    
    let factory = Factory(resourcesArray: resourceArray, energy: Int.random(in: 1..<10), type: FactoryType.Basic, texture: txtName, position: GeneratorPositions.none, isActive: IsActive.no, isOffer: IsOffer.no, userID: "")
    return factory
}

func createNFTFactory(resourceTypeArray: [ResourceType]) -> Factory {
    
    var resourceArray: [Resource] = []
    
    var shuffledArray: [ResourceType] = []
    
    for n in 0..<resourceTypeArray.count {
        shuffledArray.append(resourceTypeArray[n])
    }
    shuffledArray.shuffle()
    
    
    let maxInt = min(resourceTypeArray.count+1,4)
    var basicQtd = Int.random(in: 250..<500)
    let generatorQtd = Int.random(in: 1..<maxInt)
    var value = 0
    var generatorsLeft = generatorQtd
    for n in 0..<generatorQtd {
        let qttPLevel1 = Double(Int.random(in: 5..<15))
        if(generatorsLeft == 1){
            value = basicQtd
        }
        else {
            value = Int.random(in: 1..<(basicQtd - generatorsLeft))
            generatorsLeft -= 1
        }
        basicQtd -= value
        let tax = 1.5
        resourceArray.append(Resource(basePrice: (Double(value) * qttPLevel1), baseQtt: Double(value), currentLevel: 0, qttPLevel: qttPLevel1, type: shuffledArray[n], pricePLevelIncreaseTax: tax, generatorType: .NFT))
    }
    
    let factory = Factory(resourcesArray: resourceArray, energy: Int.random(in: 5..<15), type: FactoryType.NFT, position: GeneratorPositions.none, isActive: IsActive.no, isOffer: IsOffer.no, userID: "")
    return factory
}

func getTime( completionHandler: @escaping (DateApi?) -> Void){
    let urlString = "https://worldtimeapi.org/api/timezone/Europe/London"
    let url = URL(string: urlString)!
    
    //var movies:[Movie] = []
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        //typealias AuxMovies = [String: Any]
        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
              let dictionary = json as? [String: Any]
        else {
            completionHandler(nil)
            return
        }
        //var movie = Movie()
        guard let abbreviation = dictionary["abbreviation"] as? String,
              let datetime = dictionary["datetime"] as? String,
              let dayOfWeek = dictionary["day_of_week"] as? Int,
              let dayOfYear = dictionary["day_of_year"] as? Int,
              let dst = dictionary["dst"] as? Bool,
              let dst_from = dictionary["dst_from"] as? String,
              let dst_offset = dictionary["dst_offset"] as? Int,
              let dst_until = dictionary["dst_until"] as? String,
              let raw_offset = dictionary["raw_offset"] as? Int,
              let timezone = dictionary["timezone"] as? String,
              let unixtime = dictionary["unixtime"] as? Int,
              let utc_datetime = dictionary["utc_datetime"] as? String,
              let utc_offset = dictionary["utc_offset"] as? String,
              let week_number = dictionary["week_number"] as? Int
        else {
            completionHandler(nil)
            return
        }
        completionHandler(DateApi(abbreviation: abbreviation, datetime: datetime, dayOfWeek: dayOfWeek, dayOfYear: dayOfYear, dst: dst, dst_from: dst_from, dst_offset: dst_offset, dst_until: dst_until, raw_offset: raw_offset, timezone: timezone, unixtime:unixtime, utc_datetime: utc_datetime, utc_offset: utc_offset, week_number: week_number))
    }
    .resume()
}


func calculateCurrencyAway() -> Double{
    
    let gameSave = GameSave()
    
    if let timeAway = gameSave.getTimeAway() {
        if var generators = GameScene.user?.generators {
            var perSecTotal: Double = 0.0
            for n in 0..<generators.count {
                if(generators[n].isActive == IsActive.yes){
                    let perSec : Double = generators[n].getCurrencyPerSec()
                    perSecTotal += perSec
                }
            }
            return perSecTotal * timeAway * 0.05
        }
    }
    return 0.0
}

func calculateQuickSell(factory: Factory) -> Double {
    var earnings: Double = 0
    
    let resources = factory.resourcesArray
    for i in 0..<resources.count {
        earnings += resources[i].currentPrice
    }
    
    return earnings / 2
}

func changeAllNodeFamilyNames(node: SKNode, name: String) {
    node.name = name
    for child in node.children {
        changeAllNodeFamilyNames(node: child, name: name)
    }
}

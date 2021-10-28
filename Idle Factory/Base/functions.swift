//
//  functions.swift
//  Idle Factory
//
//  Created by Felipe Grosze Nipper de Oliveira on 21/10/21.
//

import Foundation

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


func createBasicFactory(resourceTypeArray: [ResourceType]) -> Factory {
    
    var resourceArray: [Resource] = []
   
    var shuffledArray: [ResourceType] = []
    
    for n in 0..<resourceTypeArray.count {
        shuffledArray.append(resourceTypeArray[n])
    }
    shuffledArray.shuffle()
    
    
    let maxInt = min(resourceTypeArray.count+1,4)
    for n in 0..<Int.random(in: 1..<maxInt) {
        resourceArray.append(Resource(basePrice: 0, baseQtt: Double.random(in: 1..<15), currentLevel: 1, qttPLevel: Double.random(in: 5..<15), type: shuffledArray[n], pricePLevelIncreaseTax: Double.random(in: 100..<1500)))
    }
    
    let factory = Factory(resourcesArray: resourceArray, energy: Int.random(in: 1..<10), type: FactoryType.Basic, texture: "", position: GeneratorPositions.none, isActive: IsActive.no)
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
    for n in 0..<Int.random(in: 1..<maxInt) {
        resourceArray.append(Resource(basePrice: 0, baseQtt: Double.random(in: 15..<25), currentLevel: 1, qttPLevel: Double.random(in: 15..<25), type: shuffledArray[n], pricePLevelIncreaseTax: Double.random(in: 1500..<15000)))
    }
    
    let factory = Factory(resourcesArray: resourceArray, energy: Int.random(in: 5..<15), type: FactoryType.NFT, texture: "", position: GeneratorPositions.none, isActive: IsActive.no)
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
        print(datetime)
        completionHandler(DateApi(abbreviation: abbreviation, datetime: datetime, dayOfWeek: dayOfWeek, dayOfYear: dayOfYear, dst: dst, dst_from: dst_from, dst_offset: dst_offset, dst_until: dst_until, raw_offset: raw_offset, timezone: timezone, unixtime:unixtime, utc_datetime: utc_datetime, utc_offset: utc_offset, week_number: week_number))
        }
    .resume()
}

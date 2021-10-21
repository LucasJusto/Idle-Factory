//
//  GameSave.swift
//  Idle Factory
//
//  Created by Felipe Grosze Nipper de Oliveira on 20/10/21.
//

import Foundation
class GameSave{
    private enum TypeStore: String {
            case timeLeft
        }
        
        let userDefaults = UserDefaults.standard
        
        func setValue(value: Any = 0, label: String) {
            
            userDefaults.setValue(value, forKey: label)
        }
        
        func getValue(label: String) -> Any {
            
            if let valueGetter = userDefaults.value(forKey: label) as Any? {
                return unwrap(any: valueGetter)
            }
            return 0
        }
        
        func saveTimeLeftApp() {
            getTime { time in
                var date = Date()
                if let time = time {
                    let isoDate = time.datetime
                    print(isoDate)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    date = dateFormatter.date(from:isoDate)!
                    print(date)
                }
                self.userDefaults.setValue(date, forKey: TypeStore.timeLeft.rawValue)
            }
           
        }
        
        func getTimeLeftApp() -> Any {
            return unwrap(any: userDefaults.value(forKey: TypeStore.timeLeft.rawValue) ?? 0)
        }
        
        func getTimeAway() -> Double? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let stringDate: String = "\(getTimeLeftApp())"
            guard let convertedTimeAway: Date = dateFormatter.date(from: stringDate) else {
                return nil
            }
            let result: Double = Double((Calendar.current.dateComponents([.second], from: convertedTimeAway, to: Date()).second ?? 0)) - Double((Calendar.current.dateComponents([.second], from: Date(), to: Date()).second ?? 0))
            return result
            
        }
        
        func unwrap(any: Any) -> Any {
            
            let mi = Mirror(reflecting: any)
            if mi.displayStyle != .optional {
                return any
            }
            
            if mi.children.count == 0 { return NSNull() }
            let (_, some) = mi.children.first!
            return some
            
        }
}

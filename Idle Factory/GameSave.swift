//
//  GameSave.swift
//  Idle Factory
//
//  Created by Felipe Grosze Nipper de Oliveira on 20/10/21.
//

import Foundation

struct Time{
    let hour: Int
    let minute: Int
    let second: Int
    let year: Int
    let month: Int
    let day: Int
}

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
    
    func getCurrentTime() -> Time{
        
        let date = Date()
        var calendar = Calendar.current
        
        if let timeZone = TimeZone(identifier: "EST") {
            calendar.timeZone = timeZone
        }
        
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        return Time.init(hour: hour, minute: minute, second: second, year: year, month: month, day: day)
    }
    func saveTimeLeftApp() {
        userDefaults.setValue(getCurrentTime, forKey: TypeStore.timeLeft.rawValue)
        let t = userDefaults.value(forKey: TypeStore.timeLeft.rawValue) as? Time
    }
    func getTimeLeftApp() -> Any {
        return unwrap(any: userDefaults.value(forKey: TypeStore.timeLeft.rawValue) ?? 0)
    }
    
    func getTimeAway() -> Double? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
//        let stringDate: String = "\(getTimeLeftApp())"
//        guard let convertedTimeAway: Date = dateFormatter.date(from: stringDate) else {
//            return nil
//        }
//        let result: Double = Double((Calendar.current.dateComponents([.second], from: convertedTimeAway, to: Date()).second ?? 0)) - Double((Calendar.current.dateComponents([.second], from: Date(), to: Date()).second ?? 0))
//        return result
        let i = userDefaults.value(forKey: TypeStore.timeLeft.rawValue) as? Time
        let f = getCurrentTime()

        //MARK: Initial time do sec
        let year = ((i!.year) * 31536000)
        let month = (Double(i!.month) * (2628002.88))
        let day = ((i!.year) * 86400)
        let hour = ((i!.hour) * 3600)
        let minute = ((i!.minute) * 60)
        let sec = (i!.second)
        let initialTotal = Double(year + month + day + hour + minute + sec)

        //MARK: Final time do sec
        let finalYear = ((f.year) * 31536000)
        let FinalMonth = (Double(f.month) * (2628002.88))
        let finalDay = ((f.year) * 86400)
        let finalHour = ((f.hour) * 3600)
        let finalMinute = ((f.minute) * 60)
        let finalSec = (f.second)
        let finalTotal = Double(finalYear + FinalMonth + finalDay + finalHour + finalMinute + finalSec)
        
        let diference = finalTotal - initialTotal
        
        var result = 0
        if diference > 604800{
            result = 604800
        }else{
            result = diference
        }
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

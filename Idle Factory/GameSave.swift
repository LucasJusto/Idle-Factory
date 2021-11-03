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
    func transformToSeconds(time: Time) -> Double{
        let year = ((time.year) * 31536000)
        let month = (Double(time.month) * (2628002.88))
        let day = ((time.year) * 86400)
        let hour = ((time.hour) * 3600)
        let minute = ((time.minute) * 60)
        let sec = (time.second)
        
        let initialTotal: Double = Double(year + Int(month) + day + hour + minute + sec)
        
        return initialTotal
    }
    
//    func saveTimeLeftApp() {
//        let total = transformToSeconds(time: getCurrentTime())
//        CKRepository.getUserId { id in
//            if let id = id {
//                CKRepository.storeUserData(id: id, name: GameScene.user?.name, mainCurrency: GameScene.user?.mainCurrency, premiumCurrency: GameScene.user?.premiumCurrency, timeLeftApp: total)
//            }
//        }
////        userDefaults.setValue(getCurrentTime, forKey: TypeStore.timeLeft.rawValue)
////        let t = userDefaults.value(forKey: TypeStore.timeLeft.rawValue) as? Time
//    }
//    func getTimeLeftApp() -> Any {
//        return unwrap(any: userDefaults.value(forKey: TypeStore.timeLeft.rawValue) ?? 0)
//    }
    
    func getTimeAway() -> Double? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
//        let stringDate: String = "\(getTimeLeftApp())"
//        guard let convertedTimeAway: Date = dateFormatter.date(from: stringDate) else {
//            return nil
//        }
//        let result: Double = Double((Calendar.current.dateComponents([.second], from: convertedTimeAway, to: Date()).second ?? 0)) - Double((Calendar.current.dateComponents([.second], from: Date(), to: Date()).second ?? 0))
//        return result
        let semaphore = DispatchSemaphore(value: 0)
        var i: Double = 0.0
        let f = transformToSeconds(time: getCurrentTime())
        CKRepository.getUserId { id in
            if let id = id{
                CKRepository.getUserById(id: id) { user in
                    i = user?.timeLeftApp ?? 0
                    semaphore.signal()
                }
            }
        }
        semaphore.wait()
        
        print(i)
        print(f)
        
        let diference = f - i
        
        var result = 0.0
        if diference > 86400{
            result = Double(86400)
        }else{
            result = Double(diference)
        }
        if result < 0 {
            result = 1
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

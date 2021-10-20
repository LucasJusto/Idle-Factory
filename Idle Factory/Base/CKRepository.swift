//
//  CKRepository.swift
//  Idle Factory
//
//  Created by Lucas Dimer Justo on 15/10/21.
//

import CloudKit
import UIKit

public class CKRepository {
    
    static let container: CKContainer = CKContainer(identifier: "iCloud.LucasJusto.Idle-Factory")
    static let publicDB = container.publicCloudDatabase
    static var currentUserID: String?
    
    public static func getUserId(completion: @escaping (String?) -> Void) {
        if let currentUserIDNotNull = CKRepository.currentUserID {
            completion(currentUserIDNotNull)
            return
        }
        else {
            container.fetchUserRecordID { record, error in
                if let ckError = error as? CKError {
                    CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
                }
                if let id = record?.recordName {
                    currentUserID = id
                    completion(id)
                }
            }
        }
    }
    
    public static func storeUserData(id: String, name: String, mainCurrency: Double, premiumCurrency: Double, completion: @escaping (CKRecord?, Error?) -> Void){
        
        let recordID = CKRecord.ID(recordName: id)
        let publicDB = container.publicCloudDatabase
        
        publicDB.fetch(withRecordID: recordID) { userOptional, error in
            if let ckError = error as? CKError {
                CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
            }
            
            if let userNotNull = userOptional {
                userNotNull.setObject(name as CKRecordValue?, forKey: UsersTable.name.description)
                userNotNull.setObject(mainCurrency as CKRecordValue?, forKey: UsersTable.mainCurrency.description)
                userNotNull.setObject(premiumCurrency as CKRecordValue?, forKey: UsersTable.premiumCurrency.description)
                
                publicDB.save(userNotNull) { savedRecord, error in
                    if let ckError = error as? CKError {
                        CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
                    }
                    completion(savedRecord, error)
                }
            }
        }
    }
    
    static func getUserById(id: String, completion: @escaping (User?) -> Void) {
        let recordID = CKRecord.ID(recordName: id)
        let publicDB = container.publicCloudDatabase
        
        publicDB.fetch(withRecordID: recordID) { userOptional, error in
            if let userNotNull = userOptional {
                let name = userNotNull.value(forKey: UsersTable.name.description) as? String
                let mainCurrency = userNotNull.value(forKey: UsersTable.mainCurrency.description) as? Double
                let premiumCurrency = userNotNull.value(forKey: UsersTable.premiumCurrency.description) as? Double
                
                let user = User(id: id, name: name ?? "", mainCurrency: mainCurrency ?? 0, premiumCurrency: premiumCurrency ?? 0)
                completion(user)
            }
        }
    }
    
    static func storeGenerator(userID: String, generator: Factory ,completion: @escaping (CKRecord?, Error?) -> Void) {
        let record = CKRecord(recordType: GeneratorTable.recordType.description)
        let publicDB = container.publicCloudDatabase
        
        record.setObject(userID as CKRecordValue?, forKey: GeneratorTable.userID.description)
        record.setObject(generator.energy as CKRecordValue?, forKey: GeneratorTable.energy.description)
        record.setObject(generator.position.key as CKRecordValue?, forKey: GeneratorTable.position.description)
        record.setObject(generator.isActive.key as CKRecordValue?, forKey: GeneratorTable.isActive.description)
        record.setObject(generator.type.key as CKRecordValue?, forKey: GeneratorTable.type.description)
        
        publicDB.save(record) { savedRecord, error in
            if let ckError = error as? CKError {
                CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
            }
            completion(savedRecord, error)
        }
    }
    
    static func errorAlertHandler(CKErrorCode: CKError.Code){
        
        let notLoggedInTitle = NSLocalizedString("CKErrorNotLoggedInTitle", comment: "Not logged in iCloud")
        let notLoggedInMessage = NSLocalizedString("CKErrorNotLoggedInMessage", comment: "You need to be logged in iCloud to use this app.")
        
        let defaultTitle = NSLocalizedString("CKErrorDefaultTitle", comment: "An error ocurred")
        let defaultMessage = NSLocalizedString("CKErrorDefaultMessage", comment: "Something unexpected ocurred, your data may not have been saved.")
        
        //getting the top view controller
        DispatchQueue.main.async {
            let keyWindow = UIApplication.shared.windows.first(where: \.isKeyWindow)
            var topController = keyWindow?.rootViewController
            
            // get topmost view controller to present alert
            while let presentedViewController = topController?.presentedViewController {
                topController = presentedViewController
            }
            
            let isAlertOn = topController is UIAlertController
            
            guard !isAlertOn else { return }
            
            switch CKErrorCode {
                case .notAuthenticated:
                    //user is not logged in iCloud
                    topController?.present(prepareAlert(title: notLoggedInTitle, message: notLoggedInMessage), animated: true)
                default:
                    topController?.present(prepareAlert(title: defaultTitle, message: defaultMessage), animated: true)
            }
        }
    }
    
    private static func prepareAlert(title: String, message: String) -> UIAlertController{
        let alertButtonLabel = NSLocalizedString("CKErrorAlertButtonLabel", comment: "Ok")
        
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: alertButtonLabel, style: .default, handler: { (action) -> Void in
            //make things when alert button is clicked
        })
        
        dialogMessage.addAction(ok)
        
        return dialogMessage
    }
    
}

enum UsersTable: CustomStringConvertible {
    case recordType, name, mainCurrency, premiumCurrency
    
    var description: String {
        switch self {
            case .recordType:
                return "Users"
            case .name:
                return "name"
            case .mainCurrency:
                return "mainCurrency"
            case .premiumCurrency:
                return "premiumCurrency"
        }
    }
}

enum ResourceTable: CustomStringConvertible {
    case recordType, basePrice, baseQtt, level, qttPLevel, type
    
    var description: String {
        switch self {
            case .recordType:
                return "Resource"
            case .basePrice:
                return "basePrice"
            case . baseQtt:
                return "baseQtt"
            case .level:
                return "level"
            case .qttPLevel:
                return "qttPLevel"
            case .type:
                return "type"
        }
    }
}

enum MarketTable: CustomStringConvertible {
    case recordType, buyerRef, currencyType, generatorRef, price, sellerRef
    
    var description: String {
        switch self {
            case .recordType:
                return "Market"
            case .buyerRef:
                return "buyerRef"
            case . currencyType:
                return "currencyType"
            case .generatorRef:
                return "generatorRef"
            case .price:
                return "price"
            case .sellerRef:
                return "sellerRef"
        }
    }
}

enum GeneratorTable: CustomStringConvertible {
    case recordType, energy, isActive, type, userID, position
    
    var description: String {
        switch self {
            case .recordType:
                return "Generator"
            case .energy:
                return "energy"
            case .isActive:
                return "isActive"
            case .type:
                return "type"
            case .userID:
                return "userID"
            case .position:
                return "position"
        }
    }
}

enum ChallengeEntryTable: CustomStringConvertible {
    case recordType, generators, userRef
    
    var description: String {
        switch self {
            case .recordType:
                return "ChallengeEntry"
            case .generators:
                return "generators"
            case . userRef:
                return "userRef"
        }
    }
}

enum ChallengeTable: CustomStringConvertible {
    case recordType, endDate, maxEnergy, resourcesQtt, resourcesType, usersEntries
    
    var description: String {
        switch self {
            case .recordType:
                return "Challenge"
            case .endDate:
                return "endDate"
            case . maxEnergy:
                return "maxEnergy"
            case .resourcesQtt:
                return "resourcesQtt"
            case .resourcesType:
                return "resourcesType"
            case .usersEntries:
                return "usersEntries"
        }
    }
}

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
    
    public static func storeUserData(id: String, name: String, mainCurrency: Double, premiumCurrency: Double, completion: ((CKRecord?, Error?) -> Void)? = nil){
        
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
                    if let completion = completion {
                        completion(savedRecord, error)
                    }
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
    
    static func refreshCurrentUser(completion: @escaping (User?) -> Void) {
        var user: User? = nil
        let semaphore = DispatchSemaphore(value: 0)
        
        CKRepository.getUserId { userID in
            if let userID = userID {
                CKRepository.getUserById(id: userID) { user2 in
                    if let user2 = user2 {
                        user = user2
                        semaphore.signal()
                    }
                }
            }
        }
        
        semaphore.wait()
        CKRepository.getUserId { userID in
            if let userID = userID {
                CKRepository.getUserGeneratorsByID(userID: userID) { generators in
                    if let user = user {
                        user.generators = generators
                        semaphore.signal()
                    }
                }
            }
        }
        semaphore.wait()
        completion(user)
    }
    
    static func getUserGeneratorsByID(userID: String, completion: @escaping ([Factory]) -> Void) {
        let publicDB = container.publicCloudDatabase
        var generators: [Factory] = []
        let semaphore = DispatchSemaphore(value: 0)
        
        let generatorsPredicate = NSPredicate(format: "\(GeneratorTable.userID.description) == %@", userID)
        let generatorsQuery = CKQuery(recordType: GeneratorTable.recordType.description, predicate: generatorsPredicate)
        publicDB.perform(generatorsQuery, inZoneWith: nil) { results, error in
            if let ckError = error as? CKError {
                CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
            }
            if let generatorsNotNull = results {
                for generator in generatorsNotNull {
                    let id: String = generator.recordID.recordName
                    var resources: [Resource] = []
                    let energy: Int = generator.value(forKey: GeneratorTable.energy.description) as? Int ?? 0
                    let typeString: String = generator.value(forKey: GeneratorTable.type.description) as? String ?? ""
                    let type: FactoryType = FactoryType.getFactoryType(factoryType: typeString)
                    let positionString: String = generator.value(forKey: GeneratorTable.position.description) as? String ?? ""
                    let position: GeneratorPositions = GeneratorPositions.getGeneratorPositions(position: positionString)
                    let isActiveString: String = generator.value(forKey: GeneratorTable.isActive.description) as? String ?? ""
                    let isActive: IsActive = IsActive.getKey(isActive: isActiveString)
                    let texture: String = generator.value(forKey: GeneratorTable.texture.description) as? String ?? ""
                    
                    let resourcesPredicate = NSPredicate(format: "\(ResourceTable.generatorID.description) == %@", id)
                    let resourcesQuery = CKQuery(recordType: ResourceTable.recordType.description, predicate: resourcesPredicate)
                    
                    publicDB.perform(resourcesQuery, inZoneWith: nil) { results2, error in
                        if let resourcesNotNull = results2 {
                            for resource in resourcesNotNull {
                                let rID: String = resource.recordID.recordName
                                let basePrice: Double = resource.value(forKey: ResourceTable.basePrice.description) as? Double ?? 0
                                let baseQtt: Double = resource.value(forKey: ResourceTable.baseQtt.description) as? Double ?? 0
                                let currentLevel: Int = resource.value(forKey: ResourceTable.level.description) as? Int ?? 0
                                let qttPLevel: Double = resource.value(forKey: ResourceTable.qttPLevel.description) as? Double ?? 0
                                let typeString2: String = resource.value(forKey: ResourceTable.type.description) as? String ?? ""
                                let type: ResourceType = ResourceType.getKey(key: typeString2)
                                let pricePLevelIncreaseTax: Double = resource.value(forKey: ResourceTable.pricePLevelIncreaseTax.description) as? Double ?? 0
                                
                                let r = Resource(id: rID, basePrice: basePrice, baseQtt: baseQtt, currentLevel: currentLevel, qttPLevel: qttPLevel, type: type, pricePLevelIncreaseTax: pricePLevelIncreaseTax)
                                resources.append(r)
                                semaphore.signal()
                            }
                        }
                    }
                    
                    semaphore.wait()
                    let factory = Factory(id: id, resourcesArray: resources, energy: energy, type: type, texture: texture, position: position, isActive: isActive)
                    generators.append(factory)
                }
            }
            completion(generators)
        }
    }
    
    static func storeNewGenerator(userID: String, generator: Factory, completion: ((CKRecord?, Error?) -> Void)? = nil) {
        let record = CKRecord(recordType: GeneratorTable.recordType.description)
        let publicDB = container.publicCloudDatabase
        
        record.setObject(userID as CKRecordValue?, forKey: GeneratorTable.userID.description)
        record.setObject(generator.energy as CKRecordValue?, forKey: GeneratorTable.energy.description)
        record.setObject(generator.position.key as CKRecordValue?, forKey: GeneratorTable.position.description)
        record.setObject(generator.isActive.key as CKRecordValue?, forKey: GeneratorTable.isActive.description)
        record.setObject(generator.type.key as CKRecordValue?, forKey: GeneratorTable.type.description)
        record.setObject(generator.textureName as CKRecordValue?, forKey: GeneratorTable.texture.description)
        
        publicDB.save(record) { savedRecord, error in
            if let ckError = error as? CKError {
                CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
            }
            if let savedRecordNotNull = savedRecord {
                storeResources(generatorID: savedRecordNotNull.recordID.recordName, resources: generator.resourcesArray) { _, error in
                    if let ckError = error as? CKError {
                        CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
                    }
                }
            }
            if let completion = completion {
                completion(savedRecord, error)
            }
            
        }
    }
    
    static func editGenerators(userID: String, generators: [Factory], completion: (([CKRecord]?, Error?) -> Void)? = nil) {
        
        let publicDB = container.publicCloudDatabase
        let records: [CKRecord] = []
        
        for factory in generators {
            let record = CKRecord(recordType: GeneratorTable.recordType.description, recordID: CKRecord.ID(recordName: factory.id ?? ""))
            
            record.setObject(userID as CKRecordValue?, forKey: GeneratorTable.userID.description)
            record.setObject(factory.energy as CKRecordValue?, forKey: GeneratorTable.energy.description)
            record.setObject(factory.position.key as CKRecordValue?, forKey: GeneratorTable.position.description)
            record.setObject(factory.isActive.key as CKRecordValue?, forKey: GeneratorTable.isActive.description)
            record.setObject(factory.type.key as CKRecordValue?, forKey: GeneratorTable.type.description)
            record.setObject(factory.textureName as CKRecordValue?, forKey: GeneratorTable.texture.description)
        }
        
        let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.modifyRecordsCompletionBlock = { savedRecords, _, error in
            if let ckError = error as? CKError {
                CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
            }
            editResources(generators: generators) { _, error in
                if let ckError = error as? CKError {
                    CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
                }
            }
            if let completion = completion {
                completion(savedRecords, error)
            }
        }
        publicDB.add(operation)
    }
    
    static func editResources(generators: [Factory], completion: (([CKRecord]?, Error?) -> Void)? = nil) {
        let publicDB = container.publicCloudDatabase
        var records: [CKRecord] = []
        
        for factory in generators {
            for resource in factory.resourcesArray {
                let record = CKRecord(recordType: ResourceTable.recordType.description, recordID: CKRecord.ID(recordName: resource.id ?? ""))
                
                record.setObject((factory.id ?? "") as CKRecordValue?, forKey: ResourceTable.generatorID.description)
                record.setObject(resource.qttPLevel as CKRecordValue?, forKey: ResourceTable.qttPLevel.description)
                record.setObject(resource.baseQtt as CKRecordValue?, forKey: ResourceTable.baseQtt.description)
                record.setObject(resource.basePrice as CKRecordValue?, forKey: ResourceTable.basePrice.description)
                record.setObject(resource.currentLevel as CKRecordValue?, forKey: ResourceTable.level.description)
                record.setObject(resource.type.key as CKRecordValue?, forKey: ResourceTable.type.description)
                
                records.append(record)
            }
        }
        
        let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.modifyRecordsCompletionBlock = { savedRecords, _, error in
            if let ckError = error as? CKError {
                CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
            }
            if let completion = completion {
                completion(savedRecords, error)
            }
        }
        publicDB.add(operation)
    }
    
    static func storeResources(generatorID: String, resources: [Resource] , completion: (([CKRecord]?, Error?) -> Void)? = nil) {
        let publicDB = container.publicCloudDatabase
        var records: [CKRecord] = []
        
        for resource in resources {
            let record = CKRecord(recordType: ResourceTable.recordType.description)
            
            record.setObject(generatorID as CKRecordValue?, forKey: ResourceTable.generatorID.description)
            record.setObject(resource.qttPLevel as CKRecordValue?, forKey: ResourceTable.qttPLevel.description)
            record.setObject(resource.baseQtt as CKRecordValue?, forKey: ResourceTable.baseQtt.description)
            record.setObject(resource.basePrice as CKRecordValue?, forKey: ResourceTable.basePrice.description)
            record.setObject(resource.currentLevel as CKRecordValue?, forKey: ResourceTable.level.description)
            record.setObject(resource.type.key as CKRecordValue?, forKey: ResourceTable.type.description)
            
            records.append(record)
        }
        
        let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.modifyRecordsCompletionBlock = { savedRecords, _, error in
            if let ckError = error as? CKError {
                CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
            }
            if let completion = completion {
                completion(savedRecords, error)
            }
        }
        publicDB.add(operation)
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
    case recordType, basePrice, baseQtt, level, qttPLevel, type, generatorID, pricePLevelIncreaseTax
    
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
            case .generatorID:
                return "generatorID"
            case .pricePLevelIncreaseTax:
                return "pricePLevelIncreaseTax"
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
    case recordType, energy, isActive, type, userID, position, texture
    
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
            case .texture:
                return "texture"
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

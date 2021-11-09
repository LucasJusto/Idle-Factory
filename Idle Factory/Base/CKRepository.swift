//
//  CKRepository.swift
//  Idle Factory
//
//  Created by Lucas Dimer Justo on 15/10/21.
//

import CloudKit
import UIKit
import SwiftUI

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
    
    static func storeUserData(id: String, name: String?, mainCurrency: Double?, premiumCurrency: Double?, timeLeftApp: Double?, completion: ((CKRecord?, Error?) -> Void)? = nil){
        
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
                userNotNull.setObject(timeLeftApp as CKRecordValue?, forKey: UsersTable.timeLeftApp.description)
                
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
        let gameSave = GameSave()
        
        publicDB.fetch(withRecordID: recordID) { userOptional, error in
            if let userNotNull = userOptional {
                let name = userNotNull.value(forKey: UsersTable.name.description) as? String
                let mainCurrency = userNotNull.value(forKey: UsersTable.mainCurrency.description) as? Double
                let premiumCurrency = userNotNull.value(forKey: UsersTable.premiumCurrency.description) as? Double
                let timeLeftApp = userNotNull.value(forKey: UsersTable.timeLeftApp.description) as? Double
                
                let user = User(id: id, name: name ?? "", mainCurrency: mainCurrency ?? 0, premiumCurrency: premiumCurrency ?? 0, timeLeftApp: timeLeftApp ?? gameSave.transformToSeconds(time: gameSave.getCurrentTime()))
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
                    var visual: Visual? = nil
                    if type == .NFT {
                        do {
                            let topColorData = generator.value(forKey: GeneratorTable.topColor.description) as? Data
                            let topColor = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(topColorData!) as? UIColor
                            let bottomColorData = generator.value(forKey: GeneratorTable.bottomColor.description) as? Data
                            let bottomColor = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(bottomColorData!) as? UIColor
                            
                            visual = Visual(bottomColor: bottomColor!, topColor: topColor!)
                            
                            let bottomString = generator.value(forKey: GeneratorTable.visualBottom.description) as? [String] ?? [""]
                            var bottomComponents: [BaseSmallRelatedPositions] = [BaseSmallRelatedPositions]()
                            for componentString in bottomString {
                                bottomComponents.append(BaseSmallRelatedPositions.getComponent(key: componentString))
                            }
                            visual?.bottom = bottomComponents
                            
                            let topString = generator.value(forKey: GeneratorTable.visualTop.description) as? [String] ?? [""]
                            var topComponents: [BaseBigRelatedPositions] = [BaseBigRelatedPositions]()
                            for componentString in topString {
                                topComponents.append(BaseBigRelatedPositions.getComponent(key: componentString))
                            }
                            visual?.top = topComponents
                        } catch {
                            print("Error unarchive")
                        }
                    }
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
                                let resourceType: ResourceType = ResourceType.getKey(key: typeString2)
                                let pricePLevelIncreaseTax: Double = resource.value(forKey: ResourceTable.pricePLevelIncreaseTax.description) as? Double ?? 0
                                
                                let r = Resource(id: rID, basePrice: basePrice, baseQtt: baseQtt, currentLevel: currentLevel, qttPLevel: qttPLevel, type: resourceType, pricePLevelIncreaseTax: pricePLevelIncreaseTax, generatorType: type)
                                resources.append(r)
                                semaphore.signal()
                            }
                        }
                    }
                    
                    semaphore.wait()
                    if visual == nil {
                        let factory = Factory(id: id, resourcesArray: resources, energy: energy, type: type, texture: texture, position: position, isActive: isActive)
                        generators.append(factory)
                    } else {
                        let factory = Factory(id: id, resourcesArray: resources, energy: energy, type: type, texture: texture, position: position, isActive: isActive, visual: visual!)
                        generators.append(factory)
                    }
                }
            }
            completion(generators)
        }
    }
    
    static func storeNewGenerator(userID: String, generator: Factory, completion: (([CKRecord?], Error?) -> Void)? = nil) {
        let record = CKRecord(recordType: GeneratorTable.recordType.description)
        let publicDB = container.publicCloudDatabase
        var records: [CKRecord?] = [CKRecord?]()
        
        record.setObject(userID as CKRecordValue?, forKey: GeneratorTable.userID.description)
        record.setObject(generator.energy as CKRecordValue?, forKey: GeneratorTable.energy.description)
        record.setObject(generator.position.key as CKRecordValue?, forKey: GeneratorTable.position.description)
        record.setObject(generator.isActive.key as CKRecordValue?, forKey: GeneratorTable.isActive.description)
        record.setObject(generator.type.key as CKRecordValue?, forKey: GeneratorTable.type.description)
        record.setObject(generator.textureName as CKRecordValue?, forKey: GeneratorTable.texture.description)
        if generator.type == .NFT {
            let bottomString = generator.visual?.bottom.map({ bottom in
                bottom.description
            })
            let topString = generator.visual?.top.map({ top in
                top.description
            })
            record.setObject(bottomString as CKRecordValue?, forKey: GeneratorTable.visualBottom.description)
            record.setObject(topString as CKRecordValue?, forKey: GeneratorTable.visualTop.description)
            do {
                let bottomColor = try NSKeyedArchiver.archivedData(withRootObject: generator.visual!.bottomColor, requiringSecureCoding: false) as NSData?
                record.setObject(bottomColor as NSData?, forKey: GeneratorTable.bottomColor.description)
                
                let topColor = try NSKeyedArchiver.archivedData(withRootObject: generator.visual!.topColor, requiringSecureCoding: false) as NSData?
                record.setObject(topColor, forKey: GeneratorTable.topColor.description)
            } catch {
                print("Error UserDefaults")
            }
        }
        
        publicDB.save(record) { savedRecord, error in
            if let ckError = error as? CKError {
                CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
            }
            if let savedRecordNotNull = savedRecord {
                records.append(savedRecordNotNull)
                storeResources(generatorID: savedRecordNotNull.recordID.recordName, resources: generator.resourcesArray) { record, error in
                    if let ckError = error as? CKError {
                        CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
                    }
                    if let recordNotNull = record {
                        for r in recordNotNull {
                            records.append(r)
                        }
                        if let completion = completion {
                            completion(records, error)
                        }
                    }
                }
            }
        }
    }
    
    static func editGenerators(userID: String, generators: [Factory], completion: (([CKRecord]?, Error?) -> Void)? = nil) {
        
        let publicDB = container.publicCloudDatabase
        var records: [CKRecord] = []
        
        for factory in generators {
            let record = CKRecord(recordType: GeneratorTable.recordType.description, recordID: CKRecord.ID(recordName: factory.id!))
            
            record.setObject(userID as CKRecordValue?, forKey: GeneratorTable.userID.description)
            record.setObject(factory.energy as CKRecordValue?, forKey: GeneratorTable.energy.description)
            record.setObject(factory.position.key as CKRecordValue?, forKey: GeneratorTable.position.description)
            record.setObject(factory.isActive.key as CKRecordValue?, forKey: GeneratorTable.isActive.description)
            record.setObject(factory.type.key as CKRecordValue?, forKey: GeneratorTable.type.description)
            record.setObject(factory.textureName as CKRecordValue?, forKey: GeneratorTable.texture.description)
            records.append(record)
        }
        
        let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.modifyRecordsCompletionBlock = { savedRecords, _, error in
            if let ckError = error as? CKError {
                CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
            } else {
                editResources(generators: generators) { _, error in
                    if let ckError = error as? CKError {
                        CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
                    } else {
                        if let completion = completion {
                            completion(savedRecords, error)
                        }
                    }
                }
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
    
    static func storeMarketPlaceOffer(sellerID: String, generatorID: String, currencyType: CurrencyType, price: Double){
        let publicDB = container.publicCloudDatabase
        let record = CKRecord(recordType: MarketTable.recordType.description)
        
        record.setObject(sellerID as CKRecordValue?, forKey: MarketTable.sellerID.description)
        record.setObject(price as CKRecordValue?, forKey: MarketTable.price.description)
        record.setObject(currencyType.key as CKRecordValue?, forKey: MarketTable.currencyType.description)
        record.setObject(generatorID as CKRecordValue?, forKey: MarketTable.generatorID.description)
        record.setObject("none" as CKRecordValue?, forKey: MarketTable.buyerID.description)
        
        publicDB.save(record) { _, error in
            if let ckError = error as? CKError {
                CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
            }
        }
    }
    
    static func getMarketPlaceOffers(completion: @escaping ([Offer]) -> Void) {
        let publicDB = container.publicCloudDatabase
        var offers: [Offer] = [Offer]()
        
        let predicate = NSPredicate(format: "\(MarketTable.buyerID.description) == %@", "none")
        let query = CKQuery(recordType: MarketTable.recordType.description, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { results, error in
            if let ckError = error as? CKError {
                CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
            }
            
            if let results = results {
                for result in results {
                    let id: String = result.recordID.recordName
                    let sellerID: String = result.value(forKey: MarketTable.sellerID.description) as! String
                    let generatorID: String = result.value(forKey: MarketTable.generatorID.description) as! String
                    let price: Double = result.value(forKey: MarketTable.price.description) as! Double
                    let currencyTypeString: String = result.value(forKey: MarketTable.currencyType.description) as! String
                    let currencyType: CurrencyType = CurrencyType.getType(key: currencyTypeString)
                    
                    offers.append(Offer(id: id, sellerID: sellerID, generatorID: generatorID, buyerID: nil, price: price, currencyType: currencyType))
                }
            }
            completion(offers)
        }
    }
    
    static func buyOfferFromMarket(sellerID: String, generatorID: String, buyerID: String) {
        let publicDB = container.publicCloudDatabase
        
        let predicate = NSPredicate(format: "\(MarketTable.sellerID.description) == '\(sellerID)' AND \(MarketTable.generatorID.description) == '\(generatorID)'")
        let query = CKQuery(recordType: MarketTable.recordType.description, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { result, error in
            if let ckError = error as? CKError {
                CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
            }
            
            if let result = result {
                let offer = result[0]
                offer.setObject(buyerID as CKRecordValue?, forKey: MarketTable.buyerID.description)
                
                publicDB.save(offer) { _, error in
                    if let ckError = error as? CKError {
                        CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
                    }
                }
            }
        }
    }
    
    static func getGeneratorsByIDs(generatorsIDs: [String], completion: @escaping ([Factory]) -> Void){
        let publicDB = container.publicCloudDatabase
        var generators: [Factory] = [Factory]()
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: GeneratorTable.recordType.description, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { results, error in
            if let ckError = error as? CKError {
                CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
            }
            
            if let results = results {
                let generators2 = results.filter { record in
                    generatorsIDs.contains(record.recordID.recordName)
                }
                let semaphore = DispatchSemaphore(value: 0)
                
                for generator in generators2 {
                    let id: String = generator.recordID.recordName
                    var resources: [Resource] = []
                    let energy: Int = generator.value(forKey: GeneratorTable.energy.description) as? Int ?? 0
                    let typeString: String = generator.value(forKey: GeneratorTable.type.description) as? String ?? ""
                    let type: FactoryType = FactoryType.getFactoryType(factoryType: typeString)
                    var visual: Visual? = nil
                    if type == .NFT {
                        do {
                            let topColorData = generator.value(forKey: GeneratorTable.topColor.description) as? Data
                            let topColor = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(topColorData!) as? UIColor
                            let bottomColorData = generator.value(forKey: GeneratorTable.bottomColor.description) as? Data
                            let bottomColor = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(bottomColorData!) as? UIColor
                            
                            visual = Visual(bottomColor: bottomColor!, topColor: topColor!)
                            
                            let bottomString = generator.value(forKey: GeneratorTable.visualBottom.description) as? [String] ?? [""]
                            var bottomComponents: [BaseSmallRelatedPositions] = [BaseSmallRelatedPositions]()
                            for componentString in bottomString {
                                bottomComponents.append(BaseSmallRelatedPositions.getComponent(key: componentString))
                            }
                            visual?.bottom = bottomComponents
                            
                            let topString = generator.value(forKey: GeneratorTable.visualTop.description) as? [String] ?? [""]
                            var topComponents: [BaseBigRelatedPositions] = [BaseBigRelatedPositions]()
                            for componentString in topString {
                                topComponents.append(BaseBigRelatedPositions.getComponent(key: componentString))
                            }
                            visual?.top = topComponents
                        } catch {
                            print("Error unarchive")
                        }
                    }
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
                                let resourceType: ResourceType = ResourceType.getKey(key: typeString2)
                                let pricePLevelIncreaseTax: Double = resource.value(forKey: ResourceTable.pricePLevelIncreaseTax.description) as? Double ?? 0
                                
                                let r = Resource(id: rID, basePrice: basePrice, baseQtt: baseQtt, currentLevel: currentLevel, qttPLevel: qttPLevel, type: resourceType, pricePLevelIncreaseTax: pricePLevelIncreaseTax, generatorType: type)
                                resources.append(r)
                                semaphore.signal()
                            }
                        }
                    }
                    
                    semaphore.wait()
                    if visual == nil {
                        let factory = Factory(id: id, resourcesArray: resources, energy: energy, type: type, texture: texture, position: position, isActive: isActive)
                        generators.append(factory)
                    } else {
                        let factory = Factory(id: id, resourcesArray: resources, energy: energy, type: type, texture: texture, position: position, isActive: isActive, visual: visual!)
                        generators.append(factory)
                    }
                }
            }
            completion(generators)
        }
    }
    
    static func deleteGeneratorByID(generatorID: String, completion: @escaping (Error?) -> Void ) {
        let publicDB = container.publicCloudDatabase
        var recordsToDelete: [CKRecord.ID] = [CKRecord.ID]()
        let recordId = CKRecord.ID(recordName: generatorID)
        
        publicDB.fetch(withRecordID: recordId) { result, error in
            if let ckError = error as? CKError {
                CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
            }
            if let result = result {
                recordsToDelete.append(result.recordID)
                
                let predicateResource = NSPredicate(format: "\(ResourceTable.generatorID.description) == %@", generatorID)
                let queryResource = CKQuery(recordType: ResourceTable.recordType.description, predicate: predicateResource)
                
                publicDB.perform(queryResource, inZoneWith: nil) { results, error in
                    if let ckError = error as? CKError {
                        CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
                    }
                    if let results = results {
                        let semaphore = DispatchSemaphore(value: results.count)
                        for r in results {
                            recordsToDelete.append(r.recordID)
                            semaphore.signal()
                        }
                        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: recordsToDelete)
                        operation.savePolicy = .changedKeys
                        operation.modifyRecordsCompletionBlock = { _, _, error in
                            if let ckError = error as? CKError {
                                CKRepository.errorAlertHandler(CKErrorCode: ckError.code)
                            }
                            completion(error)
                        }
                        semaphore.wait()
                        publicDB.add(operation)
                    }
                }
            }
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

enum CurrencyType {
    case premium, basic
    
    var key: String {
        switch self {
            case .premium:
                return "premium"
            case .basic:
                return "basic"
        }
    }
    
    static func getType(key: String) -> CurrencyType{
        switch key {
            case "premium":
                return CurrencyType.premium
            case "basic":
                return CurrencyType.basic
            default:
                return CurrencyType.basic
        }
    }
}

enum UsersTable: CustomStringConvertible {
    case recordType, name, mainCurrency, premiumCurrency, timeLeftApp
    
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
            case .timeLeftApp:
                return "timeLeftApp"
        }
    }
}

enum ResourceTable: CustomStringConvertible {
    case recordType, basePrice, baseQtt, level, qttPLevel, type, generatorID, pricePLevelIncreaseTax, recordName
    
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
            case .recordName:
                return "recordName"
        }
    }
}

enum MarketTable: CustomStringConvertible {
    case recordType, buyerID, currencyType, generatorID, price, sellerID
    
    var description: String {
        switch self {
            case .recordType:
                return "Market"
            case .buyerID:
                return "buyerID"
            case . currencyType:
                return "currencyType"
            case .generatorID:
                return "generatorID"
            case .price:
                return "price"
            case .sellerID:
                return "sellerID"
        }
    }
}

enum GeneratorTable: CustomStringConvertible {
    case recordType, energy, isActive, type, userID, position, texture, visualBottom, visualTop, bottomColor, topColor, recordName
    
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
            case .visualBottom:
                return "visualBottom"
            case .visualTop:
                return "visualTop"
            case .bottomColor:
                return "bottomColor"
            case .topColor:
                return "topColor"
            case .recordName:
                return "recordName"
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

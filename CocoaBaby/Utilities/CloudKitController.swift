//
//  CloudKitController.swift
//  CocoaBaby
//
//  Created by Sohn on 09/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit
import CloudKit

enum CloudKitFetchType: String {
    case diary = "Diary"
}

enum CloudKitZoneName: String {
    case diary = "diaryZone"
}

class CloudKitController {
    
    static let shared = CloudKitController()
    
    var container = CKContainer.default()
    
    var publicDatabase: CKDatabase {
        return container.publicCloudDatabase
    }
    
    var privateDatabase: CKDatabase {
        return container.privateCloudDatabase
    }
    
    var sharedDatabase: CKDatabase {
        let database = container.sharedCloudDatabase
        return database
    }
    
    var targetDatabase: CKDatabase {
        return privateDatabase
    }
    
    let diaryRecordID = CKRecordID(recordName: "114")
    let diaryZoneOwnerID = "_ddd57ebe59df8c2acd843a09cf1cc570"
    
    func saveRecord(text: String) {
        let diaryRecord = CKRecord(recordType: CloudKitFetchType.diary.rawValue, zoneID: CKRecordZoneID(zoneName: "diaryZone", ownerName: diaryZoneOwnerID))

        diaryRecord["text"] = text as NSString
        diaryRecord["year"] = 2017 as CKRecordValue
        diaryRecord["month"] = 8 as CKRecordValue
        diaryRecord["day"] = 9 as CKRecordValue
        
        targetDatabase.save(diaryRecord) { (record, error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    func fetchRecord() {
        publicDatabase.fetch(withRecordID: diaryRecordID) { (record, error) in
            if let error = error {
                print(error)
            }
        }
        
        let ownerID: String = "_ddd57ebe59df8c2acd843a09cf1cc570"
        
        publicDatabase.fetch(withRecordZoneID: CKRecordZoneID(zoneName: CKRecordZoneDefaultName, ownerName: ownerID)) { (recordZone, error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    func fetchRecords(type: CloudKitFetchType, completion: @escaping ([CKDiary]) -> ()) {
        let predicate = NSPredicate(format: "year == 2017")
        let query = CKQuery(recordType: type.rawValue, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        let ownerID: String = "_ddd57ebe59df8c2acd843a09cf1cc570"
        let recordZoneID = CKRecordZoneID(zoneName: CloudKitZoneName.diary.rawValue, ownerName: ownerID)
        
        operation.zoneID = recordZoneID
        
        var result: [CKDiary] = [CKDiary]()
        
        operation.recordFetchedBlock = { record in
            result.append(self.diary(from: record))
        }
        
        operation.queryCompletionBlock = { (cursur, error) in
            completion(result)
        }
        
        targetDatabase.add(operation)
    }
    
    private func diary(from record: CKRecord) -> CKDiary {
        let diary = CKDiary()
        
        if let year = record["year"] {
            diary.year = year as! Int
        }
        
        diary.month = record["month"] as! Int
        diary.day = record["day"] as! Int
        diary.text = record["text"] as! String
        
        return diary
    }
    
    func shareData(completion: @escaping (CKShare) -> ()) {
        let diaryRecord = CKRecord(recordType: CloudKitFetchType.diary.rawValue, zoneID: CKRecordZoneID(zoneName: "diaryZone", ownerName: diaryZoneOwnerID))
        
        let share = CKShare(rootRecord: diaryRecord)
        share[CKShareTitleKey] = "Share" as CKRecordValue
        share.publicPermission = .readOnly
        
        let modifyRecordsOperation = CKModifyRecordsOperation(
            recordsToSave: [diaryRecord, share],
            recordIDsToDelete: nil)
        
        modifyRecordsOperation.timeoutIntervalForRequest = 10
        modifyRecordsOperation.timeoutIntervalForResource = 10
        
        modifyRecordsOperation.modifyRecordsCompletionBlock = { records, recordIDs, error in
            if error != nil {
                print(error?.localizedDescription)
            }
            
            completion(share)
//            self.showShareController(ckShare: share)
            
        }
        
        self.privateDatabase.add(modifyRecordsOperation)
    }
    
    func requestShareData() {
        let operation = CKFetchRecordsOperation(
            recordIDs: [CKShareMetadata().rootRecordID])
        
        operation.perRecordCompletionBlock = { record, _, error in
            if error != nil {
                print(error?.localizedDescription)
            }
            
            if let shareRecord = record {
//                DispatchQueue.main.async() {
//                    
//                    // Shared record successfully fetched. Update user
//                    // interface here to present to user.
//                }
            }
        }
        
        operation.fetchRecordsCompletionBlock = { _, error in
            if error != nil {
                print(error?.localizedDescription)
            }
        }
    }
    
    func showShareController(ckShare: CKShare) {
        
        let controller = UICloudSharingController(share: ckShare, container: container)
        
        controller.availablePermissions = .allowReadOnly
    }
}

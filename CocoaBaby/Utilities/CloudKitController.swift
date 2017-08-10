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
        return container.sharedCloudDatabase
    }
    
    var targetDatabase: CKDatabase {
        return privateDatabase
    }
    
    let diaryRecordID = CKRecordID(recordName: "114")
    let diaryZoneOwnerID = "_ddd57ebe59df8c2acd843a09cf1cc570"
    
    func fetchId() {
        
    }
    
    func fetchRecodZones() {
        privateDatabase.fetchAllRecordZones { (zones, error) in
            guard let zones = zones else {
                return
            }
            
            for zone in zones {
                if zone.zoneID.zoneName == CloudKitZoneName.diary.rawValue {
                    UserStore.shared.diaryZone = zone
                }
            }
        }
    }
 
    func saveDiaryRecord(text: String, year: Int, month: Int, day: Int) {
        guard let zone = UserStore.shared.diaryZone else {
            return
        }
        
        let diaryRecord = CKRecord(recordType: CloudKitFetchType.diary.rawValue, zoneID: zone.zoneID)

        diaryRecord["text"] = text as NSString
        diaryRecord["year"] = year as CKRecordValue
        diaryRecord["month"] = month as CKRecordValue
        diaryRecord["day"] = day as CKRecordValue
        
        targetDatabase.save(diaryRecord) { (record, error) in
            if let error = error {
                print(error)
            }
        }
    }
    
//    func fetchRecord() {
//        publicDatabase.fetch(withRecordID: diaryRecordID) { (record, error) in
//            if let error = error {
//                print(error)
//            }
//        }
//        
//        publicDatabase.fetch(withRecordZoneID: CKRecordZoneID(zoneName: CKRecordZoneDefaultName, ownerName: ownerID)) { (recordZone, error) in
//            if let error = error {
//                print(error)
//            }
//        }
//    }
    func fetchDiaryRecordsWithRecordID(year: Int, month: Int, completion: @escaping ([CKDiary]) -> ()) {
        let predicate = NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "year == \(Int64(year))"),
            NSPredicate(format: "month == \(Int64(month))")
            ])
        
        let query = CKQuery(recordType: CloudKitFetchType.diary.rawValue, predicate: predicate)
        let sortByMonth = NSSortDescriptor(key: "month", ascending: true)
        let sortByDay = NSSortDescriptor(key: "day", ascending: true)
        query.sortDescriptors = [sortByMonth, sortByDay]
        var result: [CKDiary] = [CKDiary]()
        
        privateDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print(error)
            }
            
            guard let records = records else {
                return
            }
            
            for record in records {
                result.append(self.diary(from: record))
            }
            
            completion(result)
        }
    }

    
    func fetchDiaryRecords(year: Int, month: Int, completion: @escaping ([CKDiary]) -> ()) {
        
        let predicate = NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "year == \(Int64(year))"),
            NSPredicate(format: "month == \(Int64(month))")
            ])

        let query = CKQuery(recordType: CloudKitFetchType.diary.rawValue, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        let recordZoneID = CKRecordZoneID(zoneName: CloudKitZoneName.diary.rawValue, ownerName: diaryZoneOwnerID)
        
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
    
    func fetchDiaryRecordss(year: Int, month: Int, completion: @escaping ([CKDiary]) -> ()) {
        let predicate = NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "year == \(Int64(year))"),
            NSPredicate(format: "month == \(Int64(month))")
            ])
        
        let query = CKQuery(recordType: CloudKitFetchType.diary.rawValue, predicate: predicate)
        let sortByMonth = NSSortDescriptor(key: "month", ascending: true)
        let sortByDay = NSSortDescriptor(key: "day", ascending: true)
        query.sortDescriptors = [sortByMonth, sortByDay]
        var result: [CKDiary] = [CKDiary]()
        
        privateDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print(error)
            }
            
            guard let records = records else {
                return
            }
            
            for record in records {
                result.append(self.diary(from: record))
            }
            
            completion(result)
        }
    }
    
    func updateRecord(with id: CKRecordID) {
//        let diaryRecord = CKRecord(recordType: CloudKitFetchType.diary.rawValue, recordID: id)
//        diaryRecord["text"] = "Modified" as CKRecordValue
        
        privateDatabase.fetch(withRecordID: id) { (record, error) in
            if let error = error {
                print(error)
            }
            
            record?["text"] = "Modified" as CKRecordValue
            
            self.privateDatabase.save(record!, completionHandler: { (record, error) in
                if let error = error {
                    print(error)
                }
            })
        }
//        privateDatabase.save(diaryRecord) { (record, error) in
//            if let error = error {
//                print(error)
//            }
//            
//            print("update complete")
//        }
    }
    
    private func diary(from record: CKRecord) -> CKDiary {
        let diary = CKDiary()
        
        if let year = record["year"] {
            diary.year = year as! Int
        }
        
        diary.month = record["month"] as! Int
        diary.day = record["day"] as! Int
        diary.text = record["text"] as! String
        diary.recordID = record.recordID
        
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
//                print(error?.localizedDescription)
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
//                print(error?.localizedDescription)
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
//                print(error?.localizedDescription)
            }
        }
    }
    
    func showShareController(ckShare: CKShare) {
        
        let controller = UICloudSharingController(share: ckShare, container: container)
        
        controller.availablePermissions = .allowReadOnly
    }
}

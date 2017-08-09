//
//  CloudKitController.swift
//  CocoaBaby
//
//  Created by Sohn on 09/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import Foundation
import CloudKit

enum CloudKitFetchType: String {
    case diary = "Diary"
}

class CloudKitController {
    
    static let shared = CloudKitController()
    
    var container = CKContainer.default()
    
    var publicDatabase: CKDatabase {
       return container.publicCloudDatabase
    }
    
    let diaryRecordID = CKRecordID(recordName: "115")
    
    func saveRecord(text: String) {
        let diaryRecordID = CKRecordID(recordName: "116")
        let diaryRecord = CKRecord(recordType: "Diary", recordID: diaryRecordID)
        diaryRecord["text"] = text as NSString
        diaryRecord["year"] = 2017 as CKRecordValue
        diaryRecord["month"] = 8 as CKRecordValue
        diaryRecord["day"] = 9 as CKRecordValue

        publicDatabase.save(diaryRecord) { (record, error) in
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
            
//            print(record)
            
//            print(record?["text"])
        }
        
        let ownerID: String = "_ddd57ebe59df8c2acd843a09cf1cc570"
        
//        publicDatabase.fetch
        
        publicDatabase.fetch(withRecordZoneID: CKRecordZoneID(zoneName: CKRecordZoneDefaultName, ownerName: ownerID)) { (recordZone, error) in
            if let error = error {
                print(error)
            }
            
//            if let zone = recordZone {
//                print(recordZone)
//            
//            }
        }
    }
    
    func fetchRecords(type: CloudKitFetchType, completion: @escaping ([CKDiary]) -> ()) {
        let predicate = NSPredicate(format: "year == 2017")
        let query = CKQuery(recordType: type.rawValue, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        let ownerID: String = "_ddd57ebe59df8c2acd843a09cf1cc570"
        let recordZoneID = CKRecordZoneID(zoneName: CKRecordZoneDefaultName, ownerName: ownerID)
        
        operation.zoneID = recordZoneID
        
        var result: [CKDiary] = [CKDiary]()
        
        operation.recordFetchedBlock = { record in
            result.append(self.diary(from: record))
        }
        
        operation.queryCompletionBlock = { (cursur, error) in
            completion(result)
        }
        
        publicDatabase.add(operation)
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
}

//
//  CloudKitController.swift
//  CocoaBaby
//
//  Created by Sohn on 09/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitController {
    
    static let shared = CloudKitController()
    
    var container = CKContainer.default()
    
    var publicDatabase: CKDatabase {
       return container.publicCloudDatabase
    }
    
    func saveRecord() {
        
        let diaryRecordID = CKRecordID(recordName: "115")
        let diaryRecord = CKRecord(recordType: "Diary", recordID: diaryRecordID)
        diaryRecord["text"] = "Test Record" as NSString
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
        
    }
    func test() {
//        container.pub
    }
}

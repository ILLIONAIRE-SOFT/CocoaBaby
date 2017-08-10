//
//  CKDiaryStore.swift
//  CocoaBaby
//
//  Created by Sohn on 09/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import Foundation
import CloudKit

class CKDiaryStore {
    
    static let shared = CKDiaryStore()
    
    var currentDiaries: [CKDiary] = [CKDiary]()
    var currentDiaryRecords: [CKRecord] = [CKRecord]()
    
    func fetchDiaries(year: Int, month: Int, completion: @escaping () -> ()) {
//        CloudKitController.shared.fetchDiaryRecordss(year: year, month: month) { (diaries) in
//            self.currentDiaries = diaries
//            
//            OperationQueue.main.addOperation {
//                completion()
//            }
//        }
//        CloudKitController.shared.fetchDiaryRecords(year: year, month: month) { (recordss) in
//            
//        }
        
//        CloudKitController.shared.fetchDiaryRecords(year: year, month: month) { (records) in
//            self.currentDiaryRecords = records
//            
//            OperationQueue.main.addOperation {
//                completion()
//            }
//        }
        
        CloudKitController.shared.fetchDiaryRecordsWithRecordID(year: year, month: month) { (diaries) in
            self.currentDiaries = diaries
            
            OperationQueue.main.addOperation {
                completion()
            }
        }
    }
    
    func saveDiaries(text: String, year: Int, month: Int, day: Int) {
        CloudKitController.shared.saveDiaryRecord(text: text, year: year, month: month, day: day)
    }
    
    func updateDiary(diary: CKDiary) {
        if let recordID = diary.recordID {
            CloudKitController.shared.updateRecord(with: recordID)
        }   
    }
}

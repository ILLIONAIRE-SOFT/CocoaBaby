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
    var todayDiary: CKDiary?
    var currentDiaryRecords: [CKRecord] = [CKRecord]()
    
    func fetchDiaries(year: Int, month: Int, completion: @escaping () -> ()) {
        CloudKitController.shared.fetchDiaryRecordsWithRecordID(year: year, month: month) { (diaries) in
            
            self.currentDiaries = diaries
            
            self.storeTodayDairy(diaries: diaries)
            
            OperationQueue.main.addOperation {
                completion()
            }
        }
    }
    
    func storeTodayDairy(diaries: [CKDiary]) {
        let date = Date()
        let components = CocoaDateFormatter.createComponents(from: date)
        guard
            let year = components.year,
            let month = components.month,
            let day = components.day else {
                return
        }
        
        for diary in diaries {
            if diary.year == year && diary.month == month && diary.day == day {
                todayDiary = diary
            }
        }
    }
    
    func saveDiaries(text: String, year: Int, month: Int, day: Int) {
        CloudKitController.shared.saveDiaryRecord(text: text, year: year, month: month, day: day)
    }
    
    func updateDiary(diary: CKDiary, text: String) {
        if let recordID = diary.recordID {
            CloudKitController.shared.updateRecord(with: recordID, text: text)
        }   
    }
}

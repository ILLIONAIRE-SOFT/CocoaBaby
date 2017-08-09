//
//  CKDiaryStore.swift
//  CocoaBaby
//
//  Created by Sohn on 09/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import Foundation

class CKDiaryStore {
    
    static let shared = CKDiaryStore()
    
    var currentDiaries: [CKDiary] = [CKDiary]()
    
    func fetchDiaries(year: Int, month: Int, completion: @escaping () -> ()) {
        CloudKitController.shared.fetchRecords(type: .diary) { (diaries) in
            print("fetch complete")
            self.currentDiaries = diaries
            
            OperationQueue.main.addOperation {
                completion()
            }
            
        }
    }
    
    func saveDiaries(text: String, year: Int, month: Int, day: Int) {
        
    }
}

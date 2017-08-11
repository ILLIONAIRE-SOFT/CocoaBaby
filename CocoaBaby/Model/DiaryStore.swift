//
//  DiaryStore.swift
//  CocoaBaby
//
//  Created by Sohn on 11/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import Foundation

class DiaryStore {
    
    static let shared = DiaryStore()
    
    var currentDiaries: [Diary] = [Diary]()
    
    func fetchDiaries(date: Diary.Date, completion: @escaping () -> ()) {
        
        FireBaseAPI.fetchDiaries(date: date) { (diaries) in
            self.currentDiaries = diaries
            
            OperationQueue.main.addOperation {
                completion()
            }
        }
    }
}

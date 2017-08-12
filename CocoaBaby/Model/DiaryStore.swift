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
    
    var currentDiaries: [Int:Diary] = [:]
    
    func fetchDiaries(date: Diary.Date, completion: @escaping () -> ()) {
        
        FireBaseAPI.fetchDiaries(date: date) { (diaries) in
            
            for diary in diaries {
                self.currentDiaries[diary.date.day] = diary
            }
            
            OperationQueue.main.addOperation {
                completion()
            }
        }
    }
    
    func saveDiary(diary: Diary, completion: @escaping (DiaryResult) -> ()) {
        
        FireBaseAPI.saveDiary(diary: diary) { diaryResult in
            OperationQueue.main.addOperation {
                // currentDiary에 방금 넣은 다이어리 추가
                switch diaryResult {
                case .success(_):
                    completion(diaryResult)
                case .failure(_):
                    completion(diaryResult)
                }
                
            }
        }
    }
}

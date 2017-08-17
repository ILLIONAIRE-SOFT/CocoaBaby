
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
    
    private(set) var currentDiaries: [Int:Diary] = [:]
    
    func fetchDiaries(date: Diary.Date, completion: @escaping () -> ()) {
        
        FireBaseAPI.fetchDiaries(date: date) { (diaries) in
            self.currentDiaries.removeAll()
            for diary in diaries {
                
                if diary.text == "" {
                    continue
                }
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
                case let .success(diary):
                    if diary.text == "" {
                        self.currentDiaries[diary.date.day] = nil
                    } else {
                        self.currentDiaries[diary.date.day] = diary
                    }
                    
                    completion(diaryResult)
                case .failure(_):
                    completion(diaryResult)
                }
            }
        }
    }
    
    func updateDiary(diary: Diary, completion: @escaping (DiaryResult) -> ()) {
        
        FireBaseAPI.updateDiary(diary: diary) { (result) in
            switch result {
            case let .success(diary):
                if diary.text == "" {
                    self.currentDiaries[diary.date.day] = nil
                } else {
                    self.currentDiaries[diary.date.day] = diary
                }
                
                completion(result)
            case .failure(_):
                completion(result)
            }
        }
    }
    
    func updateComment(diary: Diary, completion: @escaping (DiaryResult) -> ()) {
        
        FireBaseAPI.updateComment(to: diary) { (diaryResult) in
            switch diaryResult {
            case let .success(diary):
                self.currentDiaries[diary.date.day] = diary
                completion(diaryResult)
            case .failure(_):
                completion(diaryResult)
            }
        }
    }
    
    func addComment(to diary: Diary, completion: @escaping (DiaryResult) -> ()) {
        
    }
}

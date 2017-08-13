//
//  FireBaseAPI.swift
//  CocoaBaby
//
//  Created by Sohn on 10/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

enum FireBaseAPIError: Error {
    case invalidUser
}

enum FireBaseDirectoryName: String {
    case babies = "babies"
    case diaries = "diaries"
    case year = "year"
    case month = "month"
    case day = "day"
}

enum DiaryResult {
    case success(Diary)
    case failure(Error)
}

struct Diary {
    var text: String
    var date: Date
    
    struct Date {
        var year: Int
        var month: Int
        var day: Int
        
        init(year: Int, month: Int, day: Int) {
            self.year = year
            self.month = month
            self.day = day
        }
    }
    
    init() {
        text = ""
        date = Diary.Date(year: 0, month: 0, day: 0)
    }
    
    init(text: String, date: Diary.Date) {
        self.text = text
        self.date = date
    }
}

struct FireBaseAPI {
    
    static private var ref: DatabaseReference = Database.database().reference()
    
    static func saveDiary(diary: Diary, completion: @escaping (DiaryResult) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print(FireBaseAPIError.invalidUser)
            return
        }
        
        let post = [
            "text": diary.text,
            "year": diary.date.year,
            "month": diary.date.month,
            "day": diary.date.day
            ] as [String : Any]
        
        ref.child(FireBaseDirectoryName.diaries.rawValue).child("\(uid)/\(diary.date.year)/\(diary.date.month)/\(diary.date.day)").setValue(post, andPriority: nil) { (error, ref) in
            if let error = error {
                print(error)
                completion(DiaryResult.failure(error))
            } else {
                completion(DiaryResult.success(diary))
            }
        }
    }
    
    static func fetchDiaries(date: Diary.Date, completion: @escaping ([Diary]) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        ref.child(FireBaseDirectoryName.diaries.rawValue).child(uid).child("\(date.year)").child("\(date.month)").observeSingleEvent(of: .value, with: { (snapshot) in
            
            var result = [Diary]()
            
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                let dict = snap.value as! [String:Any]
                if let diary = diary(from: dict) {
                    result.append(diary)
                }
            }
            
//            if let json = snapshot as? [String:[String:Any]] {
//                for diaryJson in json {
//                    
//                    if let diary = diary(from: diaryJson.value) {
//                        result.append(diary)
//                    }
//                }
//            }
            
            completion(result)
        })
        
//        ref.child(FireBaseDirectoryName.diaries.rawValue).child(uid).child("\(date.year)").child("\(date.month)").observe((.value) { (snapshot) in
//            print(snapshot.value)
//        })
//        ref.child(FireBaseDirectoryName.diaries.rawValue).child(uid).child("\(date.year)").child("\(date.month)").observe(.value) { (snapshot) in
//            print(snapshot.value)
//        }
    }
    
    static private func diary(from json: [String:Any]) -> Diary? {
        var diary = Diary()

        guard
            let text = json["text"],
            let year = json["year"],
            let month = json["month"],
            let day = json["day"] else {
                return nil
        }
        
        diary.text = text as! String
        diary.date.year = year as! Int
        diary.date.month = month as! Int
        diary.date.day = day as! Int
        
        return diary
    }

}

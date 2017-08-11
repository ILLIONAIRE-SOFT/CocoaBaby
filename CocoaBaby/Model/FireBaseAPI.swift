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

enum FireBaseDirectoryName: String {
    case babies = "babies"
    case diaries = "diaries"
    case year = "year"
    case month = "month"
    case day = "day"
}

struct Diary {
    var text: String
    var date: Date
    
    struct Date {
        var year: Int
        var month: Int
        var day: Int
    }
    
    init() {
        text = ""
        date = Diary.Date(year: 0, month: 0, day: 0)
    }
}

struct FireBaseAPI {
    
    static private var ref: DatabaseReference = Database.database().reference()
    
    static func saveDiary(diary: Diary) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let post = [
            "text": diary.text,
            "year": diary.date.year,
            "month": diary.date.month,
            "day": diary.date.day
            ] as [String : Any]
        
        ref.child(FireBaseDirectoryName.diaries.rawValue).child(uid).child("\(diary.date.year)").child("\(diary.date.month)").child("\(diary.date.day)").setValue(post)
    }
    
    static func fetchDiaries(date: Diary.Date, completion: @escaping ([Diary]) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        ref.child(FireBaseDirectoryName.diaries.rawValue).child(uid).child("\(date.year)").child("\(date.month)").observeSingleEvent(of: .value, with: { (snapshot) in
            
            var result = [Diary]()
            
            if let json = snapshot.value as? [String:[String:Any]] {
                for diaryJson in json {
                    if let diary = diary(from: diaryJson.value) {
                        result.append(diary)
                    }
                }
            }
            
            completion(result)
        })
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

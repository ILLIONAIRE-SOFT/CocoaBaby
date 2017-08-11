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
}

struct FireBaseAPI {
    
    static var ref: DatabaseReference = Database.database().reference()
    
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
            let dict = snapshot.value as? [String:[String:Any]]
            
            for dic in dict! {
                print(dic.value)
            }
        })
    }

}

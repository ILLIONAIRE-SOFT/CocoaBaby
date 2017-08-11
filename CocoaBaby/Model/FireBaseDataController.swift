//
//  FirBaseDataController.swift
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
    struct Date {
        var year: Int
        var month: Int
        var day: Int
    }
}

class FireBaseDataController {
    
    static let shared = FireBaseDataController()
    
    var ref: DatabaseReference = Database.database().reference()
    
    func saveUser() {
        self.ref.child("users").child((Auth.auth().currentUser?.uid)!).setValue(["username": "Sohn"])
    }
    
    func saveDiary(year: Int, month: Int, day: Int) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let post = [
            "text": "Test",
            "year": year,
            "month": month,
            "day": day
            ] as [String : Any]
        
        ref.child(FireBaseDirectoryName.diaries.rawValue).child(uid).child("\(year)").child("\(month)").child("\(day)").setValue(post)
    }
    
    func fetchDiaries(date: Diary.Date, completion: @escaping ([Diary]) -> ()) {
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
    
    func loadUser() {
        let userID = Auth.auth().currentUser?.uid
        
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            print(username)
        })
    }
}

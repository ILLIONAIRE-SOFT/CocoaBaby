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
    case noBaby
    case noTips
}

enum FireBaseDirectoryName: String {
    case users = "users"
    case babies = "babies"
    case diaries = "diaries"
    case tips = "tips"
    case year = "year"
    case month = "month"
    case day = "day"
}

enum DiaryPayloadName: String {
    case text = "text"
    case year = "year"
    case month = "month"
    case day = "day"
}

enum BabyPayloadName: String {
    case name = "name"
    case pregnantDate = "pregnantDate"
    case birthDate = "birthDate"
}

enum UserPayloadName: String {
    case gender = "gender"
    case partnerUID = "partnerUID"
}

enum DiaryResult {
    case success(Diary)
    case failure(Error)
}

enum BabyResult {
    case success(Baby?)
    case failure(Error)
}

enum TipsResult {
    case success(Tips)
    case failure(Error)
}

enum UserResult {
    case success(User?)
    case failure(Error)
}

struct FireBaseAPI {
    
    static fileprivate var ref: DatabaseReference = Database.database().reference()
    
    static func saveDiary(diary: Diary, completion: @escaping (DiaryResult) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print(FireBaseAPIError.invalidUser)
            return
        }
        
        let post = [
            DiaryPayloadName.text.rawValue: diary.text,
            DiaryPayloadName.year.rawValue: diary.date.year,
            DiaryPayloadName.month.rawValue: diary.date.month,
            DiaryPayloadName.day.rawValue: diary.date.day
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
            
            completion(result)
        })
    }
    
    static private func diary(from json: [String:Any]) -> Diary? {
        var diary = Diary()
        
        guard
            let text = json[DiaryPayloadName.text.rawValue],
            let year = json[DiaryPayloadName.year.rawValue],
            let month = json[DiaryPayloadName.month.rawValue],
            let day = json[DiaryPayloadName.day.rawValue] else {
                return nil
        }
        
        diary.text = text as! String
        diary.date.year = year as! Int
        diary.date.month = month as! Int
        diary.date.day = day as! Int
        
        return diary
    }
    
}

// MARK: - Baby
extension FireBaseAPI {
    
    static func saveBaby(baby: Baby, completion: @escaping (BabyResult)->()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print(FireBaseAPIError.invalidUser)
            return
        }
        
        let post = [
            BabyPayloadName.name.rawValue: baby.name,
            BabyPayloadName.pregnantDate.rawValue: baby.pregnantDate,
            BabyPayloadName.birthDate.rawValue: baby.birthDate,
            ] as [String : Any]
        
        ref.child(FireBaseDirectoryName.babies.rawValue).child("\(uid)").setValue(post, andPriority: nil) { (error, ref) in
            if let error = error {
                print(error)
                completion(BabyResult.failure(error))
            } else {
                completion(BabyResult.success(baby))
            }
        }
    }
    
    static func fetchBaby(completion: @escaping (BabyResult) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        ref.child(FireBaseDirectoryName.babies.rawValue).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard snapshot.exists() else {
                completion(BabyResult.failure(FireBaseAPIError.noBaby))
                return
            }
            
            var result: Baby? = nil
            
            let dict = snapshot.value as! [String:Any]
            if let baby = baby(from: dict) {
                result = baby
                
                completion(BabyResult.success(result))
                
            } else {
                completion(BabyResult.failure(FireBaseAPIError.noBaby))
            }
            
        })
    }
    
    static private func baby(from json: [String: Any]) -> Baby? {
        var baby = Baby()
        
        guard
            let name = json[BabyPayloadName.name.rawValue],
            let pregnantDate = json[BabyPayloadName.pregnantDate.rawValue],
            let birthDate = json[BabyPayloadName.birthDate.rawValue] else {
                return nil
        }
        
        baby.name = name as! String
        baby.pregnantDate = pregnantDate as! Double
        baby.birthDate = birthDate as! Double
        
        return baby
    }
}

// MARK: - User
extension FireBaseAPI {
    
    static func saveUser(user: User, completion: @escaping (UserResult) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print(FireBaseAPIError.invalidUser)
            return
        }
        
        let post = [
            UserPayloadName.gender.rawValue: user.gender,
            UserPayloadName.partnerUID.rawValue: user.partnerUID ?? ""
            ] as [String : Any]
        
        ref.child(FireBaseDirectoryName.babies.rawValue).child("\(uid)").setValue(post, andPriority: nil) { (error, ref) in
            if let error = error {
                print(error)
                completion(UserResult.failure(error))
            } else {
                completion(UserResult.success(user))
            }
        }
    }
    
    static func fetchUser(completion: @escaping (UserResult) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print(FireBaseAPIError.invalidUser)
            return
        }
        
        ref.child(FireBaseDirectoryName.users.rawValue).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard snapshot.exists() else {
                completion(UserResult.failure(FireBaseAPIError.invalidUser))
                return
            }
            
            var result: User? = nil
            
            let dict = snapshot.value as! [String:Any]
            if let user = user(from: dict) {
                result = user
                completion(UserResult.success(result))
                
            } else {
                completion(UserResult.failure(FireBaseAPIError.invalidUser))
            }
            
        })
    }
    
    private static func user(from json: [String:Any]) -> User? {
        
        var user = User()
        
        guard
            let gender = json[UserPayloadName.gender.rawValue],
            let partnerUID = json[UserPayloadName.partnerUID.rawValue] else {
                return nil
        }
        
        user.gender = gender as! String
        
        let uid = partnerUID as! String
        
        if uid == "" {
            user.partnerUID = nil
        } else {
            user.partnerUID = uid
        }
        
        return user
    }
    
}

// MARK: - Tips
/*
extension FireBaseAPI {
    static func fetchTips(completion: @escaping (TipsResult) -> ()) {
        
        ref.child(FireBaseDirectoryName.tips.rawValue).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            guard snapshot.exists() else {
                completion(TipsResult.failure(FireBaseAPIError.noTips))
            }
            
            var result: Tips? = nil
            
//            let dict = snapshot.value as! [String:Any]
//            if let tips = baby(from: dict) {
//                result = baby
//                
//                completion(BabyResult.success(result))
//                
//            } else {
//                completion(BabyResult.failure(FireBaseAPIError.noBaby))
//            }

        })
        
    }
    
    static private func baby(from json: [String: Any]) -> Baby? {
        var baby = Baby()
        
        guard
            let name = json[BabyPayloadName.name.rawValue],
            let pregnantDate = json[BabyPayloadName.pregnantDate.rawValue],
            let birthDate = json[BabyPayloadName.birthDate.rawValue] else {
                return nil
        }
        
        baby.name = name as! String
        baby.pregnantDate = pregnantDate as! Double
        baby.birthDate = birthDate as! Double
        
        return baby
    }

}*/

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
    case share = "share"
}

enum DiaryPayloadName: String {
    case text = "text"
    case year = "year"
    case month = "month"
    case day = "day"
    case comment = "comment"
}

enum BabyPayloadName: String {
    case name = "name"
    case pregnantDate = "pregnantDate"
    case birthDate = "birthDate"
}

enum TipsPayloadName: String {
    case babyTitle = "babyTitle"
    case babyContent = "babyContent"
    case mamaTitle = "mamaTitle"
    case mamaContent = "mamaContent"
    case papaTitle = "papaTitle"
    case papaContent = "papaContent"
    case week = "week"
}

enum SharePayloadName: String {
    case uid = "uid"
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
    case success([Int:Tips])
    case failure(Error)
}

enum ShareResult {
    case success(Int)
    case failure()
}

struct FireBaseAPI {
    
    static internal var ref: DatabaseReference = Database.database().reference()
    
    static func saveDiary(diary: Diary, completion: @escaping (DiaryResult) -> ()) {
        guard var uid = Auth.auth().currentUser?.uid else {
            print(FireBaseAPIError.invalidUser)
            return
        }
        
        if let partnerUID = UserStore.shared.user?.partnerUID {
            if UserStore.shared.user?.gender == "male" {
                uid = partnerUID
            }
        }
        
        let post = [
            DiaryPayloadName.text.rawValue: diary.text,
            DiaryPayloadName.year.rawValue: diary.date.year,
            DiaryPayloadName.month.rawValue: diary.date.month,
            DiaryPayloadName.day.rawValue: diary.date.day,
            DiaryPayloadName.comment.rawValue: diary.comment ?? ""
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
    
    static func updateDiary(diary: Diary, completion: @escaping (DiaryResult) -> ()) {
        guard var uid = Auth.auth().currentUser?.uid else {
            print(FireBaseAPIError.invalidUser)
            return
        }
        
        if let partnerUID = UserStore.shared.user?.partnerUID {
            if UserStore.shared.user?.gender == "male" {
                uid = partnerUID
            }
        }
        
        let post = [
            DiaryPayloadName.text.rawValue: diary.text
        ] as [String:Any]
        
        ref.child(FireBaseDirectoryName.diaries.rawValue).child("\(uid)/\(diary.date.year)/\(diary.date.month)/\(diary.date.day)").updateChildValues(post) { (error, ref) in
            if let error = error {
                completion(DiaryResult.failure(error))
            } else {
                completion(DiaryResult.success(diary))
            }
        }
    }
    
    static func updateComment(to diary: Diary, completion: @escaping (DiaryResult) -> ()) {
        guard
            var uid = Auth.auth().currentUser?.uid,
            let comment = diary.comment else {
            print(FireBaseAPIError.invalidUser)
            return
        }
        
        if let partnerUID = UserStore.shared.user?.partnerUID {
            if UserStore.shared.user?.gender == "male" {
                uid = partnerUID
            }
        }
        
        let post = [
            DiaryPayloadName.comment.rawValue: comment
        ] as [String:Any]
        
        ref.child(FireBaseDirectoryName.diaries.rawValue).child("\(uid)/\(diary.date.year)/\(diary.date.month)/\(diary.date.day)").updateChildValues(post) { (error, ref) in
            if let error = error {
                completion(DiaryResult.failure(error))
            } else {
                completion(DiaryResult.success(diary))
            }
        }
    }
    
    static func fetchDiaries(date: Diary.Date, completion: @escaping ([Diary]) -> ()) {
        guard var uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        if let partnerUID = UserStore.shared.user?.partnerUID {
            if UserStore.shared.user?.gender == "male" {
                uid = partnerUID
            }
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
        
        if let comment = json[DiaryPayloadName.comment.rawValue] {
            diary.comment = comment as? String
        }
        
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
    
    static func updateBaby(baby: Baby, completion: @escaping (BabyResult)->()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print(FireBaseAPIError.invalidUser)
            return
        }
        
        let post = [
            BabyPayloadName.name.rawValue: baby.name,
            BabyPayloadName.pregnantDate.rawValue: baby.pregnantDate,
            BabyPayloadName.birthDate.rawValue: baby.birthDate,
            ] as [String : Any]

        ref.child(FireBaseDirectoryName.babies.rawValue).child(uid).updateChildValues(post) { (error, ref) in
            if let error = error {
                print(error)
                completion(BabyResult.failure(error))
            } else {
                completion(BabyResult.success(baby))
            }
        }
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



// MARK: - Tips

extension FireBaseAPI {
    static func fetchTips(completion: @escaping (TipsResult) -> ()) {
        
        ref.child(FireBaseDirectoryName.tips.rawValue).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            guard snapshot.exists() else {
                completion(TipsResult.failure(FireBaseAPIError.noTips))
                return
            }
            
            var result = [Int:Tips]()
            
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                let dict = snap.value as! [String:Any]
                if let tips = tips(from: dict) {
                    let week = tips.0
                    let tips = tips.1
                    result[week] = tips
                }
            }
            completion(TipsResult.success(result))
        })
        
    }
    
    static private func tips(from json: [String: Any]) -> (Int,Tips)? {
        var tips = Tips()
        
        guard
            let babyTitle = json[TipsPayloadName.babyTitle.rawValue],
            let babyContent = json[TipsPayloadName.babyContent.rawValue],
            let mamaTitle = json[TipsPayloadName.mamaTitle.rawValue],
            let mamaContent = json[TipsPayloadName.mamaContent.rawValue],
            let papaTitle = json[TipsPayloadName.papaTitle.rawValue],
            let papaContent = json[TipsPayloadName.papaContent.rawValue],
            let week = json[TipsPayloadName.week.rawValue] as? Int
            else {
                return nil
        }
        
        tips.babyTitle = babyTitle as! String
        tips.babyContent = babyContent as! String
        tips.mamaTitle = mamaTitle as! String
        tips.mamaContent = mamaContent as! String
        tips.papaTitle = papaTitle as! String
        tips.papaContent = papaContent as! String
        
        return (week,tips)
        
    }
    
}

// MARK: - Share
extension FireBaseAPI {
    
    static func createShareSection(sixDigits: Int, completion: @escaping (ShareResult) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print(FireBaseAPIError.invalidUser)
            return
        }
        
        let post = [
            SharePayloadName.uid.rawValue: uid
            ] as [String : Any]
        
        // 먼저 observe single event로 해당 번호의 세션이 있는지 확인해줘야 한다. 없는 경우에 fail 줘서 다시 번호를 생성하도록..
        ref.child(FireBaseDirectoryName.share.rawValue).child("\(sixDigits)").observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            if snapshot.exists() {
                completion(ShareResult.failure())
            } else {
                ref.child(FireBaseDirectoryName.share.rawValue).child("\(sixDigits)").setValue(post, andPriority: nil) { (error, ref) in
                    if let _ = error {
                        completion(ShareResult.failure())
                    } else {
                        completion(ShareResult.success(sixDigits))
                    }
                }
            }
        })
    }
    
    static func removeShareSection(sixDigits: Int, completion: @escaping (ShareResult) -> ()) {
        //        guard let uid = Auth.auth().currentUser?.uid else {
        //            print(FireBaseAPIError.invalidUser)
        //            return
        //        }
        
        ref.child(FireBaseDirectoryName.share.rawValue).child("\(sixDigits)").removeValue()
        completion(ShareResult.success(0))
    }
    
    static func linkWithPartner(me: User, sixDigits: Int, completion: @escaping (UserResult) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print(FireBaseAPIError.invalidUser)
            return
        }
        
        ref.child(FireBaseDirectoryName.share.rawValue).child("\(sixDigits)").observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard snapshot.exists() else {
                completion(UserResult.failure(nil))
                return
            }
            
            let dict = snapshot.value as! [String:Any]
            
            if let partnerUID = partnerUID(from: dict) {
                let user = User(gender: me.gender, partnerUID: partnerUID, deviceToken: nil, partnerDeviceToken: nil)
                
                let post = [
                    UserPayloadName.partnerUID.rawValue: partnerUID
                    ] as [String : Any]
                
                let partnerPost = [
                    UserPayloadName.partnerUID.rawValue: uid
                ] as [String: Any]
                
                ref.child(FireBaseDirectoryName.users.rawValue).child("\(uid)").updateChildValues(post, withCompletionBlock: { (error, ref) in
                    if let error = error {
                        completion(UserResult.failure(error))
                    } else {
                        self.ref.child(FireBaseDirectoryName.users.rawValue).child("\(partnerUID)").updateChildValues(partnerPost, withCompletionBlock: { (error, ref) in
                            if let error = error {
                                completion(UserResult.failure(error))
                            } else {
                                completion(UserResult.success(user))
                            }
                        })
                    }
                })
            } else {
                completion(UserResult.failure(nil))
                return
            }
        })
    }
    
    static private func partnerUID(from json: [String:Any]) -> String? {
        guard
            let partnerUID = json[SharePayloadName.uid.rawValue] else {
                return nil
        }
        
        return partnerUID as? String
    }
    
}

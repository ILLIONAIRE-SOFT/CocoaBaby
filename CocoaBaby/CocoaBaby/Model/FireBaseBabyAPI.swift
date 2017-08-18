//
//  FireBaseBabyAPI.swift
//  CocoaBaby
//
//  Created by Sohn on 18/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import Foundation
import FirebaseAuth

enum BabyPayloadName: String {
    case name = "name"
    case pregnantDate = "pregnantDate"
    case birthDate = "birthDate"
}

enum BabyResult {
    case success(Baby?)
    case failure(Error)
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
        guard var uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        if let partnerUID = UserStore.shared.user?.partnerUID {
            uid = partnerUID
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


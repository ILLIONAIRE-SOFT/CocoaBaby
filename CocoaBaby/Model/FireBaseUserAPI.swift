//
//  FireBaseUserAPI.swift
//  CocoaBaby
//
//  Created by Sohn on 17/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import Foundation
import FirebaseAuth

struct User {
    var gender: String = "female"
    var partnerUID: String? = nil
    var deviceToken: String? = nil
    var partnerDeviceToken: String? = nil
}

enum UserResult {
    case success(User?)
    case failure(Error?)
}

enum UserPayloadName: String {
    case gender = "gender"
    case partnerUID = "partnerUID"
    case deviceToken = "deviceToken"
    case partnerDeviceToken = "partnerDeviceToken"
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
            ] as [String:Any]
        
        ref.child(FireBaseDirectoryName.users.rawValue).child("\(uid)").setValue(post, andPriority: nil) { (error, ref) in
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
    
    static func updateUser(post: [String:Any], completion: @escaping(UserResult) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print(FireBaseAPIError.invalidUser)
            return
        }
        
        ref.child(FireBaseDirectoryName.users.rawValue).child("\(uid)").updateChildValues(post) { (error, ref) in
            if let error = error {
                completion(UserResult.failure(error))
            } else {
                completion(UserResult.success(nil))
            }
        }
        
    }
    
    private static func user(from json: [String:Any]) -> User? {
        
        var user = User()
        
        guard
            let gender = json[UserPayloadName.gender.rawValue] else {
                return nil
        }
        
        let partnerUID = json[UserPayloadName.partnerUID.rawValue]
        
        user.gender = gender as! String
        
        if partnerUID != nil {
            let uid = partnerUID as! String
            
            if uid == "" {
                user.partnerUID = nil
            } else {
                user.partnerUID = uid
            }
        }
        
        return user
    }
    
}

//
//  UserStore.swift
//  CocoaBaby
//
//  Created by Sohn on 10/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import Foundation
import CloudKit

class UserStore {
    
    static let shared = UserStore()
    
    private(set) var user: User?
    
    func fetchUser(completion: @escaping (UserResult) -> ()) {
        
        FireBaseAPI.fetchUser { (userResult) in
            switch userResult {
            case let .success(user):
                self.user = user
                completion(userResult)
            case .failure(_):
                completion(userResult)
            }
        }
    }
    
    func saveUser(user: User, completion: @escaping (UserResult) -> ()) {
        
        FireBaseAPI.saveUser(user: user) { (userResult) in
            switch userResult {
            case let .success(user):
                self.user = user
                completion(userResult)
            case .failure(_):
                completion(userResult)
            }
        }
    }
    
    func updateUser(post: [String:Any], completion: @escaping (UserResult) -> ()) {
        
        FireBaseAPI.updateUser(post: post) { (userResult) in
            switch userResult {
            case .success(_):
                completion(userResult)
            case .failure(_):
                completion(userResult)
            }
        }
    }
    
    func setUser(user: User) {
        self.user = user
    }
}

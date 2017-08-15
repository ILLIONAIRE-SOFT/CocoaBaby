//
//  UserStore.swift
//  CocoaBaby
//
//  Created by Sohn on 10/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import Foundation
import CloudKit

struct User {
    var gender: String = "female"
    var partnerUID: String? = nil
}

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
}

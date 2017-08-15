//
//  ShareHelper.swift
//  CocoaBaby
//
//  Created by Sohn on 15/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import Foundation

class ShareHelper {
    
    static func createShareSession(completion: @escaping () -> ()) {
        
        FireBaseAPI.createShareSection(sixDigits: 646223) { (result) in
            switch result {
            case .success():
                completion()
            case .failure():
                completion()
            }
        }
    }
    
    static func removeShareSession(completion: @escaping () -> ()) {
        
        FireBaseAPI.removeShareSection(sixDigits: 646223) { (result) in
            switch result {
            case .success():
                completion()
            case .failure():
                completion()
            }
        }
    }
    
    static func linkWithPartner(sixDigits: Int, completion: @escaping () -> ()) {
        
        FireBaseAPI.linkWithPartner(me: UserStore.shared.user!, sixDigits: sixDigits) { (shareResult) in
            switch shareResult {
            case let .success(user):
                if let user = user {
                    UserStore.shared.setUser(user: user)
                }
                completion()
            case let .failure(error):
                if let error = error {
                    print(error)
                }
                completion()
            }
        }
    }
}

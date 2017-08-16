//
//  ShareHelper.swift
//  CocoaBaby
//
//  Created by Sohn on 15/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import Foundation

class ShareHelper {
    
    static var shareCode: Int = 0
    
    static func createShareSession(completion: @escaping (Int) -> ()) {
        
        generateShareCode()
        
        FireBaseAPI.createShareSection(sixDigits: shareCode) { (result) in
            switch result {
            case .success():
                completion(shareCode)
            case .failure():
                completion(shareCode)
            }
        }
    }
    
    static func removeShareSession(completion: @escaping () -> ()) {
        
        FireBaseAPI.removeShareSection(sixDigits: shareCode) { (result) in
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
    
    static func generateShareCode() {
        let code: Int = Int(arc4random_uniform(UInt32(899999)) + UInt32(10000))
        
        self.shareCode = code
    }
}

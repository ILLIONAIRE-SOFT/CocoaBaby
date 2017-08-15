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
}

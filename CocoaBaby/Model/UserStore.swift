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
    
    var diaryZone: CKRecordZone!
    
}

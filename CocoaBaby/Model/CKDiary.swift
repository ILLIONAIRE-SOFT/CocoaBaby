//
//  CKDiary.swift
//  CocoaBaby
//
//  Created by Sohn on 09/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import Foundation

class CKDiary: NSObject {
    
    var text: String = ""
    var year: Int = 0
    var month: Int = 0
    var day: Int = 0
    
    override init() {
        
    }
    
    init(text: String, year: Int, month: Int, day: Int) {
        self.text = text
        self.year = year
        self.month = month
        self.day = day
    }
    
}

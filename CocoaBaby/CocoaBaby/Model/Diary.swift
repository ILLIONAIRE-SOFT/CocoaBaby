//
//  Diary.swift
//  CocoaBaby
//
//  Created by Sohn on 14/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import Foundation

struct Diary {
    var text: String
    var comment: String?
    var date: Date
    struct Date {
        var year: Int
        var month: Int
        var day: Int
        
        init(year: Int, month: Int, day: Int) {
            self.year = year
            self.month = month
            self.day = day
        }
        
    }
    
    init() {
        text = ""
        date = Diary.Date(year: 0, month: 0, day: 0)
    }
    
    init(text: String, date: Diary.Date) {
        self.text = text
        self.date = date
    }
}

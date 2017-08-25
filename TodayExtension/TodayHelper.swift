//
//  TodayHelper.swift
//  CocoaBaby
//
//  Created by Sohn on 25/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import Foundation

struct TodayHelper {
    
    static func getDday(to birthDate: Double) -> Int {
        
        let components = Calendar.current.dateComponents([.day], from: Date(), to: Date(timeIntervalSince1970: birthDate))
        
        if let day = components.day {
            return day + 1
        } else {
            return 0
        }  
    }
    
    static func getCurrentWeek(from pregnantDate: Double) -> Int {
        
        let components = Calendar.current.dateComponents([.day], from: Date(timeIntervalSince1970: pregnantDate), to: Date())
        
        if let day = components.day {
            return day/7 + 1
        } else {
            return 0
        }
    }
}

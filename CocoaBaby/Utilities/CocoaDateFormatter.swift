//
//  CocoaDateFormatter.swift
//  CocoaBaby
//
//  Created by Sohn on 07/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import Foundation

class CocoaDateFormatter {
    
    static func createComponents(from date: Date) -> DateComponents {
        
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return components
    }
    
    static func createComponents(year: Int, month: Int, day: Int) -> DateComponents {
        
        let components = DateComponents(calendar: Calendar.current, timeZone: nil, era: nil, year: year, month: month, day: day, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        
        return components
    }

}

//
//  CocoaDateFormatter.swift
//  CocoaBaby
//
//  Created by Sohn on 07/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import Foundation

class CocoaDateFormatter {
    
    static let weekDays = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    
    static func createComponents(from date: Date) -> DateComponents {
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .weekday], from: date)
        return components
    }
    
    static func createComponents(year: Int, month: Int, day: Int) -> DateComponents {
        
        let components = DateComponents(calendar: Calendar.current, timeZone: nil, era: nil, year: year, month: month, day: day, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        
        return components
    }
    
    static func createDate(year: Int, month: Int, day: Int) -> Date {
        let date = Calendar.current.date(from: createComponents(year: year, month: month, day: day))
        
        return date!
    }
    
//    static func getDay(from diary: CKDiary) -> String {
//        let date = createDate(year: diary.year, month: diary.month, day: diary.day)
//        
//        let components = createComponents(from: date)
//        
//        if let weekDay = components.weekday {
//            return weekDays[weekDay - 1]
//        } else {
//            return ""
//        }
//    }
}

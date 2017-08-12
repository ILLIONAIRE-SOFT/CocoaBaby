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
    
    static func createDate(from diaryDate: Diary.Date) -> Date {
        let date = Calendar.current.date(from: createComponents(year: diaryDate.year, month: diaryDate.month, day: diaryDate.day))
        
        return date!
    }
    
    static func getCalendarComponents(from date: Date) -> DateComponents {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        
        return components
    }
    
    static func getNumberOfDay(from diaryDate: Diary.Date) -> Int {
        let todayComponents = getCalendarComponents(from: Date())
        
        let dateComponents = DateComponents(year: diaryDate.year, month: diaryDate.month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        var numDays = range.count
        
        if diaryDate.year == todayComponents.year, diaryDate.month == todayComponents.month {
            numDays = todayComponents.day!
        }
        
        return numDays
    }
    
    static func getDay(from diary: Diary) -> String {
        let date = createDate(from: diary.date)
        
        let components = createComponents(from: date)
        
        if let weekDay = components.weekday {
            return weekDays[weekDay - 1]
        } else {
            return ""
        }
    }
}

//
//  BabyStore.swift
//  CocoaBaby
//
//  Created by Sohn on 02/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import Foundation
import CoreData

enum BabyError: Error {
    case invalidInput
    case invalidBaby
    case invalidName
}

struct DdayResult {
    var value: Int
    var mark: String
}

struct Week {
    var week: Int
    var dayOfWeek: Int
}

struct Baby {
    var name: String = ""
    var birthDate: Double = 0
    var pregnantDate: Double = 0
    
}

class BabyStore {
    
    static let shared: BabyStore = BabyStore()
    
    var baby: Baby! = nil
    
    func fetchBaby(completion: @escaping (Baby?) -> ()) {
        
        FireBaseAPI.fetchBaby { (result) in
            switch result {
            case let .success(baby):
                self.baby = baby
                completion(baby)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    func saveBaby(baby: Baby, completion: @escaping (BabyResult) -> ()) {
        
        FireBaseAPI.saveBaby(baby: baby) { (result) in
            switch result {
            case .success(_):
                completion(result)
            case .failure(_):
                completion(result)
            }
        }
    }
    
    func updateBaby(name: String?, pregnantDate: Date?, birthDate: Date?, completion: ((Baby) -> ())?) {
        
    }
    
    func deleteBaby() {
        
    }
    
    func getDday() -> DdayResult {
        
        var result = DdayResult(value: 0, mark: "+")
        
        guard let baby = self.baby else {
            return result
        }
        
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: Date())
        
        let endDate = calendar.startOfDay(for: Date(timeIntervalSince1970: baby.birthDate))
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        guard let value = components.day else {
            return result
        }
        
        if value >= 0 {
            result.value = value
            result.mark = "-"
        } else {
            result.mark = "+"
            result.value = abs(value)
        }
        
        return result
    }
    
    func getName() -> String {
        
        guard let baby = self.baby else {
            return "No Baby"
        }
        
        return baby.name
    }
    
    func getPregnantWeek() -> Week {
        
        var week = Week(week: 0, dayOfWeek: 0)
        
        guard let baby = self.baby else {
            print(BabyError.invalidBaby)
            return week
        }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let pregnantDate = calendar.startOfDay(for: Date(timeIntervalSince1970: baby.pregnantDate))
        let components = calendar.dateComponents([.day], from: pregnantDate, to: today)
        
        if let day = components.day {
            week.week = (day - 1) / 7 + 1
            week.dayOfWeek = (day - 1) % 7 + 1
        }
        
        return week
    }
    
    func getPregnantWeekBasedOnDiary(from diary: Diary) -> Week {
        
        var week = Week(week: 0, dayOfWeek: 0)
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let diaryDate = CocoaDateFormatter.createDate(from: diary.date)
        let pregnantDate = calendar.startOfDay(for: Date(timeIntervalSince1970: baby.pregnantDate))
        
        let components = calendar.dateComponents([.day], from: pregnantDate, to: diaryDate)
        
        if let day = components.day {
            week.week = (day - 1) / 7 + 1
        }
        
        return week
    }
    
    func getYearOfPregnantDate() -> String {
        
        var date = Date(timeIntervalSince1970: baby.pregnantDate)
        // date에서 year만 뽑아내는 법
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy"
        var pregnantYear = dateFormatter.string(from: date)
        
        return pregnantYear
    }
 
}


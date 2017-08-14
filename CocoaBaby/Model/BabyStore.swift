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
    
    let persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CocoaBaby")
        container.loadPersistentStores(completionHandler: { (description, error) in
            if let error = error {
                print("Error setting up Core Data (\(error))")
            }
        })
        return container
    }()
    
    
    func fetchBaby(completion: @escaping (Baby?) -> ()) {
        
        FireBaseAPI.fetchBaby { (result) in
            switch result {
            case let .success(baby):
                self.baby = baby
                completion(baby)
            case let .failure(_):
                completion(nil)
            default:
                return
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
//        let context = persistentContainer.viewContext
//        
//        loadBaby()
//        
//        context.performAndWait {
//            if self.baby == nil {
//                self.baby = Baby(context: context)
//                self.baby.createdAt = Date() as NSDate
//            }
//            
//            guard
//                let name = name,
//                let birthDate = birthDate,
//                let pregnantDate = pregnantDate else {
//                    print(BabyError.invalidInput)
//                    return
//            }
//            
//            self.baby.expectedBirthDate = birthDate as NSDate
//            self.baby.expectedPregnantDate = pregnantDate as NSDate
//            self.baby.name = name
//            
//            do {
//                try context.save()
//            } catch let error {
//                print(error)
//            }
//        }
    }
    
    func updateBaby(name: String?, pregnantDate: Date?, birthDate: Date?, completion: ((Baby) -> ())?) {
        
//        let context = persistentContainer.viewContext
//        
//        context.performAndWait {
//            if self.baby == nil {
//                self.baby = Baby(context: context)
//                self.baby.createdAt = Date() as NSDate
//            }
//            
//            if let name = name {
//                self.baby.name = name
//            }
//            
//            if let pregnantDate = pregnantDate {
//                self.baby.expectedPregnantDate = pregnantDate as NSDate
//            }
//            
//            if let birthDate = birthDate {
//                self.baby.expectedBirthDate = birthDate as NSDate
//            }
//            
//            do {
//                try context.save()
//            } catch let error {
//                print(error)
//            }
//            
//            if let completion = completion {
//                OperationQueue.main.addOperation {
//                    completion(self.baby)
//                }
//            }
//        }
    }
    
    func deleteBaby() {
        
//        let context = persistentContainer.viewContext
//        
//        if let baby = self.baby {
//            context.delete(baby)
//        } else {
//            return
//        }
//        
//        context.performAndWait {
//            do {
//                try context.save()
//            } catch let error {
//                print(error)
//            }
//        }
    }
    
    func getDday() -> DdayResult {
        
        var result = DdayResult(value: 0, mark: "+")
        
//        guard let baby = self.baby else {
//            return result
//        }
//        
//        let calendar = Calendar.current
//        let startDate = calendar.startOfDay(for: Date())
//        
//        guard let expectedBirthDate = baby.expectedBirthDate else {
//            return result
//        }
//        
//        let endDate = calendar.startOfDay(for: expectedBirthDate as Date)
//        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
//        
//        guard let value = components.day else {
//            return result
//        }
//        
//        if value >= 0 {
//            result.value = value
//            result.mark = "-"
//        } else {
//            result.mark = "+"
//            result.value = abs(value)
//        }
        
        return result
    }
    
    func getName() -> String {
        
//        guard let baby = self.baby else {
//            return "No Baby"
//        }
//        
//        if let name = baby.name {
//            return name
//        } else {
//            return "No Name"
//        }
        return ""
    }
    
    func getPregnantWeek() -> Week {
        
        var week = Week(week: 0, dayOfWeek: 0)
        
//        guard let baby = self.baby else {
//            print(BabyError.invalidBaby)
//            return week
//        }
//        
//        let calendar = Calendar.current
//        let today = calendar.startOfDay(for: Date())
//        
//        guard let expectedPregnantDate = baby.expectedPregnantDate else {
//            return week
//        }
//        
//        let pregnantDate = calendar.startOfDay(for: expectedPregnantDate as Date)
//        let components = calendar.dateComponents([.day], from: pregnantDate, to: today)
//        
//        if let day = components.day {
//            week.week = (day - 1) / 7 + 1
//            week.dayOfWeek = (day - 1) % 7 + 1
//        }
        
        return week
    }
    
}

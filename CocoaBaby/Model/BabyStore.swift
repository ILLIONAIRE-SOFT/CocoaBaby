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
}

struct DdayResult {
    var value: Int
    var mark: String
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
    
    func loadBaby() {
        
        let fetchRequest: NSFetchRequest<Baby> = Baby.fetchRequest()
        
        let viewContext = persistentContainer.viewContext
        
        viewContext.performAndWait {
            do {
                let baby = try viewContext.fetch(fetchRequest)
                self.baby = baby.first
            } catch {
                print(error)
            }
        }
    }
    
    func registerBaby(from pregnantDate: Date?, to birthDate: Date?, name: String?) {
        
        let context = persistentContainer.viewContext
        
        loadBaby()
        
        context.performAndWait {
            if self.baby == nil {
                self.baby = Baby(context: context)
                self.baby.createdAt = Date() as NSDate
            }
            
            guard
                let name = name,
                let birthDate = birthDate,
                let pregnantDate = pregnantDate else {
                    print(BabyError.invalidInput)
                    return
            }
            
            self.baby.expectedBirthDate = birthDate as NSDate
            self.baby.expectedPregnantDate = pregnantDate as NSDate
            self.baby.name = name
            
            do {
                try context.save()
                print("Save")
            } catch let error {
                print(error)
            }
        }
    }
    
    func deleteBaby() {
        
        let context = persistentContainer.viewContext
        
        if let baby = self.baby {
            context.delete(baby)
        } else {
            return
        }
        
        context.performAndWait {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    func getDday() -> DdayResult {
        
        var result = DdayResult(value: 0, mark: "+")
        
        guard let baby = self.baby else {
            return result
        }
        
        let calendar = Calendar.current

        let startDate = calendar.startOfDay(for: Date())
        
        guard let expectedBirthDate = baby.expectedBirthDate else {
            return result
        }
        
        let endDate = calendar.startOfDay(for: expectedBirthDate as Date)
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
        
        if let name = baby.name {
            return name
        } else {
            return "No Name"
        }
    }
    
    
}

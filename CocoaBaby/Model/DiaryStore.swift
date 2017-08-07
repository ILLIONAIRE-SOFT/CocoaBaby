//
//  DiaryStore.swift
//  CocoaBaby
//
//  Created by Sohn on 07/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import Foundation
import CoreData

enum DiaryStoreError: Error {
    case invalidDateComponents
    case saveError
    case fetchError
}

class DiaryStore {
    
    static let shared: DiaryStore = DiaryStore()
    
    var diaries: [Diary] = [Diary]()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CocoaBaby")
        container.loadPersistentStores(completionHandler: { (description, error) in
            if let error = error {
                print("Error setting up Core Data (\(error))")
            }
        })
        return container
    }()
    
    func fetchDiaries(year: Int, month: Int, completion: @escaping () -> ()) {
        let fetchRequest: NSFetchRequest<Diary> = Diary.fetchRequest()
        let sortByDay = NSSortDescriptor(key: #keyPath(Diary.day), ascending: true)
        fetchRequest.sortDescriptors = [sortByDay]
        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "year == \(Int64(year))"),
            NSPredicate(format: "month == \(Int64(month))")
            ])
        
        let viewContext = persistentContainer.viewContext
        
        viewContext.perform {
            do {
                let diaries = try viewContext.fetch(fetchRequest)
                
                self.diaries = diaries
                
                OperationQueue.main.addOperation {
                    completion()
                }
            } catch {
                print(DiaryStoreError.fetchError)
            }
        }
    }
    
    func createDiary(text: String, dateComponents: DateComponents, completion: @escaping () -> ()) {
        let context = persistentContainer.viewContext
        
        context.performAndWait {
            let diary = Diary(context: context)
            
            guard
                let year = dateComponents.year,
                let month = dateComponents.month,
                let day = dateComponents.day else {
                    print(DiaryStoreError.invalidDateComponents)
                    return
            }
            
            diary.year = Int64(year)
            diary.month = Int64(month)
            diary.day = Int64(day)
            diary.text = text
            
            do {
                try context.save()
            } catch {
                print(DiaryStoreError.saveError)
            }
            
            OperationQueue.main.addOperation {
                completion()
            }
        }
    }
    
    func updateDiary(text: String, diary: Diary, completion: (() -> ())?) {
        let context = persistentContainer.viewContext
        
        context.performAndWait {
            diary.text = text
            
            do {
                try context.save()
            } catch {
                print(DiaryStoreError.saveError)
            }
            
            OperationQueue.main.addOperation {
                if let completion = completion {
                    completion()
                }
            }
        }
    }
    
    func deleteDiary() {
        
    }
    
    func getDday(of diary: Diary) -> DdayResult {
        
        var result = DdayResult(value: 0, mark: "+")
        
        guard let baby = BabyStore.shared.baby else {
            return result
        }
        
        let calendar = Calendar.current
        
       //////////?? let startDate =
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
    
    
}

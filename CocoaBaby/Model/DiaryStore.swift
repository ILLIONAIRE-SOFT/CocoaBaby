//
//  DiaryStore.swift
//  CocoaBaby
//
//  Created by Sohn on 07/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import Foundation
import CoreData

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
                //                print(DiaryStoreError.fetchDiariesError)
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
                    return
            }
            
            diary.year = Int64(year)
            diary.month = Int64(month)
            diary.day = Int64(day)
            diary.text = text
            
            do {
                try context.save()
                print("Save \(text)")
            } catch let error {
                print(error)
            }
            
            OperationQueue.main.addOperation {
                completion()
            }
        }
    }
    
    func updateDiary() {
        
    }
    
    func deleteDiary() {
        
    }
}

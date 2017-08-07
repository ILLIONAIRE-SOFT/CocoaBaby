//
//  Diary+CoreDataProperties.swift
//  CocoaBaby
//
//  Created by Sohn on 07/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import Foundation
import CoreData


extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var text: String?
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var day: Int64
    @NSManaged public var month: Int64
    @NSManaged public var year: Int64

}

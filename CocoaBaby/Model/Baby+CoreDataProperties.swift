//
//  Baby+CoreDataProperties.swift
//  CocoaBaby
//
//  Created by Sohn on 02/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import Foundation
import CoreData


extension Baby {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Baby> {
        return NSFetchRequest<Baby>(entityName: "Baby")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var expectedBirthDate: NSDate?
    @NSManaged public var expectedPregnantDate: NSDate?
    
}

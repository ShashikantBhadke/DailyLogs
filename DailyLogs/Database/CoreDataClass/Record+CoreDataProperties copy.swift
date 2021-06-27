//
//  Record+CoreDataProperties.swift
//  
//
//  Created by Shashikant Bhadke on 27/06/21.
//
//

import Foundation
import CoreData

extension Record {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
        return NSFetchRequest<Record>(entityName: "Record")
    }

    @NSManaged public var amount: Double
    @NSManaged public var amountType: Int16
    @NSManaged public var createdOn: Date?
    @NSManaged public var detail: String?
    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var person: Person?
    @NSManaged public var user: User?

}

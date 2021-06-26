//
//  User+CoreDataProperties.swift
//  
//
//  Created by Shashikant Bhadke on 25/06/21.
//
//

import Foundation
import CoreData

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var mail: String?
    @NSManaged public var password: String?
    @NSManaged public var userId: Int64
    @NSManaged public var records: NSSet?

}

// MARK: Generated accessors for records
extension User {

    @objc(addRecordsObject:)
    @NSManaged public func addToRecords(_ value: Record)

    @objc(removeRecordsObject:)
    @NSManaged public func removeFromRecords(_ value: Record)

    @objc(addRecords:)
    @NSManaged public func addToRecords(_ values: NSSet)

    @objc(removeRecords:)
    @NSManaged public func removeFromRecords(_ values: NSSet)

}

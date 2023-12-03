//
//  NoteMaster+CoreDataProperties.swift
//  ENotes
//
//

import Foundation
import CoreData


extension NoteMaster {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteMaster> {
        return NSFetchRequest<NoteMaster>(entityName: "NoteMaster")
    }

    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var timeStamp: Date?
    @NSManaged public var id: String?

}

extension NoteMaster : Identifiable {

}

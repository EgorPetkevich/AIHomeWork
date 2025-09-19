//
//  TaskMO+CoreDataProperties.swift
//  Storage
//
//  Created by George Popkich on 14.09.24.
//
//

import Foundation
import CoreData


extension TaskMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskMO> {
        return NSFetchRequest<TaskMO>(entityName: "TaskMO")
    }

    @NSManaged public var name: String?
    @NSManaged public var identifier: String?
    @NSManaged public var date: Date?
    @NSManaged public var chat: NSSet?

}

// MARK: Generated accessors for chat
extension TaskMO {

    @objc(addChatObject:)
    @NSManaged public func addToChat(_ value: ChatMO)

    @objc(removeChatObject:)
    @NSManaged public func removeFromChat(_ value: ChatMO)

    @objc(addChat:)
    @NSManaged public func addToChat(_ values: NSSet)

    @objc(removeChat:)
    @NSManaged public func removeFromChat(_ values: NSSet)

}

extension TaskMO : Identifiable {

}

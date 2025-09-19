//
//  ChatMO+CoreDataProperties.swift
//  Storage
//
//  Created by George Popkich on 14.09.24.
//
//

import Foundation
import CoreData


extension ChatMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatMO> {
        return NSFetchRequest<ChatMO>(entityName: "ChatMO")
    }

    @NSManaged public var date: Date?
    @NSManaged public var message: String?
    @NSManaged public var role: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var identifier: String?
    @NSManaged public var conversation: ConversationMO?
    @NSManaged public var task: TaskMO?

}

extension ChatMO : Identifiable {

}

//
//  NSPredicate+Const.swift
//  Storage
//
//  Created by George Popkich on 17.09.24.
//

import CoreData

public extension NSPredicate {
    
    enum Task {
        public static func task(byId id: String) -> NSPredicate {
            let idKeyPath = #keyPath(TaskMO.identifier)
            return .init(format: "\(idKeyPath) CONTAINS[cd] %@", id)
        }
        
        public static func task(in ids: [String]) -> NSPredicate {
            let idKeyPath = #keyPath(TaskMO.identifier)
            return NSCompoundPredicate(
                andPredicateWithSubpredicates:
                    [.init(format: "\(idKeyPath) IN %@", ids)])
        }
    }
    
    enum Conversation {
        public static func task(byId id: String) -> NSPredicate {
            let idKeyPath = #keyPath(ConversationMO.identifier)
            return .init(format: "\(idKeyPath) CONTAINS[cd] %@", id)
        }
        
        public static func task(in ids: [String]) -> NSPredicate {
            let idKeyPath = #keyPath(ConversationMO.identifier)
            return NSCompoundPredicate(
                andPredicateWithSubpredicates:
                    [.init(format: "\(idKeyPath) IN %@", ids)])
        }
    }
}

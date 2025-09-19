//
//  NSSortDescriptor+Const.swift
//  Storage
//
//  Created by George Popkich on 17.09.24.
//

import CoreData

public extension NSSortDescriptor {
    
    enum Task {
        public static func task(byID id: String) -> NSPredicate {
            let idKeypath = #keyPath(TaskMO.identifier)
            return .init(format: "\(idKeypath) CONTAINS[cd] %@", id)
        }
        
        public static var byDate: NSSortDescriptor {
            let dateKeyPath = #keyPath(TaskMO.date)
            return .init(key: dateKeyPath, ascending: false)
        }
    }
    
    enum Conversation {
        public static func task(byID id: String) -> NSPredicate {
            let idKeypath = #keyPath(ConversationMO.identifier)
            return .init(format: "\(idKeypath) CONTAINS[cd] %@", id)
        }
        
        public static var byDate: NSSortDescriptor {
            let dateKeyPath = #keyPath(ConversationMO.date)
            return .init(key: dateKeyPath, ascending: false)
        }
    }
    
}

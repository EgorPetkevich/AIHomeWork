//
//  ChatDTO.swift
//  Storage
//
//  Created by George Popkich on 13.09.24.
//

import CoreData


public struct ChatDTO {
    
    public typealias MO = ChatMO
    
    public var id: String
    public var date: Date
    public var message: String
    public var role: String
    public var imageUrl: String?
    
    public init(id: String,
                date: Date,
                message: String,
                role: String,
                imageUrl: String? = nil) {
        self.id = id
        self.date = date
        self.message = message
        self.role = role
        self.imageUrl = imageUrl
    }
    
    static public func fromMO(_ mo: ChatMO) -> ChatDTO? {
        
        guard
            let id = mo.identifier,
            let date = mo.date,
            let message = mo.message,
            let role = mo.role
        else { return nil }
        
        let imageUrl = mo.imageUrl
        
        return ChatDTO(id: id,
                       date: date,
                       message: message,
                       role: role,
                       imageUrl: imageUrl)
    }
    
    public func createMO(context: NSManagedObjectContext) -> ChatMO? {
        let chatMO = ChatMO(context: context)
        chatMO.apply(dto: self)
        return chatMO
    }
    
    public func apply(to chatMO: ChatMO) {
            chatMO.identifier = self.id
            chatMO.date = self.date
            chatMO.message = self.message
            chatMO.role = self.role
            chatMO.imageUrl = self.imageUrl
        }
    
    
}

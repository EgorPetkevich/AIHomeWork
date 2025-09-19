//
//  ConversationDTO.swift
//  Storage
//
//  Created by George Popkich on 13.09.24.
//

import Foundation
import CoreData

public struct ConversationDTO: DTODescription {
    
    public typealias MO = ConversationMO
    
    public var id: String
    public var date: Date
    public var name: String
    public var chat: [ChatDTO]
    
    public init(id: String,
                date: Date,
                name: String,
                chat: [ChatDTO]) {
        self.id = id
        self.date = date
        self.name = name
        self.chat = chat.sorted { $0.date < $1.date }
    }
    
    static public func fromMO(_ mo: ConversationMO) -> ConversationDTO? {
        guard
            let id = mo.identifier,
            let name = mo.name,
            let date = mo.date,
            let chatArray = mo.chat?.allObjects as? [ChatMO]
        else { return nil }
        
        let chatDTOs = chatArray.compactMap { chatMO -> ChatDTO? in
            guard let chatDTO = ChatDTO.fromMO(chatMO) else {
                print("Failed to convert ChatMO to ChatDTO: \(chatMO)")
                return nil
            }
            return chatDTO
        }
        
        return ConversationDTO(id: id, date: date, name: name, chat: chatDTOs)
    }
    
    public func createMO(context: NSManagedObjectContext) -> ConversationMO? {
        let conversationMO = ConversationMO(context: context)
        conversationMO.identifier = self.id
        conversationMO.name = self.name
        conversationMO.date = self.date
        
        let chatMOs = chat.compactMap { chatDTO -> ChatMO? in
            chatDTO.createMO(context: context)
        }
        
        conversationMO.chat = NSSet(array: chatMOs)
        
        return conversationMO
    }
    
}

//
//  ChatMO+CoreDataClass.swift
//  Storage
//
//  Created by George Popkich on 13.09.24.
//
//

import Foundation
import CoreData

@objc(ChatMO)
public class ChatMO: NSManagedObject {
    
    func toDTO() -> ChatDTO? {
        return ChatDTO.fromMO(self)
    }

    func apply(dto: ChatDTO) {
        self.identifier = dto.id
        self.date = dto.date
        self.message = dto.message
        self.role = dto.role
        self.imageUrl = dto.imageUrl
    }
    
    
    
}

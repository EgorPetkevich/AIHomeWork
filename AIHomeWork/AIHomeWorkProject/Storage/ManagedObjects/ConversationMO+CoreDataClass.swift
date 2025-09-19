//
//  ConversationMO+CoreDataClass.swift
//  Storage
//
//  Created by George Popkich on 13.09.24.
//
//

import Foundation
import CoreData

@objc(ConversationMO)
public class ConversationMO: NSManagedObject, MODescription {

    public func toDTO() -> (any DTODescription)? {
        return ConversationDTO.fromMO(self)
    }
    
    public func apply(dto: any DTODescription) {
        self.identifier = dto.id
        self.date = dto.date
        self.name = dto.name
    }
    
}

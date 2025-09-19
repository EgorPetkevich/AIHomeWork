//
//  TaskMO+CoreDataClass.swift
//  Storage
//
//  Created by George Popkich on 13.09.24.
//
//

import Foundation
import CoreData

@objc(TaskMO)
public class TaskMO: NSManagedObject, MODescription {

    public func toDTO() -> (any DTODescription)? {
        return TaskDTO.fromMO(self)
    }
    
    public func apply(dto: any DTODescription) {
        self.identifier = dto.id
        self.date = dto.date
        self.name = dto.name
    }
    
}

//
//  BaseStorage.swift
//  Storage
//
//  Created by George Popkich on 17.09.24.
//

import Foundation
import CoreData

public class BaseStorage<DTO: DTODescription> {
    
    public typealias CompletionHandler = (Bool) -> Void
    
    public init() {}
    
    // MARK: - Fetch TaskMO from Core Data
    func fetchMO(predicate: NSPredicate? = nil,
                 sortDescriptors: [NSSortDescriptor] = [],
                 context: NSManagedObjectContext)
    -> [DTO.MO] {
        let request = NSFetchRequest<DTO.MO>(entityName: "\(DTO.MO.self)")
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        let results = try? context.fetch(request)
        return results ?? []
    }
    
    // MARK: - Fetch TaskDTO from Core Data
    public func fetch(predicate: NSPredicate? = nil,
                      sortDescriptors: [NSSortDescriptor] = []
    ) -> [any DTODescription] {
        let context = CoreDataService.shared.mainContext
        return fetchMO(predicate: predicate,
                       sortDescriptors: sortDescriptors,
                       context: context)
        .compactMap { $0.toDTO() }
    }
    
    // MARK: - Create Task with DTO
    public func create(dto: any DTODescription,
                       completion: CompletionHandler? = nil) {
        let context = CoreDataService.shared.mainContext
        context.perform {
            let _ = dto.createMO(context: context)
            CoreDataService.shared.saveContext(context: context,
                                               completion: completion)
        }
    }
    
}


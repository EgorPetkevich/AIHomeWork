//
//  TaskStorage.swift
//  Storage
//
//  Created by George Popkich on 14.09.24.
//

import Foundation
import CoreData

public class TaskStorage: BaseStorage<TaskDTO> {
    
    public typealias CompletionHandler = (Bool) -> Void
    
    // MARK: - Fetch TaskDTO from Core Data
    public func fetch(predicate: NSPredicate? = nil,
                      sortDescriptors: [NSSortDescriptor] = []
    ) -> [TaskDTO] {
        let context = CoreDataService.shared.mainContext
        return fetchMO(predicate: predicate,
                       sortDescriptors: sortDescriptors,
                       context: context)
        .compactMap { $0.toDTO() as? TaskDTO}
    }
    
    // MARK: - Delete Task and remove all associated Chats
    public func delete(dto: TaskDTO,
                       completion: CompletionHandler? = nil) {
        let context = CoreDataService.shared.mainContext
        context.perform { [weak self] in
            guard let mo = self?.fetchMO(
                predicate: .Task.task(byId: dto.id),
                context: context).first
            else {
                completion?(false)
                return
            }
            
            context.delete(mo)
            CoreDataService.shared.saveContext(context: context,
                                               completion: completion)
        }
    }
    
    // MARK: - Add Chat to Task
    public func addChatAndUpdate(taskDTO: TaskDTO, 
                                 chatDTO: ChatDTO,
                                 completion: ((TaskDTO?) -> Void)?) {
        let context = CoreDataService.shared.mainContext
        context.perform {
            var updatedTaskDTO = taskDTO
            updatedTaskDTO.chat.append(chatDTO)
            
            guard let chatMO = chatDTO.createMO(context: context) else { return }
            
            
            if let existingTaskMO = self.fetchMO(
                predicate: .Task.task(byId: taskDTO.id),
                context: context
            ).first {
                existingTaskMO.addToChat(chatMO)
            }
            
            CoreDataService.shared.saveContext(context: context) { success in
                if success {
                    completion?(updatedTaskDTO)
                } else {
                    completion?(nil)
                }
            }
        }
    }
    
}

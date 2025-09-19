//
//  ConversationStorage.swift
//  Storage
//
//  Created by George Popkich on 16.09.24.
//

import Foundation
import CoreData

public class ConversationStorage: BaseStorage<ConversationDTO> {
    
    public typealias CompletionHandler = (Bool) -> Void
    
    // MARK: - Fetch TaskDTO from Core Data
    public func fetch(predicate: NSPredicate? = nil,
                      sortDescriptors: [NSSortDescriptor] = []
    ) -> [ConversationDTO] {
        let context = CoreDataService.shared.mainContext
        return super.fetchMO(predicate: predicate,
                       sortDescriptors: sortDescriptors,
                       context: context)
        .compactMap { $0.toDTO() as? ConversationDTO}
    }
    
    // MARK: - Delete Task and remove all associated Chats
    public func delete(dto: ConversationDTO,
                       completion: CompletionHandler? = nil) {
        let context = CoreDataService.shared.mainContext
        context.perform { [weak self] in
            guard let mo = self?.fetchMO(
                predicate: .Conversation.task(byId: dto.id),
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
    public func addChatAndUpdate(conversationDTO: ConversationDTO,
                                 chatDTO: ChatDTO,
                                 completion: ((ConversationDTO?) -> Void)?) {
        let context = CoreDataService.shared.mainContext
        context.perform {
            var updatedConvDTO = conversationDTO
            updatedConvDTO.date = .now
            updatedConvDTO.chat.append(chatDTO)
            
            guard let chatMO = chatDTO.createMO(context: context) else { return }
            
            
            if let existingConvMO = self.fetchMO(
                predicate: .Conversation.task(byId: conversationDTO.id),
                context: context
            ).first {
                existingConvMO.addToChat(chatMO)
                existingConvMO.date = updatedConvDTO.date
            }
            
            CoreDataService.shared.saveContext(context: context) { success in
                if success {
                    completion?(updatedConvDTO)
                } else {
                    completion?(nil)
                }
            }
        }
    }
    
    public func renameConversation(conversationDTO: ConversationDTO,
                                   newName: String,
                                   completion: ((ConversationDTO?) -> Void)?) {
        let context = CoreDataService.shared.mainContext
        context.perform {
            var updatedConvDTO = conversationDTO
            updatedConvDTO.name = newName
            
            if let existingConvMO = self.fetchMO(
                predicate: .Conversation.task(byId: conversationDTO.id),
                context: context
            ).first {
                existingConvMO.name = newName
            }
            
            CoreDataService.shared.saveContext(context: context) { success in
                if success {
                    completion?(updatedConvDTO)
                } else {
                    completion?(nil)
                }
            }
        }
    }

}

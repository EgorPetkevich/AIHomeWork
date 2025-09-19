//
//  ConversationStorage + Chat.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 17.09.24.
//

import Foundation
import Storage

struct AIExpertChatConvStorageUseCase: AIExpertChatConvStorageUseCaseProtocol {
    
    private let storage: ConversationStorage
    
    init(storage: ConversationStorage) {
        self.storage = storage
    }
    
    func create(dto: any DTODescription, completion: CompletionHandler?) {
        self.storage.create(dto: dto, completion: completion)
    }
    
    func addChatAndUpdate(conversationDTO: Storage.ConversationDTO,
                          chatDTO: ChatDTO,
                          completion: ((ConversationDTO?) -> Void)?) {
        self.storage.addChatAndUpdate(conversationDTO: conversationDTO,
                              chatDTO: chatDTO,
                              completion: completion)
    }
    
    func delete(dto: ConversationDTO, completion: CompletionHandler?) {
        self.storage.delete(dto: dto, completion: completion)
    }
    
    func renameConversation(conversationDTO: ConversationDTO,
                            newName: String,
                            completion: ((ConversationDTO?) -> Void)?) {
        self.storage.renameConversation(conversationDTO: conversationDTO,
                                newName: newName,
                                completion: completion)
    }
    
}

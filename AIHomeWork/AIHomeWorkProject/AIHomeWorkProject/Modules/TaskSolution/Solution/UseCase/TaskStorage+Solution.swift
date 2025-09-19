//
//  TaskStorage+Solution.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 17.09.24.
//

import Foundation
import Storage

struct SolutionTaskStorageUseCase: SolutionTaskStorageUseCaseProtocol {
    
    private let storage: TaskStorage
    
    init(storage: TaskStorage) {
        self.storage = storage
    }
    
    func create(taskDTO: TaskDTO,
                completion: CompletionHandler?) {
        self.storage.create(dto: taskDTO, completion: completion)
    }
    
    func addChatAndUpdate(taskDTO: TaskDTO,
                          chatDTO: ChatDTO,
                          completion: ((TaskDTO?) -> Void)?) {
        self.storage.addChatAndUpdate(taskDTO: taskDTO,
                                      chatDTO: chatDTO,
                                      completion: completion)
    }
    
    func delete(dto: TaskDTO, completion: CompletionHandler?) {
        self.storage.delete(dto: dto, completion: completion)
    }
    
}

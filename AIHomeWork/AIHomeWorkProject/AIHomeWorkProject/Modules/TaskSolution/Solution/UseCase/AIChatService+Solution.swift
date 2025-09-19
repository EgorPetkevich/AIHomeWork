//
//  AIChatService+Solution.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 17.09.24.
//

import Foundation
import Storage

struct SolutionOpenChatServiceUseCase: SolutionOpenChatServiceUseCaseProtocol {
    
    private let service: OpenAIChatService
    
    init(service: OpenAIChatService) {
        self.service = service
    }
    
    func fetchChat(dto: any DTODescription, 
                   completion: TaskCompletionHandler) {
        self.service.fetchChat(dto: dto, completion: completion)
    }
    
}

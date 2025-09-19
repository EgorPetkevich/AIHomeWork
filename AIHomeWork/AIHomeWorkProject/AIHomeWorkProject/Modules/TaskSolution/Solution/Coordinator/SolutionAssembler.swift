//
//  SolutionAssembler.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 11.09.24.
//

import Foundation
import Storage

final class SolutionAssembler {
    
    private init() {}
    
    static func make(container: Container,
                     coordinator: SolutionCoordinatorProtocol,
                     dto: TaskDTO,
                     subject: Subjects) -> SolutionVC {
        
        let adapter = ResultsAdapter()
        let chatService = SolutionOpenChatServiceUseCase(
            service: container.resolve())
        let storage = SolutionTaskStorageUseCase(
            storage: container.resolve())
        
        let solutionVM = SolutionVM(coordinator: coordinator,
                                    adapter: adapter,
                                    storage: storage,
                                    chatService: chatService,
                                    subject: subject,
                                    dto: dto)
        let solutionVC = SolutionVC(viewModel: solutionVM)
        return solutionVC
    }
}

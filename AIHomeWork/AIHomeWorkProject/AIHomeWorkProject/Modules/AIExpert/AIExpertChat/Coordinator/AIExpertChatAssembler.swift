//
//  AIExpertChatAssembler.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 12.09.24.
//

import Foundation
import Storage

final class AIExpertChatAssembler {
    
    private init() {}
    
    static func make(container: Container,
                     coordinator: AIExpertChatCoordinatorProtocol,
                     dto: (any DTODescription)?
    ) -> AIExpertChatVC {
        
        let chatService = AIExpertChatOpenAIServiceUseCase(
            service: container.resolve())
        let storage = AIExpertChatConvStorageUseCase(
            storage: container.resolve())
        let alertService = AIExpertChatAlertServiceUseCase(
            service: container.resolve())
        let keyboardHelper = AIExpertChatKeyboardHelperUseCase(
            keyboardHelper: container.resolve())
        let fileManager = AIExpertChatFileManagerServiceUseCase(
            manager: container.resolve())
        let adapter = AIExpertChatAdapter()
        
        let aiExpertChatVM = AIExpertChatVM(coordinator: coordinator,
                                            adapter: adapter,
                                            chatService: chatService,
                                            alertService: alertService,
                                            keyboardHelper: keyboardHelper,
                                            storage: storage,
                                            fileManager: fileManager,
                                            dto: dto)
        let aiExpertChatVC = AIExpertChatVC(viewModel: aiExpertChatVM)
        return aiExpertChatVC
    }
}

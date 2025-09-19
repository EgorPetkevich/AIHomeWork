//
//  ChatsHistoryAssembler.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 12.09.24.
//

import Foundation
import Storage

final class ChatsHistoryAssembler {
    
    private init() {}
    
    static func make(container: Container,
                     coordinator: ChatsHistoryCoordinatorProtocol
    ) -> ChatsHistoryVC {
        
        let adapter = ChatsHistoryAdapter()
        
        let chatsHistoryVM = ChatsHistoryVM(coordinator: coordinator,
                                            adapter: adapter,
                                            frcService: makeFRC())
        let chatsHistoryVC = ChatsHistoryVC(viewModel: chatsHistoryVM)
        return chatsHistoryVC
    }
    
    private static func makeFRC() -> FRCService<ConversationDTO> {
        .init { request in
            request.sortDescriptors = [.Conversation.byDate]
        }
    }
}

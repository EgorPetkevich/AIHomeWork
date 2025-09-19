//
//  HistoryAssembler.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 30.08.24.
//

import UIKit
import Storage

final class HistoryAssembler {
    
    private init() {}
    
    static func make(coordinator: HistoryCoordinatorProtocol) -> HistoryVC {
        let adapter = HistoryAdapter()
        
        let historyVM = HistoryVM(coordinator: coordinator,
                                  adapter: adapter,
                                  frcService: makeFRC())
        let historyVC = HistoryVC(viewModel: historyVM)
        return historyVC
    }
    
    private static func makeFRC() -> FRCService<TaskDTO> {
        .init { request in
            request.sortDescriptors = [.Task.byDate]
        }
    }
    
}

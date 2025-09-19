//
//  ResultsAssembler.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 9.09.24.
//

import Foundation
import Storage

final class ResultsAssembler {
    
    private init() {}
    
    static func make(container: Container,
                     coordinator: ResultsCoordinatorProtocol,
                     dto: TaskDTO) -> ResultsVC {
        
        let adapter = ResultsAdapter()
        let resultsVM = ResultsVM(coordinator: coordinator,
                                  adapter: adapter,
                                  dto: dto)
        let resultsVC = ResultsVC(viewModel: resultsVM)
        return resultsVC
    }
    
}

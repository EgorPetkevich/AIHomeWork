//
//  SolvedTaskAssembler.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 15.09.24.
//


import Foundation
import Storage

final class SolvedTaskAssembler {
    
    private init() {}
    
    static func make(container: Container,
                     coordinator: SolvedTaskCoordinatorProtocol, 
                     dto: TaskDTO) -> SolvedTaskVC {
        
        let adapter = SolvedTaskAdapter()
        let adaptyService =
        SolvedTaskAdaptyServiceUseCase(service: container.resolve())
        
        let solvedTaskVM = SolvedTaskVM(coordinator: coordinator, 
                                        adapter: adapter,
                                        adaptyService: adaptyService,
                                        dto: dto)
        
        let solvedTaskVC = SolvedTaskVC(viewModel: solvedTaskVM)
        
        return solvedTaskVC
    }
}

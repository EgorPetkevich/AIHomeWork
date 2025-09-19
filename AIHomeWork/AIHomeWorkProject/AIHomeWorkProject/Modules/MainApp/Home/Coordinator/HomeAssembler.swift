//
//  HomeAssembler.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 30.08.24.
//

import UIKit

final class HomeAssembler {
    
    private init() {}
    
    static func make(container: Container,
                     coordinator: HomeCoordinatorProtocol) -> HomeVC {
        let adapter: HomeAdapter = container.resolve()
        let adaptyService = HomeAdaptyServiceUseCase(service: container.resolve())
       
        let homeVM = HomeVM(coordinator: coordinator,
                            adapter: adapter,
                            adaptyService: adaptyService)
        let homeVC = HomeVC(viewModel: homeVM)
        return homeVC
    }
    
}

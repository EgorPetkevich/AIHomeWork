//
//  SettingsAssembler.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 2.09.24.
//

import Foundation

final class SettingsAssembler {
    
    private init() {}
    
    static func make(container: Container,
                     coordinator: SettingsCoordinatorProtocol) -> SettingsVC {
        let adapter: SettingsAdapter = container.resolve()
        
        let adaptyService = SettingsAdaptyService(service: container.resolve())
        let alertService = SettingsAlertServiceUseCase(service: container.resolve())
        
        let settingsVM = SettingsVM(coordinator: coordinator,
                                    adapter: adapter,
                                    adaptyService: adaptyService,
                                    alertService: alertService)
        let settingsVC = SettingsVC(viewModel: settingsVM)
        return settingsVC
    }
}


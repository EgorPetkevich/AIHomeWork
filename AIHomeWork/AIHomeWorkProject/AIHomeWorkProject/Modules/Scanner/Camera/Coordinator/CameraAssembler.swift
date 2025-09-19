//
//  CameraAssembler.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 5.09.24.
//

import Foundation

final class CameraAssembler {
    
    private init() {}
    
    static func make(container: Container, 
                     coordinator: CameraCoordinatorProtocol) -> CameraVC {
        
        let alertService = CameraAlertServiceUseCase(alertService: container.resolve())
        
        let cameraVM = CameraVM(coordinator: coordinator,
                                alertService: alertService)
        let cameraVC = CameraVC(viewModel: cameraVM)
        return cameraVC
    }
    
}

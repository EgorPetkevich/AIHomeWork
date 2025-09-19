//
//  AlertService+Camera.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 6.09.24.
//

import Foundation

struct CameraAlertServiceUseCase: CameraAlertServiceUseCaseProtocol {
    
    private let alertService: AlertService
    
    init(alertService: AlertService) {
        self.alertService = alertService
    }
    
    func showCameraError(title: String,
                         message: String,
                         goSettings: String,
                         goSettingsHandler: @escaping () -> Void) {
        alertService.showAlert(title: title,
                               message: message,
                               settingTitle: goSettings,
                               settingHandler: goSettingsHandler)
    }
    
    func hideAlert() {
        alertService.hideAlert()
    }
    
}

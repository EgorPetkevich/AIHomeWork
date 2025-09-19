//
//  AletService+Settings.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 26.09.24.
//

import Foundation

struct SettingsAlertServiceUseCase: SettingsAlertServiceUseCaseProtocol {
    
    let service: AlertService
    
    init(service: AlertService) {
        self.service = service
    }
    
    func showAlert(title: String,
                   message: String,
                   cancelTitle: String,
                   okTitle: String,
                   okHandler: @escaping () -> Void) {
        self.service.showAlert(title: title,
                       message: message,
                       cancelTitle: cancelTitle,
                       okTitle: okTitle,
                       okHandler: okHandler)
    }
    
    func showSuccessMessage(title: String, okTitle: String) {
        self.service.showAlert(title: title, okTitle: okTitle)
    }
    
}

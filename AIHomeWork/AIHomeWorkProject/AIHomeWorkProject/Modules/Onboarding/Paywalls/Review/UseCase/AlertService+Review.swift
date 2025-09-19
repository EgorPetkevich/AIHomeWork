//
//  AlertService+Review.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 25.09.24.
//

import Foundation

struct PaywallReviewAlertServiceUseCase: PaywallReviewAlertServiceUseCaseProtocol {
    
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
    
}

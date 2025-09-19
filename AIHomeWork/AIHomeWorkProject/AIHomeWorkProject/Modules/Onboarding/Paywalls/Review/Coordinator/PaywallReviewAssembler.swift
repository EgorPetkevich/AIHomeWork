//
//  PaywallReviewAssembler.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 28.08.24.
//

import UIKit

final class PaywallReviewAssembler {
    
    private init() {}
    
    static func make(container: Container,
                     coordinator: PaywallReviewCoordinatorProtocol
    ) -> PaywallReviewVC {
        
        let adaptyService = PaywallReviewAdaptyService(
            service: container.resolve())
        let alertService = PaywallReviewAlertServiceUseCase(
            service: container.resolve())
        
        let paywallReviewVM = PaywallReviewVM(coordinator: coordinator,
                                 adaptyService: adaptyService,
                                 alertService: alertService)
        let paywallReviewVC = PaywallReviewVC(viewModel: paywallReviewVM)
        return paywallReviewVC
    }
}

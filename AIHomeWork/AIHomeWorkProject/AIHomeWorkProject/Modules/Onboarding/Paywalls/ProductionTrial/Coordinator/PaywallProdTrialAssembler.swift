//
//  PaywallProdTrialAssembler.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 28.08.24.
//

import UIKit

final class PaywallProdTrialAssembler {
    
    private init() {}
    
    static func make(container: Container,
                     coordinator: PaywallProdTrialCoordinatorProtocol,
                     pageControlIsHiden: Bool
    ) -> PaywallProdTrialVC {
        
        let adaptyService = PaywallProdTrialAdaptyService(
            service: container.resolve())
        let alertService = PaywallProdTrialAlertServiceUseCase(
            service: container.resolve())
        
        let paywallProdTrialVM = PaywallProdTrialVM(coordinator: coordinator,
                                                    adaptyService: adaptyService,
                                                    alertService: alertService)
        let paywallProdTrialVC = PaywallProdTrialVC(
            viewModel: paywallProdTrialVM,
            pageControlIsHiden: pageControlIsHiden)
        return paywallProdTrialVC
    }
    
}

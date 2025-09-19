//
//  PaywallProdAssembler.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 28.08.24.
//

import UIKit

final class PaywallProdAssembler {
    
    private init() {}
    
    static func make(container: Container,
                     coordinator: PaywallProdCoordinatorProtocol,
                     pageControlIsHiden: Bool
    ) -> PaywallProdVC {
        
        let adaptyService = PaywallProdAdaptyService(
            service: container.resolve())
        
        let alertService = PaywallProdAlertServiceUseCase(
            service: container.resolve())
        
        let paywallProdVM = PaywallProdVM(coordinator: coordinator,
                                          adaptyService: adaptyService,
                                          alertService: alertService)
        let paywallProdVC = PaywallProdVC(viewModel: paywallProdVM,
                                          pageControlIsHiden: pageControlIsHiden)
        return paywallProdVC
    }
    
}

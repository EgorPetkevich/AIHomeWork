//
//  OnboardingProdThirdStepAssembler.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 27.08.24.
//

import UIKit

final class OnboardingProdThirdStepAssembler {
    
    private init() {}
    
    static func make(container: Container,
                     coordinator: OnboardingProdThirdStepCoordinatorProtocol
    ) -> OnboardingProdThirdStepVC {
        let adaptyService = 
        OnboardingProdAdaptyServiceUseCase(serivce: container.resolve())
        
        let onboardingProdThirdStepVM =
        OnboardingProdThirdStepVM(coordinator: coordinator,
                                  adaptyService: adaptyService)
        let onboardingProdThirdStepVC =
        OnboardingProdThirdStepVC(viewModel: onboardingProdThirdStepVM)
        
        return onboardingProdThirdStepVC
    }
    
}

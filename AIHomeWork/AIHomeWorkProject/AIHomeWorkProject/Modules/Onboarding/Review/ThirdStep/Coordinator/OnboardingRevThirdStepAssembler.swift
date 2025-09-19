//
//  OnboardingRevThirdStepAssembler.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 27.08.24.
//

import UIKit

final class OnboardingRevThirdStepAssembler {
    
    private init() {}
    
    static func make(container: Container,
                     coordinator: OnboardingRevThirdStepCoordinatorProtocol
    ) -> OnboardingRevThirdStepVC {
        let adaptyService =
        OnboardingRevAdaptyServiceUseCase(serivce: container.resolve())
        
        let onboardingRevThirdStepVM =
        OnboardingRevThirdStepVM(coordinator: coordinator,
                                 adaptyService: adaptyService)
        let onboardingRevThirdStepVC =
        OnboardingRevThirdStepVC(viewModel: onboardingRevThirdStepVM)
        
        return onboardingRevThirdStepVC
    }
    
}

//
//  OnboardingRevSecondStepAssembler.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 27.08.24.
//

import UIKit

final class OnboardingRevSecondStepAssembler {
    
    private init() {}
    
    static func make(
        coordinator: OnboardingRevSecondStepCoordinatorProtocol
    ) -> OnboardingRevSecondStepVC {
        let onboardingRevSecondStepVM =
        OnboardingRevSecondStepVM(coordinator: coordinator)
        let onboardingRevSecondStepVC =
        OnboardingRevSecondStepVC(viewModel: onboardingRevSecondStepVM)
        
        return onboardingRevSecondStepVC
    }
    
}

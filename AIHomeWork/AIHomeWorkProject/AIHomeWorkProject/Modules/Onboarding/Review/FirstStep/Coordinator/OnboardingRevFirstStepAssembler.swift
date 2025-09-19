//
//  OnboardingRevFirstStepAssembler.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 27.08.24.
//

import UIKit

final class OnboardingRevFirstStepAssembler {
    
    private init() {}
    
    static func make(
        coordinator: OnboardingRevFirstStepCoordinatorProtocol
    ) -> OnboardingRevFirstStepVC {
        let onboardingRevFirstStepVM =
        OnboardingRevFirstStepVM(coordinator: coordinator)
        let onboardingRevFirstStepVC =
        OnboardingRevFirstStepVC(viewModel: onboardingRevFirstStepVM)
        
        return onboardingRevFirstStepVC
    }
    
}

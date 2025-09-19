//
//  OnboardingProdFirstStepAssembler.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 26.08.24.
//

import UIKit

final class OnboardingProdFirstStepAssembler {
    
    private init() {}
    
    static func make(
        coordinator: OnboardingProdFirstStepCoordinatorProtocol
    ) -> OnboardingProdFirstStepVC {
        let onboardingProdFirstStepVM =
        OnboardingProdFirstStepVM(coordinator: coordinator)
        let onboardingProdFirstStepVC =
        OnboardingProdFirstStepVC(viewModel: onboardingProdFirstStepVM)
        
        return onboardingProdFirstStepVC
    }
    
}

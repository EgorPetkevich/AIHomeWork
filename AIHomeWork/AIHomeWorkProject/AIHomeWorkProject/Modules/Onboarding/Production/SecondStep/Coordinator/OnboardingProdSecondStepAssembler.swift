//
//  OnboardingProdSecondStepAssembler.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 26.08.24.
//

import UIKit

final class OnboardingProdSecondStepAssembler {
    
    private init() {}
    
    static func make(
        coordinator: OnboardingProdSecondStepCoordinatorProtocol
    ) -> OnboardingProdSecondStepVC {
        let onboardingProdSecondStepVM =
        OnboardingProdSecondStepVM(coordinator: coordinator)
        let onboardingProdSecondStepVC =
        OnboardingProdSecondStepVC(viewModel: onboardingProdSecondStepVM)
        
        return onboardingProdSecondStepVC
    }
    
}

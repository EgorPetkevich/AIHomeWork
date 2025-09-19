//
//  OnboardingProdFirstStepVM.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 26.08.24.
//

import Foundation

protocol OnboardingProdFirstStepCoordinatorProtocol: AnyObject {
    func nextStep()
}

final class OnboardingProdFirstStepVM {
    
    weak var coordinator: OnboardingProdFirstStepCoordinatorProtocol?
    
    init(coordinator: OnboardingProdFirstStepCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
}

extension OnboardingProdFirstStepVM: OnboardingProdFirstStepViewModelProtocol {
    
    func activityButtonDidTap() {
        coordinator?.nextStep()
    }
    
}

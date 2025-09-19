//
//  OnboardingRevFirstStepVM.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 27.08.24.
//

import Foundation

protocol OnboardingRevFirstStepCoordinatorProtocol: AnyObject {
    func nextStep()
}

final class OnboardingRevFirstStepVM {
    
    weak var coordinator: OnboardingRevFirstStepCoordinatorProtocol?
    
    init(coordinator: OnboardingRevFirstStepCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
}

extension OnboardingRevFirstStepVM: OnboardingRevFirstStepViewModelProtocol {
    
    func activityButtonDidTap() {
        coordinator?.nextStep()
    }
    
}

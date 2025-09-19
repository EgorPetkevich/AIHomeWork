//
//  OnboardingRevSecondStepVM.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 27.08.24.
//

import Foundation
import StoreKit

protocol OnboardingRevSecondStepCoordinatorProtocol: AnyObject {
    func nextStep()
}

final class OnboardingRevSecondStepVM {
    
    weak var coordinator: OnboardingRevSecondStepCoordinatorProtocol?
    
    init(coordinator: OnboardingRevSecondStepCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
}

extension OnboardingRevSecondStepVM: OnboardingRevSecondStepViewModelProtocol {
    
    func viewDidLoad() {
        SKStoreReviewController.requestReviewInCurrentScene()
    }
    
    func activityButtonDidTap() {
        coordinator?.nextStep()
    }
    
}

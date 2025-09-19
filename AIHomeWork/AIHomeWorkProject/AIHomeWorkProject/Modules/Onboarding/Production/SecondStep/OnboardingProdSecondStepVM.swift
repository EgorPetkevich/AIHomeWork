//
//  OnboardingProdSecondStepVM.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 26.08.24.
//

import Foundation
import StoreKit

protocol OnboardingProdSecondStepCoordinatorProtocol: AnyObject {
    func nextStep()
}

final class OnboardingProdSecondStepVM {
    
    weak var coordinator: OnboardingProdSecondStepCoordinatorProtocol?
    
    init(coordinator: OnboardingProdSecondStepCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
}

extension OnboardingProdSecondStepVM: 
    OnboardingProdSecondStepViewModelProtocol {
    
    func activityButtonDidTap() {
        coordinator?.nextStep()
    }
    
    func viewDidLoad() {
        SKStoreReviewController.requestReviewInCurrentScene()
    }
    
}

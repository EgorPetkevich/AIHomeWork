//
//  OnboardingProdThirdStepVM.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 27.08.24.
//

import Foundation

protocol OnboardingProdThirdStepCoordinatorProtocol: AnyObject {
    func openPaywall()
    func finish()
}

protocol OnboardingProdAdaptyServiceUseCaseProtocol {
    var isPremium: Bool { get }
}

final class OnboardingProdThirdStepVM {
    
    weak var coordinator: OnboardingProdThirdStepCoordinatorProtocol?
    
    private var adaptyService: OnboardingProdAdaptyServiceUseCaseProtocol
    
    init(coordinator: OnboardingProdThirdStepCoordinatorProtocol,
         adaptyService: OnboardingProdAdaptyServiceUseCaseProtocol) {
        self.coordinator = coordinator
        self.adaptyService = adaptyService
    }
    
}

extension OnboardingProdThirdStepVM:
    OnboardingProdThirdStepProdViewModelProtocol {
    
    func activityButtonDidTap() {
        ParametersHelper.set(.prodWasShow, value: true)
        if adaptyService.isPremium {
            coordinator?.finish()
        } else {
            coordinator?.openPaywall()
        }
    }
    
}

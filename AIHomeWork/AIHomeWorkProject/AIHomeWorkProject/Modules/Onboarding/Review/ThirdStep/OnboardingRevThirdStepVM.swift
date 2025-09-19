//
//  OnboardingRevThirdStepVM.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 27.08.24.
//

import Foundation

protocol OnboardingRevThirdStepCoordinatorProtocol: AnyObject {
    func openPaywallRev()
    func finish()
}

protocol OnboardingRevAdaptyServiceUseCaseProtocol {
    var isPremium: Bool { get }
}

final class OnboardingRevThirdStepVM {
    
    weak var coordinator: OnboardingRevThirdStepCoordinatorProtocol?
    
    private var adaptyService: OnboardingRevAdaptyServiceUseCaseProtocol
    
    init(coordinator: OnboardingRevThirdStepCoordinatorProtocol, 
         adaptyService: OnboardingRevAdaptyServiceUseCaseProtocol) {
        self.coordinator = coordinator
        self.adaptyService = adaptyService
    }
    
}

extension OnboardingRevThirdStepVM:
    OnboardingRevThirdStepProdViewModelProtocol {
    
    func activityButtonDidTap() {
        ParametersHelper.set(.reviewWasShown, value: true)
        if adaptyService.isPremium {
            coordinator?.finish()
        } else {
            coordinator?.openPaywallRev()
        }
    }
    
}

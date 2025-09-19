//
//  OnboardingRevSecondStepCoordinator.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 27.08.24.
//

import Foundation

final class OnboardingRevSecondStepCoordinator: Coordinator {
    
    private var rootVC: OnboardingRevSecondStepVC?
    private let container: Container
    private let onboardingType: Onboarding.Options
    
    init(container: Container, onboardingType: Onboarding.Options) {
        self.container = container
        self.onboardingType = onboardingType
    }
    
    override func start() -> OnboardingRevSecondStepVC {
        let onboardingProdSecondStepVC =
        OnboardingRevSecondStepAssembler.make(coordinator: self)
        rootVC = onboardingProdSecondStepVC
        return onboardingProdSecondStepVC
        
    }
    
}

extension OnboardingRevSecondStepCoordinator:
    OnboardingRevSecondStepCoordinatorProtocol {
    
    func nextStep() {
        let coordinator = OnboardingRevThirdStepCoordinator(
            container: container,
            onboardingType: onboardingType)
        self.addChildCoordinator(coordinator)
        
        let onboardingRevSecondStepVC = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.removeChildCoordinator(coordinator)
            self?.finish()
            onboardingRevSecondStepVC.dismiss(animated: true)
        }
        
        onboardingRevSecondStepVC.modalPresentationStyle = .fullScreen
        rootVC?.presentDetail(onboardingRevSecondStepVC, 0.40)
    }
    
}


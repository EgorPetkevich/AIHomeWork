//
//  OnboardingProdSecondStepCoordinator.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 27.08.24.
//

import Foundation

import UIKit

final class OnboardingProdSecondStepCoordinator: Coordinator {
    
    private var rootVC: UIViewController?
    
    private let container: Container
    private let onboardingType: Onboarding.Options
    
    init(container: Container, onboardingType: Onboarding.Options) {
        self.container = container
        self.onboardingType = onboardingType
    }
    
    override func start() -> UIViewController {
        let onboardingProdSecondStepVC =
        OnboardingProdSecondStepAssembler.make(coordinator: self)
        rootVC = onboardingProdSecondStepVC
        return onboardingProdSecondStepVC
        
    }
    
}

extension OnboardingProdSecondStepCoordinator:
    OnboardingProdSecondStepCoordinatorProtocol {
    
    func nextStep() {
        let coordinator = OnboardingProdThirdStepCoordinator(
            container: container,
            onboardingType: onboardingType)
        self.addChildCoordinator(coordinator)
        
        let onboardingProdSecondStepVC = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.removeChildCoordinator(coordinator)
            self?.finish()
            onboardingProdSecondStepVC.dismiss(animated: true)
        }
        
        onboardingProdSecondStepVC.modalPresentationStyle = .fullScreen
        rootVC?.presentDetail(onboardingProdSecondStepVC, 0.40)
    }
    
}

//
//  OnbordingProdFirstStepCoordinator.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 26.08.24.
//

import Foundation

import UIKit

final class OnboardingProdFirstStepCoordinator: Coordinator {
    
    private var rootVC: UIViewController?
    private let container: Container
    private let onboardingType: Onboarding.Options
    
    init(container: Container,  onboardingType: Onboarding.Options) {
        self.container = container
        self.onboardingType = onboardingType
    }
    
    override func start() -> UIViewController? {
        let onboardingProdFirstStepVC =
        OnboardingProdFirstStepAssembler.make(coordinator: self)
        rootVC = onboardingProdFirstStepVC
        return onboardingProdFirstStepVC
    }
    
}

extension OnboardingProdFirstStepCoordinator:
    OnboardingProdFirstStepCoordinatorProtocol {
    
    func nextStep() {
        let coordinator = OnboardingProdSecondStepCoordinator(
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

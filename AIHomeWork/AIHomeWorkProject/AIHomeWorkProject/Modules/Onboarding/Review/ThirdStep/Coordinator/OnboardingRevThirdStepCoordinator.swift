//
//  OnboardingRevThirdStepCoordinator.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 27.08.24.
//

import Foundation

final class OnboardingRevThirdStepCoordinator: Coordinator {
    
    private var rootVC: OnboardingRevThirdStepVC?
    private let container: Container
    private let onboardingType: Onboarding.Options
    
    init(container: Container, onboardingType: Onboarding.Options) {
        self.container = container
        self.onboardingType = onboardingType
    }
    
    override func start() -> OnboardingRevThirdStepVC {
        let vc = OnboardingRevThirdStepAssembler.make(container: container, 
                                                      coordinator: self)
        self.rootVC = vc
        return vc
    }
    
}

extension OnboardingRevThirdStepCoordinator:
    OnboardingRevThirdStepCoordinatorProtocol {
    
    func openPaywallRev() {
        let coordinator =
        PaywallReviewCoordinator(container: container)
        children.append(coordinator)
        
        let vc = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            self?.finish()
            vc.dismiss(animated: true)
        }
        
        vc.modalPresentationStyle = .fullScreen
        rootVC?.presentDetail(vc, 0.40)
    }
    
}

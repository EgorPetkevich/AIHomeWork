//
//  OnboardingProdThirdStepCoordinator.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 27.08.24.
//

import Foundation

import UIKit

final class OnboardingProdThirdStepCoordinator: Coordinator {
    
    private var rootVC: UIViewController?
    private let container: Container
    private let onboardingType: Onboarding.Options
    
    init(container: Container, onboardingType: Onboarding.Options) {
        self.container = container
        self.onboardingType = onboardingType
    }
    
    override func start() -> UIViewController {
        let vc = OnboardingProdThirdStepAssembler.make(container: container,
                                                       coordinator: self)
        self.rootVC = vc
        return vc
    }
    
}

extension OnboardingProdThirdStepCoordinator:
    OnboardingProdThirdStepCoordinatorProtocol {
    
    func openPaywall() {
        switch onboardingType {
        case .production:
            openPaywallProd()
        case .productionWithTrial:
            openPaywallProdTrial()
        default: return
        }
    }
    
    private func openPaywallProd() {
        let coordinator =
        PaywallProdCoordinator(container: container,
                               pageControlIsHiden: false)
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
    
    private func openPaywallProdTrial() {
        let coordinator =
        PaywallProdTrialCoordinator(container: container,
                                    pageControlIsHiden: false)
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

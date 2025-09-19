//
//  AppCoordinator.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 23.08.24.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    private var adaptyService: AdaptyService
    private let container: Container
    private let windowManager: WindowManager
    
    init(container: Container) {
        self.container = container
        self.windowManager = container.resolve()
        self.adaptyService = container.resolve()
    }
    
    func getCurrentViewController() -> UIViewController? {
        let currentVC = windowManager.get(type: .main).rootViewController
        if currentVC is PaywallProdVC || currentVC is PaywallReviewVC || currentVC is PaywallProdTrialVC {
            return nil
        } else if let rootVC = windowManager.rootVC {
            return rootVC
        } else {
            return currentVC
        }
        
    }
    
    func startFromForeground() {
        guard adaptyService.isPremium == false else { return }
        guard let remoteConfig = adaptyService.remoteConfig else { return }
        
        let review = remoteConfig.review
            
        if review {
            guard
                let currentVC = self.getCurrentViewController(),
                ParametersHelper.get(.reviewWasShown) == true
            else { return }
            currentVC.presentedViewController?.dismiss(animated: true)
            let paywallReview = self.getPaywallReview()
            paywallReview.modalPresentationStyle = .fullScreen
            currentVC.present(paywallReview, animated: true)
        } else if review == false {
            guard
                let currentVC = self.getCurrentViewController(),
                ParametersHelper.get(.prodWasShow) == true
            else { return }
            currentVC.presentedViewController?.dismiss(animated: true)
            let supportTrial = remoteConfig.supportTrial
            let prodPaywall = self.getProduction(supportTrial: supportTrial)
            prodPaywall.modalPresentationStyle = .fullScreen
            currentVC.present(prodPaywall, animated: true)
        }
        
    }
    
    func startApp() {
        if !ParametersHelper.get(.createTaskImagesDirectory) {
            FileManagerService.creatDierectory(name: .TaskImages)
            ParametersHelper.set(.createTaskImagesDirectory, value: true)
        }
        adaptyService.checkStatus { [weak self] isPremium in
            guard let isPremium else { return }
            self?.adaptyService.getRemoteConfig { remoteConfig in
                guard
                    let review = remoteConfig?.review,
                    let closeTimer = remoteConfig?.closeTimer
                else { return }
                ParametersHelper.setTimer(closeTimer)
                
                if review {
                    if !ParametersHelper.get(.reviewWasShown) {
                        self?.openOnboardingReview()
                    } else {
                        if !isPremium { self?.openPaywallReview() } else { self?.openMainApp() }
                    }
                    return
                    
                } else if review == false {
                    guard
                        let supportTrial = remoteConfig?.supportTrial
                    else { return }
                    
                    self?.openProduction(supportTrial: supportTrial,
                                             isPremium: isPremium)
                }
            }
        }
    }
    
    private func openProduction(supportTrial: Bool, isPremium: Bool) {
        if supportTrial {
            if !ParametersHelper.get(.prodWasShow) {
                openOnboardingProductionWithTrial()
            } else {
                if !isPremium { openPaywallProdTrial() } else { openMainApp() }
            }
        } else {
            if !ParametersHelper.get(.prodWasShow) {
                openOnboardingProduction()
            } else {
                if !isPremium { openPaywallProd() } else { openMainApp() }
            }
        }
    }
    
    private func getProduction(supportTrial: Bool) -> UIViewController {
        if supportTrial {
            return getPaywallProdTrial()
        } else {
            return getPaywallProd()
        }
    }
    
}

//MARK: - Main App
extension AppCoordinator {
    
    private func openMainApp() {
        let coordinator = MainTabBarCoordinator(container: container)
        children.append(coordinator)
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            self?.startApp()
        }
        let vc = coordinator.start()
        
        let window = windowManager.get(type: .main)
        window.rootViewController = vc
        windowManager.show(type: .main)
    }
    
}

//MARK: - Onboarding Production
extension AppCoordinator {
    
    private func openOnboardingProd() {
        let coordinator =
        OnboardingProdFirstStepCoordinator(
            container: container,
            onboardingType: Onboarding.Options.production
        )
        children.append(coordinator)
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            self?.openMainApp()
        }
        let vc = coordinator.start()
        
        let window = windowManager.get(type: .main)
        window.rootViewController = vc
        windowManager.show(type: .main)
    }
    
}

//MARK: - Onboarding
extension AppCoordinator {
    
    private func openOnboardingReview() {
        let coordinator =
        OnboardingRevFirstStepCoordinator(
            container: container,
            onboardingType: Onboarding.Options.review
        )
        children.append(coordinator)
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            self?.openMainApp()
        }
        let vc = coordinator.start()
        
        let window = windowManager.get(type: .main)
        window.rootViewController = vc
        windowManager.show(type: .main)
    }
    
    private func openOnboardingProduction() {
        let coordinator =
        OnboardingProdFirstStepCoordinator(
            container: container,
            onboardingType: Onboarding.Options.production
        )
        children.append(coordinator)
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            self?.openMainApp()
        }
        let vc = coordinator.start()
        
        let window = windowManager.get(type: .main)
        window.rootViewController = vc
        windowManager.show(type: .main)
    }
    
    private func openOnboardingProductionWithTrial() {
        let coordinator =
        OnboardingProdFirstStepCoordinator(
            container: container,
            onboardingType: Onboarding.Options.productionWithTrial
        )
        children.append(coordinator)
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            self?.openMainApp()
        }
        let vc = coordinator.start()
        
        let window = windowManager.get(type: .main)
        window.rootViewController = vc
        windowManager.show(type: .main)
    }
    
}

//MARK: - Paywall
extension AppCoordinator {
    
    // Paywall without trial
    private func openPaywallProd() {
        let coordinator =
        PaywallProdCoordinator(container: container,
                               pageControlIsHiden: false)
        children.append(coordinator)
        
        let vc = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            self?.openMainApp()
            vc.dismiss(animated: true)
        }
        
        let window = windowManager.get(type: .main)
        window.rootViewController = vc
        windowManager.show(type: .main)
    }
    
    // Paywall with 3-day trial
    private func openPaywallProdTrial() {
        let coordinator =
        PaywallProdTrialCoordinator(container: container,
                                    pageControlIsHiden: false)
        children.append(coordinator)
        
        let vc = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            self?.openMainApp()
            vc.dismiss(animated: true)
        }
        
        let window = windowManager.get(type: .main)
        window.rootViewController = vc
        windowManager.show(type: .main)
    }

    
    private func openPaywallReview() {
        let coordinator =
        PaywallReviewCoordinator(container: container)
        children.append(coordinator)
        
        let vc = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            self?.openMainApp()
            vc.dismiss(animated: true)
        }
        
        let window = windowManager.get(type: .main)
        window.rootViewController = vc
        windowManager.show(type: .main)
    }
    
}

//MARK: - Get Paywalls
extension AppCoordinator {
    
    func getPaywallReview() -> UIViewController {
        let coordinator =
        PaywallReviewCoordinator(container: container)
        let vc = coordinator.start()
        
        children.append(coordinator)
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            vc.dismiss(animated: true)
        }
        
        return vc
    }
    
    func getPaywallProdTrial() -> UIViewController {
        let coordinator =
        PaywallProdTrialCoordinator(container: container,
                                    pageControlIsHiden: true)
        let vc = coordinator.start()
        
        children.append(coordinator)
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            vc.dismiss(animated: true)
        }
        
        return vc
    }
    
    func getPaywallProd() -> UIViewController {
        let coordinator =
        PaywallProdCoordinator(container: container,
                               pageControlIsHiden: true)
        let vc = coordinator.start()
        
        children.append(coordinator)
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            vc.dismiss(animated: true)
        }
        
        return vc
    }
    
}

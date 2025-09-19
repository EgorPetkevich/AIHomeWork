//
//  HomeCoordinator.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 30.08.24.
//

import Foundation

final class HomeCoordinator: Coordinator {
    
    private let container: Container
    private var rootVC: HomeVC?
    private var coordinator: MainTabBarCoordinatorProtocol
    
    init(container: Container, coordinator: MainTabBarCoordinatorProtocol) {
        self.container = container
        self.coordinator = coordinator
    }
    
    override func start() -> HomeVC {
        let homeVC = HomeAssembler.make(container: container, coordinator: self)
        rootVC = homeVC
        return homeVC
    }
    
}

extension HomeCoordinator: HomeCoordinatorProtocol {
    
    func openTask(type: Subjects) {
        let coordinator = TaskCoordinator(container: container, subject: type)
        self.addChildCoordinator(coordinator)
        
        let taskVC = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.removeChildCoordinator(coordinator)
            taskVC.dismiss(animated: true)
        }
        
        coordinator.finishAndOpenScanner = { [weak self] coordinator in
            self?.removeChildCoordinator(coordinator)
            taskVC.dismiss(animated: true)
            self?.coordinator.cameraDidTap()
        }
        
        taskVC.modalPresentationStyle = .fullScreen
        
        rootVC?.present(taskVC, animated: true)
    }
    
    func openSettings() {
        let coordinator = SettingsCoordinator(container: container)
        self.addChildCoordinator(coordinator)
        
        let settingsVC = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.removeChildCoordinator(coordinator)
            settingsVC.dismiss(animated: true)
        }
        
        settingsVC.modalPresentationStyle = .fullScreen
        
        rootVC?.present(settingsVC, animated: true)
    }
    
    func openChatsHistory() {
        let coordinator = ChatsHistoryCoordinator(container: container)
        self.addChildCoordinator(coordinator)
        
        let chatsHistoryVC = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.removeChildCoordinator(coordinator)
            chatsHistoryVC.dismiss(animated: true)
        }
        
        chatsHistoryVC.modalPresentationStyle = .fullScreen
        
        rootVC?.present(chatsHistoryVC, animated: true)
    }
    
    func showPaywallReview() {
        let coordinator =
        PaywallReviewCoordinator(container: container)
        let vc = coordinator.start()
        
        children.append(coordinator)
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            vc.dismiss(animated: true)
        }
        
        vc.modalPresentationStyle = .fullScreen
        rootVC?.present(vc, animated: true)
    }
    
    func showPaywallProdTrial() {
        let coordinator =
        PaywallProdTrialCoordinator(container: container,
                                    pageControlIsHiden: true)
        let vc = coordinator.start()
        
        children.append(coordinator)
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            vc.dismiss(animated: true)
        }
        
        vc.modalPresentationStyle = .fullScreen
        rootVC?.present(vc, animated: true)
    }
    
    func showPaywallProd() {
        let coordinator =
        PaywallProdCoordinator(container: container,
                               pageControlIsHiden: true)
        let vc = coordinator.start()
        
        children.append(coordinator)
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            vc.dismiss(animated: true)
        }
        
        vc.modalPresentationStyle = .fullScreen
        rootVC?.present(vc, animated: true)
    }
    
    
}

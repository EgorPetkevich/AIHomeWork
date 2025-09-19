//
//  MainTabBarCoordinator.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 30.08.24.
//

import UIKit

protocol MainTabBarCoordinatorProtocol: AnyObject {
    func cameraDidTap()
    func homeDidTap()
}

final class MainTabBarCoordinator: Coordinator {
    
    private enum TabBarItems: Int {
        case home
        case scaner
        case history
    }
    
    private var rootVC: UIViewController?
    private let container: Container
    private var tabBar: UITabBarController?
    
    init(container: Container) {
        self.container = container
    }
    
    override func start() -> MainTabBarVC {
        let tabBar = MainTabBarAssembler.make(coordinator: self)
        tabBar.viewControllers = [makeHomeModule(),
                                  makeScanerModule(),
                                  makeHistoryModule()]

        tabBar.selectedIndex = TabBarItems.home.rawValue
        self.tabBar = tabBar
        rootVC = tabBar
        return tabBar
    }
    
    
}

extension MainTabBarCoordinator: MainTabBarCoordinatorProtocol {
    func homeDidTap() {
        tabBar?.selectedIndex = TabBarItems.home.rawValue
    }
    
    func cameraDidTap() {
        let coordinator = CameraCoordinator(container: container)
        self.addChildCoordinator(coordinator)
        
        let cameraVC = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.removeChildCoordinator(coordinator)
            cameraVC.dismiss(animated: true)
        }
        
        cameraVC.modalPresentationStyle = .fullScreen
        rootVC?.present(cameraVC, animated: true)
    }
    
}

//MARK: - Create Modules
extension MainTabBarCoordinator {
    
    private func makeHomeModule() -> HomeVC {
        let coordinator = HomeCoordinator(container: container,
                                          coordinator: self)
        self.addChildCoordinator(coordinator)
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.removeChildCoordinator(coordinator)
            self?.finish()
        }
        let homeVC = coordinator.start()
        return homeVC
    }
    
    private func makeScanerModule() -> UIViewController {
        let vc = UIViewController()
        vc.tabBarItem.isEnabled = false
        return vc
    }
    
    private func makeHistoryModule() -> HistoryVC {
        let coordinator = HistoryCoordinator(container: container,
                                             coordinator: self)
        self.addChildCoordinator(coordinator)
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.removeChildCoordinator(coordinator)
            self?.finish()
        }
        let historyVC = coordinator.start()
        return historyVC
    }
    
}

//
//  HistoryCoordinator.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 30.08.24.
//

import Foundation
import Storage

final class HistoryCoordinator: Coordinator {
    
    private var rootVC: HistoryVC?
    private var container: Container
    private var coordinator: MainTabBarCoordinatorProtocol
    
    init(container: Container, coordinator: MainTabBarCoordinatorProtocol) {
        self.container = container
        self.coordinator = coordinator
    }
    
    override func start() -> HistoryVC {
        let historyVC = HistoryAssembler.make(coordinator: self)
        rootVC = historyVC
        return historyVC
    }
    
}

extension HistoryCoordinator: HistoryCoordinatorProtocol {
    
    func openSolvedTask(dto: TaskDTO) {
        let coordinator = SolvedTaskCoordinator(container: container,
                                                dto: dto)
        self.addChildCoordinator(coordinator)
        
        let solvedTaskVC = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.removeChildCoordinator(coordinator)
            solvedTaskVC.dismissDetail()
        }
        
        solvedTaskVC.modalPresentationStyle = .fullScreen
        
        rootVC?.presentDetail(solvedTaskVC)
    }
    
    func openHomeScreen() {
        coordinator.homeDidTap()
    }
    
    
}

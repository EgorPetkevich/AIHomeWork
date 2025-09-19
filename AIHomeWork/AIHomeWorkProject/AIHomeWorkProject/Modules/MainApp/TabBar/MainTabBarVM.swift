//
//  MainTabBarVM.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 30.08.24.
//

import UIKit

final class MainTabBarVM {
    
    private weak var coordinator: MainTabBarCoordinatorProtocol?
    
    init(coordinator: MainTabBarCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
}

extension MainTabBarVM: MainTabBarViewModelProtocol {
    
    func cameraButtonDidTap() {
        coordinator?.cameraDidTap()
    }
    
}

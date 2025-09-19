//
//  MainTabBarAssembler.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 30.08.24.
//

import UIKit

final class MainTabBarAssembler {
    
    private init() {}
    
    static func make(
        coordinator: MainTabBarCoordinatorProtocol
    ) -> MainTabBarVC {
        let mainTabBarVM = MainTabBarVM(coordinator: coordinator)
        let mainTabBarVC = MainTabBarVC(viewModel: mainTabBarVM)
        return mainTabBarVC
    }
    
}

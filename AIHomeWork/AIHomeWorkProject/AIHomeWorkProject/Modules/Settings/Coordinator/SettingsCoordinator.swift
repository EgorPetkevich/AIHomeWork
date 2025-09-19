//
//  SettingsCoordinator.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 2.09.24.
//

import UIKit

final class SettingsCoordinator: Coordinator {
    
    private let container: Container
    private var rootVC: SettingsVC?
    
    init(container: Container) {
        self.container = container
    }
    
    override func start() -> SettingsVC {
        let settingsVC = SettingsAssembler.make(container: container,
                                                coordinator: self)
        rootVC = settingsVC
        return settingsVC
    }
    
}

extension SettingsCoordinator: SettingsCoordinatorProtocol { 
    
    func shareApp(url: URL) {
        let shareSheetVC = UIActivityViewController(activityItems: [url],
                                                    applicationActivities: nil)
        
        self.rootVC?.present(shareSheetVC, animated: true)
    }
    
}

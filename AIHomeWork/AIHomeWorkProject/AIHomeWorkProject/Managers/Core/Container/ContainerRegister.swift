//
//  ContainerRegister.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 23.08.24.
//

import Foundation
import Storage

final class ContainerRegister {
    
    static func makeContainer() -> Container {
        let container = Container()
        
        //MARK: - Services
        container.register { AlertService(container: container) }
        container.register { OpenAIChatService() }
        container.register { FileManagerService.instansce }
        container.register { AdaptyService.instansce }
        
        //MARK: - Managers
        container.register { KeyboardHelper()}
        
        //MARK: - Adapters
        container.register { HomeAdapter() }
        container.register { SettingsAdapter() }
        
        //MARK: - Storages
        container.register { ConversationStorage()}
        container.register { TaskStorage() }
        
        return container
    }
    
}

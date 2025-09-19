//
//  TaskAssembler.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 3.09.24.
//

import Foundation
import Storage

final class TaskAssembler {
    
    private init() {}
    
    static func make(container: Container,
                     coordinator: TaskCoordinatorProtocol,
                     subject: Subjects,
                     dto: TaskDTO? = nil) -> TaskVC {
        let keyboardHelper =
        TaskKeyboardHelperUseCase(keyboardHelper: container.resolve())
        
        let adaptyService =
        TaskAdaptyServiceUseCase(service: container.resolve())
        
        let windowManager: WindowManager = container.resolve()
        
        let taskVM = TaskVM(coordinator: coordinator,
                            keyboardHelper: keyboardHelper,
                            subject: subject,
                            dto: dto,
                            adaptyService: adaptyService)
        let taskVC = TaskVC(viewModel: taskVM)
        windowManager.rootVC = taskVC
        return taskVC
    }
}

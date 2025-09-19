//
//  TaskNotRecognizedAssembler.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 10.09.24.
//

import Foundation

final class TaskNotRecognizedAssembler {
    
    private init() {}
    
    static func make(
        coordinator: TaskNotRecognizedCoordinatorProtocol
    ) -> TaskNotRecognizedVC {
        let taskNotRecognizedVM = TaskNotRecognizedVM(
            coordinator: coordinator)
        let taskNotRecognizedVC = TaskNotRecognizedVC(
            viewModel: taskNotRecognizedVM)
        return taskNotRecognizedVC
    }
}

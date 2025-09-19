//
//  TaskNotRecognizedCoordinator.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 10.09.24.
//

import UIKit

final class TaskNotRecognizedCoordinator: Coordinator {
    
    private let coordinator: PhotoCoordinator
    
    init(coordinator: PhotoCoordinator) {
        self.coordinator = coordinator
    }
    
    override func start() -> TaskNotRecognizedVC {
        let taskNotRecognizedVC = TaskNotRecognizedAssembler.make(
            coordinator: self)
        return taskNotRecognizedVC
    }
    
}

extension TaskNotRecognizedCoordinator: TaskNotRecognizedCoordinatorProtocol {
    
    func openCamera() {
        self.finish()
        self.coordinator.finish()
    }
  
    
}

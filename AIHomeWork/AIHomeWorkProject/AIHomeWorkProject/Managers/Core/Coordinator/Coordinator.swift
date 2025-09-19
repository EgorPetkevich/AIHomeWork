//
//  Coordinator.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 23.08.24.
//

import UIKit

class Coordinator {
    
    var onDidFinish: ((Coordinator) -> Void)?
    
    var children: [Coordinator] = []
    
    func start() -> UIViewController? {
        fatalError("method should be overriden")
    }
    
    func finish() {
        onDidFinish?(self)
    }
    
}

extension Coordinator: Equatable {
    
    static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        return lhs === rhs
    }
    
}

// MARK: - Coordinator Helpers
extension Coordinator {
    
    func addChildCoordinator(_ coordinator: Coordinator) {
        children.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        children.removeAll { $0 === coordinator }
    }
    
}

//
//  TaskNotRecognizedVM.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 10.09.24.
//

import UIKit

protocol TaskNotRecognizedCoordinatorProtocol: AnyObject {
    func openCamera()
}

final class TaskNotRecognizedVM {
    
    var delayAnimation: (() -> Void)?
    
    private var timer: Timer?
    
    weak var coordinator: TaskNotRecognizedCoordinatorProtocol?
    
    init(coordinator: TaskNotRecognizedCoordinatorProtocol?) {
        self.coordinator = coordinator
    }
    deinit {
        timer?.invalidate()
    }
    
}

extension TaskNotRecognizedVM: TaskNotRecognizedViewModelProtocol {
    
    func viewDidLoad() {
        startAnimationTimer()
    }
    
    func retakePhotoButtonDidTap() {
        coordinator?.openCamera()
    }
    
}

//MARK: - Configure Animation Delay Timer
extension TaskNotRecognizedVM {
    
    private func startAnimationTimer() {
       timer = Timer.scheduledTimer(withTimeInterval: 1.0 ,
                                    repeats: true,
                                    block: { [weak self] timer in
            self?.delayAnimation?()
        })
    }
    
}

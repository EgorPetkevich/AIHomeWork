//
//  TaskCoordinator.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 3.09.24.
//

import Foundation
import Storage
import UIKit

final class TaskCoordinator: Coordinator {
    
    var finishAndOpenScanner: ((TaskCoordinator) -> Void)?
    var finishWithDTO: ((TaskDTO) -> Void)?
    
    let coordinator: SolvedTaskCoordinator?
    
    private let dto: TaskDTO?
    private let container: Container
    private var rootVC: TaskVC?
    private let subject: Subjects
    
    init(container: Container,
         subject: Subjects,
         dto: TaskDTO? = nil,
         coordiantor: SolvedTaskCoordinator? = nil) {
        self.container = container
        self.subject = subject
        self.dto = dto
        self.coordinator = coordiantor
    }
    
    override func start() -> TaskVC {
        let taskVC = TaskAssembler.make(container: container,
                                        coordinator: self,
                                        subject: subject,
                                        dto: dto)
        rootVC = taskVC
        return taskVC
    }
    
    override func finish() {
        let windowManager: WindowManager = container.resolve()
        windowManager.rootVC = nil
        onDidFinish?(self)
    }
    
}

extension TaskCoordinator: TaskCoordinatorProtocol {
    
    func finish(with dto: TaskDTO) {
        finishWithDTO?(dto)
        finish()
    }
    
    func openScannerScreen() {
        if dto != nil {
            let coordinator = CameraCoordinator(container: container)
            self.addChildCoordinator(coordinator)
            
            let cameraVC = coordinator.start()
            
            coordinator.onDidFinish = { [weak self] coordinator in
                self?.removeChildCoordinator(coordinator)
                cameraVC.dismiss(animated: true)
            }
            
            cameraVC.modalPresentationStyle = .fullScreen
            rootVC?.present(cameraVC, animated: true)
        } else {
            finishAndOpenScanner?(self)
        }
       
    }
    
    func openSolution(dto: TaskDTO) {
        let coordinator = SolutionCoordinator(container: container,
                                              subject: subject,
                                              dto: dto)
        self.addChildCoordinator(coordinator)
        
        let resultsVC = coordinator.start()
        
        coordinator.finishAndOpenNewTask = { [weak self] coordinator in
            self?.removeChildCoordinator(coordinator)
            resultsVC.dismissDetail()
            self?.rootVC?.clearTextView()
        }
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.removeChildCoordinator(coordinator)
            resultsVC.dismissDetail()
        }
        
        resultsVC.modalPresentationStyle = .fullScreen
        
        rootVC?.presentDetail(resultsVC)
    }
    
    func showPaywallReview() {
        let coordinator =
        PaywallReviewCoordinator(container: container)
        let vc = coordinator.start()
        
        children.append(coordinator)
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            vc.dismiss(animated: true)
        }
        
        vc.modalPresentationStyle = .fullScreen
        rootVC?.present(vc, animated: true)
    }
    
    func showPaywallProdTrial() {
        let coordinator =
        PaywallProdTrialCoordinator(container: container,
                                    pageControlIsHiden: true)
        let vc = coordinator.start()
        
        children.append(coordinator)
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            vc.dismiss(animated: true)
        }
        
        vc.modalPresentationStyle = .fullScreen
        rootVC?.present(vc, animated: true)
    }
    
    func showPaywallProd() {
        let coordinator =
        PaywallProdCoordinator(container: container,
                               pageControlIsHiden: true)
        let vc = coordinator.start()
        
        children.append(coordinator)
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            vc.dismiss(animated: true)
        }
        
        vc.modalPresentationStyle = .fullScreen
        rootVC?.present(vc, animated: true)
    }
    
}

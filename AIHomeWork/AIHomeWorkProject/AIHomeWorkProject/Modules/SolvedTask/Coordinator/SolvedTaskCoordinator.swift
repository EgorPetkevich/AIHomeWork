//
//  SolvedTaskCoordinator.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 15.09.24.
//

import UIKit
import Storage

final class SolvedTaskCoordinator: Coordinator {
    
    private let container: Container
    private let dto: TaskDTO
    private var rootVC: SolvedTaskVC?
    
    init(container: Container, dto: TaskDTO) {
        self.container = container
        self.dto = dto
    }
    
    override func start() -> SolvedTaskVC {
        let solvedTask = SolvedTaskAssembler.make(container: container,
                                                  coordinator: self,
                                                  dto: self.dto)
        rootVC = solvedTask
        return solvedTask
    }
    
}

extension SolvedTaskCoordinator: SolvedTaskCoordinatorProtocol {
    
    func openEdit(dto: TaskDTO, subject: Subjects) {
        let coordinator = TaskCoordinator(container: container,
                                          subject: subject,
                                          dto: dto,
                                          coordiantor: self)
        self.addChildCoordinator(coordinator)
        
        let taskVC = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.removeChildCoordinator(coordinator)
            taskVC.dismiss(animated: true)
        }
        
        coordinator.finishWithDTO = { [weak self] dto in
            self?.rootVC?.update(with: dto)
        }
        
        taskVC.modalPresentationStyle = .fullScreen
        
        rootVC?.present(taskVC, animated: true)
    }
    
    func openAIExpertChat(dto: any DTODescription) {
        let coordinator = ChatsHistoryCoordinator(container: container,
                                                  dto: dto)
        self.addChildCoordinator(coordinator)
        
        let aIExpertChatVC = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.removeChildCoordinator(coordinator)
            aIExpertChatVC.dismissDetail()
        }
        
        aIExpertChatVC.modalPresentationStyle = .fullScreen
        
        rootVC?.presentDetail(aIExpertChatVC)
    }
    
    
    func showMenu(sender: UIView, delegate: ResultsMenuDelegate) {
        let menu = ResultsMenuBuilder.buildSolvedTask(delegate: delegate,
                                                      sourceView: sender)
        rootVC?.present(menu, animated: true)
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

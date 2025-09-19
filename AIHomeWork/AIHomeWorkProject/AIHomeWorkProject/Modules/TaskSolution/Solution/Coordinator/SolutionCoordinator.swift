//
//  SolutionCoordinator.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 11.09.24.
//

import UIKit
import Storage

final class SolutionCoordinator: Coordinator {
    
    var finishAndOpenNewTask: ((SolutionCoordinator) -> Void)?
    var finishWithDTO: ((TaskDTO) -> Void)?
    
    private let container: Container
    private var rootVC: SolutionVC?
    private let subject: Subjects
    private let dto: TaskDTO
    
    init(container: Container,
         subject: Subjects,
         dto: TaskDTO) {
        self.container = container
        self.subject = subject
        self.dto = dto
    }
    
    override func start() -> SolutionVC {
        let solutionVC = SolutionAssembler.make(container: container,
                                                coordinator: self,
                                                dto: dto,
                                                subject: subject)
        rootVC = solutionVC
        return solutionVC
    }
    
}

extension SolutionCoordinator: SolutionCoordinatorProtocol {
    
    func openAIExpertChat(dto: any DTODescription) {
        let coordinator = AIExpertChatCoordinator(container: container,
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
    
    func openNewTask() {
        finishAndOpenNewTask?(self)
    }
    
    func showMenu(sender: UIView, delegate: ResultsMenuDelegate) {
        let menu = ResultsMenuBuilder.build(delegate: delegate,
                                            sourceView: sender)
        rootVC?.present(menu, animated: true)
    }
    
}

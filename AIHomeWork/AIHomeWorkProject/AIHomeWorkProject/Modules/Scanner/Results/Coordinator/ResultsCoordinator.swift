//
//  ResultsCoordinator.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 9.09.24.
//

import UIKit
import Storage

final class ResultsCoordinator: Coordinator {
    
    private let container: Container
    private let coordinator: PhotoCoordinator
    private let dto: TaskDTO
    private var rootVC: ResultsVC?
    
    init(container: Container, 
         coordinator: PhotoCoordinator,
         dto: TaskDTO) {
        self.container = container
        self.coordinator = coordinator
        self.dto = dto
    }
    
    override func start() -> ResultsVC {
        let resultsVC = ResultsAssembler.make(container: container,
                                              coordinator: self,
                                              dto: dto)
        rootVC = resultsVC
        return resultsVC
    }
    
}

extension ResultsCoordinator: ResultsCoordinatorProtocol { 
    
    func openCamera() {
        self.finish()
        self.coordinator.finish()
    }
    
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
    
    func showMenu(sender: UIView, delegate: ResultsMenuDelegate) {
        let menu = ResultsMenuBuilder.build(delegate: delegate,
                                            sourceView: sender)
        rootVC?.present(menu, animated: true)
    }
    
}

//
//  ChatsHistoryCoordinator.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 12.09.24.
//

import UIKit
import Storage

final class ChatsHistoryCoordinator: Coordinator {
    
    private let container: Container
    private let dto: (any DTODescription)?
    private var rootVC: UIViewController?
    private var navigationController: UINavigationController?
    
    init(container: Container, dto: (any DTODescription)? = nil) {
        self.container = container
        self.dto = dto
    }
    
    override func start() -> UIViewController {
        let chatsHistoryVC = ChatsHistoryAssembler.make(container: container,
                                                        coordinator: self)
        
        let navigationController = UINavigationController(
            rootViewController: chatsHistoryVC)
        self.navigationController = navigationController
        navigationController.navigationBar.isHidden = true
        if let dto = dto {
            openSelectedChat(dto: dto)
        }
        return navigationController
    }
   
}

extension ChatsHistoryCoordinator: ChatsHistoryCoordinatorProtocol {
    
    func openSelectedChat(dto: any DTODescription) {
        let coordinator = AIExpertChatCoordinator(container: container, dto: dto)
        self.addChildCoordinator(coordinator)
        
        let aIExpertChatVC = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.removeChildCoordinator(coordinator)
            self?.navigationController?.popViewController(animated: true)
        }
        
        aIExpertChatVC.modalPresentationStyle = .fullScreen
        aIExpertChatVC.navigationItem.hidesBackButton = true
        aIExpertChatVC.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(aIExpertChatVC, animated: true)
    }
    
    func newChatButtonDidTap() {
        let coordinator = AIExpertChatCoordinator(container: container)
        self.addChildCoordinator(coordinator)
        
        let aIExpertChatVC = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.removeChildCoordinator(coordinator)
            self?.navigationController?.popViewController(animated: true)
        }
        
        aIExpertChatVC.modalPresentationStyle = .fullScreen
        aIExpertChatVC.navigationItem.hidesBackButton = true
        aIExpertChatVC.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(aIExpertChatVC, animated: true)
    }
    
}


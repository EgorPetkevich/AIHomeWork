//
//  AIExpertChatCoordinator.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 12.09.24.
//

import UIKit
import Storage

final class AIExpertChatCoordinator: Coordinator {
    
    private let container: Container
    private let dto: (any DTODescription)?
    private var rootVC: AIExpertChatVC?
    
    init(container: Container, dto: (any DTODescription)? = nil) {
        self.container = container
        self.dto = dto
    }
    
    override func start() -> AIExpertChatVC {
        let aIExpertChatVC = AIExpertChatAssembler.make(container: container,
                                                        coordinator: self,
                                                        dto: dto)
        rootVC = aIExpertChatVC
        return aIExpertChatVC
    }
    
}

extension AIExpertChatCoordinator: AIExpertChatCoordinatorProtocol {
    
    func openChat() {
        self.finish()
    }
    
    func openCamera(comletion: ((UIImage) -> Void)?) {
        let coordinator = CameraCoordinator(container: container,
                                            comletion: comletion)
        self.addChildCoordinator(coordinator)
        
        let cameraVC = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.removeChildCoordinator(coordinator)
            cameraVC.dismiss(animated: true)
        }
        
        cameraVC.modalPresentationStyle = .fullScreen
        rootVC?.present(cameraVC, animated: true)
    }
    
    
    func showImagePicker(picker: UIImagePickerController) {
        rootVC?.present(picker, animated: true)
    }
    
    func showMenu(sender: UIView, delegate: ResultsMenuDelegate) {
        let menu = ResultsMenuBuilder.buildChat(delegate: delegate,
                                                sourceView: sender)
        rootVC?.present(menu, animated: true)
    }

    
}

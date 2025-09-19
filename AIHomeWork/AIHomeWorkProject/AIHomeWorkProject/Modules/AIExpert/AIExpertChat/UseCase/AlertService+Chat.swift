//
//  AlertService+Chat.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 17.09.24.
//

import Foundation

struct AIExpertChatAlertServiceUseCase: AIExpertChatAlertServiceUseCaseProtocol {
    
    private let service: AlertService
    
    init(service: AlertService) {
        self.service = service
    }
    
    func showRenameChatInput(actionHandler: ActionHandler?) {
        self.service.showRenameChatInput(title: "Rename chat",
                                         actionTitle: "Rename",
                                         cancelTitle: "Cancel",
                                         inputPlaceholder: "Enter name",
                                         actionHandler: actionHandler)
    }
    
    func showActionSheet(takeFotoHandler: AlertActionHandler?,
                          openGalleryHandler: AlertActionHandler?) {
        self.service.showActionSheet(actionTitle: "Take a Photo",
                                     actionHandler: takeFotoHandler,
                                     secondActionTitle: "Open Gallery",
                                     secondActionHandler: openGalleryHandler,
                                     cancelTitle: "Cancel")
    }
    
    func showCameraError(goSettingsHandler: AlertActionHandler?) {
        self.service.showAlert(title: "Gallery Error",
                               message: "This app requires access to your photo library to allow you to select and edit existing photos.",
                               settingTitle: "Go to Settings",
                               settingHandler: goSettingsHandler)
    }
    
}

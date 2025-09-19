//
//  CameraCoordinator.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 5.09.24.
//

import UIKit

final class CameraCoordinator: Coordinator {
    
    private let comletion: ((UIImage) -> Void)?
    private let container: Container
    private var rootVC: CameraVC?
    
    init(container: Container, comletion: ((UIImage) -> Void)? = nil) {
        self.container = container
        self.comletion = comletion
    }
    
    override func start() -> CameraVC {
        let cameraVC = CameraAssembler.make(container: container,
                                              coordinator: self)
        rootVC = cameraVC
        return cameraVC
    }
    
}

extension CameraCoordinator: CameraCoordinatorProtocol {
    
    func openPhoto(image: UIImage) {
        let coordinator = PhotoCoordinator(container: container, 
                                           image: image,
                                           comletion: comletion,
                                           coordinator: self)
        self.addChildCoordinator(coordinator)
        
        let photoVC = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.removeChildCoordinator(coordinator)
            photoVC.dismissDetail()
        }
        
        coordinator.onDidFinisToChat = { [weak self] coordinator in
            self?.removeChildCoordinator(coordinator)
            photoVC.dismissDetailRight()
        }
        
        photoVC.modalPresentationStyle = .fullScreen
        
        rootVC?.presentDetail(photoVC)
    }
    
    func showImagePicker(delegate: any UIImagePickerControllerDelegate & 
                                       UINavigationControllerDelegate) {
        DispatchQueue.main.async { [weak self] in
            let imagePickerVC = UIImagePickerController()
            imagePickerVC.sourceType = .photoLibrary
            imagePickerVC.delegate = delegate
            self?.rootVC?.present(imagePickerVC, animated: true)
        }
        
    }
    
}

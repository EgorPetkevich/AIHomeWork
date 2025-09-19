//
//  PhotoCoordinator.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 8.09.24.
//

import UIKit
import Storage

final class PhotoCoordinator: Coordinator {
    
    var onDidFinisToChat: ((PhotoCoordinator) -> Void)?
    var taskNotRecognizedDismiss: (() -> Void)?
    
    private let comletion: ((UIImage) -> Void)?
    private let coordinator: CameraCoordinator
    private let container: Container
    private let image: UIImage
    private var rootVC: PhotoVC?

    init(container: Container,
         image: UIImage,
         comletion: ((UIImage) -> Void)?,
         coordinator: CameraCoordinator) {
        self.container = container
        self.image = image
        self.comletion = comletion
        self.coordinator = coordinator
    }
    
    override func start() -> PhotoVC {
        let photoVC = PhotoAssembler.make(container: container,
                                          coordinator: self,
                                          image: image,
                                          completion: comletion)
        rootVC = photoVC
        return photoVC
    }
    
}

extension PhotoCoordinator: PhotoCoordinatorProtocol { 
    
    func finishWithComletion() {
        onDidFinisToChat?(self)
        coordinator.finish()
    }
    
    func openResults(dto: TaskDTO) {
        let coordinator = ResultsCoordinator(container: container,
                                             coordinator: self,
                                             dto: dto)
        self.addChildCoordinator(coordinator)
        
        let resultsVC = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.removeChildCoordinator(coordinator)
            resultsVC.dismissDetail()
        }
        
        
        resultsVC.modalPresentationStyle = .fullScreen
        
        rootVC?.presentDetail(resultsVC)
    }
    
    func presentTaskNotRecognized() {
        let coordinator = TaskNotRecognizedCoordinator(coordinator: self)
        self.addChildCoordinator(coordinator)
        
        let taskNotRecognizedVC = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.removeChildCoordinator(coordinator)
            self?.taskNotRecognizedDismiss?()
            taskNotRecognizedVC.dismiss(animated: true)
        }
        
        rootVC?.present(taskNotRecognizedVC, animated: true)
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

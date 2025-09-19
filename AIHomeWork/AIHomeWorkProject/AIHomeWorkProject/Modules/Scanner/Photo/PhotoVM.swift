//
//  PhotoVM.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 8.09.24.
//

import UIKit
import Storage

protocol PhotoCoordinatorProtocol: AnyObject {
    var taskNotRecognizedDismiss: (() -> Void)? { get set }
    
    func presentTaskNotRecognized()
    func openResults(dto: TaskDTO)
    func finishWithComletion()
    func showPaywallReview()
    func showPaywallProdTrial()
    func showPaywallProd()
    func finish()
}

protocol PhotoAdaptyServiceUseCaseProtocol {
    var isPremium: Bool { get }
    var remoteConfig: RemoteConfig? { get }
}

final class PhotoVM {
    
    var delayAnimation: (() -> Void)?
    var setupOnScanning: (() -> Void)?
    var setupOnStopScanning: (() -> Void)?
    
    var taskNotRecognizedDismiss: (() -> Void)?
    var taskNotRecognizedPresent: (() -> Void)?
    
    private var dto: TaskDTO?
    
    private var completion: ((UIImage) -> Void)?
    
    private var timer: Timer?
    
    private let textRecognitionService = TextRecognitionService()
    private let storage: TaskStorage = TaskStorage()
    private let chatService = OpenAIChatService()
    private let adaptyService: PhotoAdaptyServiceUseCaseProtocol
    
    weak var coordinator: PhotoCoordinatorProtocol?
    
    init(coordinator: PhotoCoordinatorProtocol?,
         completion: ((UIImage) -> Void)?,
         adaptyService: PhotoAdaptyServiceUseCaseProtocol) {
        self.coordinator = coordinator
        self.completion = completion
        self.adaptyService = adaptyService
        
        bind()
    }
    
    private func bind() {
        coordinator?.taskNotRecognizedDismiss = { [weak self] in
            self?.taskNotRecognizedDismiss?()
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func createTaskDTO(message: String, completion: ((Bool) -> Void)?) {
        let id = UUID().uuidString
        let chat = ChatDTO(id: id, 
                           date: .now,
                           message: message,
                           role: ChatRole.user.rawValue)
        let dto = TaskDTO(id: id, date: .now, name: "Results", chat: [chat])
        self.dto = dto
        storage.create(dto: dto, completion: completion)
    }
    
    private func fetchChat(dto: TaskDTO, completion: ((TaskDTO?) -> Void)?) {
        chatService.fetchChat(dto: dto) { [weak self] chatDTO in
            guard let chatDTO else { return }
            self?.addChat(to: dto, chat: chatDTO, completion: completion)
        }
    }
    
    private func addChat(to dto: TaskDTO,
                         chat: ChatDTO,
                         completion: ((TaskDTO?) -> Void)?) {
        storage.addChatAndUpdate(taskDTO: dto,
                                 chatDTO: chat,
                                 completion: completion)
    }
    
    private func startScanningAnimation(_ value: Bool) {
        if value {
            startAnimationTimer()
            setupOnScanning?()
        } else {
            stopAnimationTimer()
            setupOnStopScanning?()
            coordinator?.presentTaskNotRecognized()
            taskNotRecognizedPresent?()
        }
    }
    
}

extension PhotoVM: PhotoViewModelProtocol {
    
    func viewDidDisappear() {
        timer?.invalidate()
    }
    
    func solutionButtonDidTap(taskImage: UIImage?) {
        //FIXME: uncoment
        if !showPaywall() {
            //do
            guard let taskImage else { return }
            
            if let completion {
                completion(taskImage)
                coordinator?.finishWithComletion()
            }
            startScanningAnimation(true)
            textRecognitionService.recognizeText(image: taskImage)
            { [weak self] text in
                guard let text  else {
                    self?.startScanningAnimation(false)
                    return
                }
                self?.createTaskDTO(message: text) { comletion in
                    if let dto = self?.dto, comletion {
                        self?.fetchChat(dto: dto) { taskDTO in
                            guard let taskDTO else {
                                self?.startScanningAnimation(false)
                                return
                            }
                            self?.coordinator?.openResults(dto: taskDTO)
                        }
                    } else {
                        self?.startScanningAnimation(false)
                    }
                }
            }
        }
    }
    
    func retakePhotoButtonDidTap() {
        coordinator?.finish()
    }
    
    func backButtonDidTap() {
        coordinator?.finish()
    }
    
    
}

//MARK: - Configure Animation Delay Timer
extension PhotoVM {
    
    private func startAnimationTimer() {
       timer = Timer.scheduledTimer(withTimeInterval: 1.0 ,
                                    repeats: true,
                                    block: { [weak self] timer in
            self?.delayAnimation?()
        })
    }
    
    private func stopAnimationTimer() {
        timer?.invalidate()
    }
    
}

//MARK: - ShowPaywall
extension PhotoVM {
    
    private func showPaywall() -> Bool {
        
        guard self.adaptyService.isPremium == false else { return false }
        
        guard
            let review = adaptyService.remoteConfig?.review,
            let supportTrial = adaptyService.remoteConfig?.supportTrial
        else {
            coordinator?.showPaywallReview()
            return true
        }
        
        if review {
            coordinator?.showPaywallReview()
        } else if review == false {
            if supportTrial {
                coordinator?.showPaywallProdTrial()
                return true
            } else {
                coordinator?.showPaywallProd()
                return true
            }
        }
        return true
    }
    
}

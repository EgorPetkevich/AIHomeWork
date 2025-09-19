//
//  TaskVM.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 3.09.24.
//

import UIKit
import Storage

protocol TaskCoordinatorProtocol: AnyObject {
    func openScannerScreen()
    func openSolution(dto: TaskDTO)
    func finish()
    func finish(with: TaskDTO)
    func showPaywallReview()
    func showPaywallProdTrial()
    func showPaywallProd()
}

protocol TaskKeyboardHelperUseCaseProtocol {
    @discardableResult
    func onWillShow(_ handler: @escaping (CGRect) -> Void) -> KeyboardHelper
    @discardableResult
    func onWillHide(_ handler: @escaping (CGRect) -> Void) -> KeyboardHelper
}

protocol TaskAdaptyServiceUseCaseProtocol {
    var isPremium: Bool { get }
    var remoteConfig: RemoteConfig? { get }
}

final class TaskVM {
    
    var keyboardOnWillShow: (() -> Void)?
    var keyboardOnWillHide: (() -> Void)?
    var taskMessage: ((String) -> Void)?
    var showLoadSpiner: (() -> Void)?
    var hideLoadSpinerView: (() -> Void)?
    
    weak var coordinator: TaskCoordinatorProtocol?

    private var dto: TaskDTO?
    
    private let subject: Subjects
    private var keyboardHelper: TaskKeyboardHelperUseCaseProtocol
    private let storage = TaskStorage()
    private let chatService = OpenAIChatService()
    private let adaptyService: TaskAdaptyServiceUseCaseProtocol
    
    init(coordinator: TaskCoordinatorProtocol,
         keyboardHelper: TaskKeyboardHelperUseCaseProtocol,
         subject: Subjects,
         dto: TaskDTO? = nil,
         adaptyService: TaskAdaptyServiceUseCaseProtocol) {
        self.coordinator = coordinator
        self.keyboardHelper = keyboardHelper
        self.subject = subject
        self.dto = dto
        self.adaptyService = adaptyService
        bindKeyboardHelper()
        
    }
    
}

extension TaskVM: TaskViewModelProtocol {
    
    func viewDidLoad() {
        guard let taskText = dto?.chat.first?.message else { return }
        taskMessage?(taskText)
    }
    
    func scanButtonDidTap() {
        coordinator?.openScannerScreen()
    }
    
    func backButtonDidTap() {
        coordinator?.finish()
    }
    
    func actionButtonDidTap(task: String) {
        //FIXME: uncoment
        if !showPaywall() {
            //do action
            if var dto  {
                let chat: ChatDTO = ChatDTO(id: UUID().uuidString,
                                            date: .now,
                                            message: task,
                                            role: ChatRole.user.rawValue)
                dto.chat = [chat]
                updateCurrentDTO(dto)
                
            } else {
                let chat: ChatDTO = ChatDTO(id: UUID().uuidString,
                                            date: .now,
                                            message: task,
                                            role: ChatRole.user.rawValue)
                let dto: TaskDTO = TaskDTO(id: UUID().uuidString,
                                           date: .now,
                                           name: subject.title,
                                           chat: [chat])
                coordinator?.openSolution(dto: dto)
            }
            
        }
    }
    
    func subjectType() -> Subjects {
        subject
    }
    
    private func updateCurrentDTO(_ dto: TaskDTO) {
        showLoadSpiner?()
        createTaskIfNeeded(dto: dto) { [weak self] isTaskCreated in
            guard isTaskCreated else { return }
            self?.fetchChat(dto: dto)
            
        }
    }
    
    private func createTaskIfNeeded(dto: TaskDTO, completion: ((Bool) -> Void)?) {
        storage.delete(dto: dto) { _ in
            self.storage.create(dto: dto, completion: completion)
        }
    }
    
    private func fetchChat(dto: TaskDTO) {
        chatService.fetchChat(dto: dto) { [weak self] chatDTO in
            guard let chatDTO else { return }
            self?.addChat(to: dto, chat: chatDTO) { dto in
                guard let updatedDTO = dto else { return }
                self?.coordinator?.finish(with: updatedDTO)
                self?.hideLoadSpinerView?()
            }
        }
    }
    
    private func addChat(to dto: TaskDTO,
                         chat: ChatDTO,
                         completion: ((TaskDTO?) -> Void)?) {
        storage.addChatAndUpdate(taskDTO: dto,
                                 chatDTO: chat,
                                 completion: completion)
    }
    
}

//MARK: - KeyboardHelper Bind
extension TaskVM {
    
    private func bindKeyboardHelper() {
        keyboardHelper.onWillShow { [weak self] _ in
            self?.keyboardOnWillShow?()
        }
        keyboardHelper.onWillHide { [weak self] _ in
            self?.keyboardOnWillHide?()
        }
        
    }
}

//MARK: - ShowPaywall
extension TaskVM {
    
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

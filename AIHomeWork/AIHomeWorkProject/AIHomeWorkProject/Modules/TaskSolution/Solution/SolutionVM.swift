//
//  SolutionVM.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 11.09.24.
//

import UIKit
import Storage

protocol SolutionCoordinatorProtocol: AnyObject {
    func showMenu(sender: UIView, delegate: ResultsMenuDelegate)
    func openNewTask()
    func openAIExpertChat(dto: any DTODescription)
    func finish()
}

protocol SolutionTaskStorageUseCaseProtocol {
    typealias CompletionHandler = (Bool) -> Void
    
    func create(taskDTO: TaskDTO,
                completion: CompletionHandler?)
    func addChatAndUpdate(taskDTO: TaskDTO,
                          chatDTO: ChatDTO,
                          completion: ((TaskDTO?) -> Void)?)
    func delete(dto: TaskDTO,
                completion: CompletionHandler?)
}

protocol SolutionOpenChatServiceUseCaseProtocol {
    typealias TaskCompletionHandler = ((ChatDTO?) -> Void)?
    func fetchChat(dto: any DTODescription,
                   completion: TaskCompletionHandler)
}

final class SolutionVM {
    
    var hideLoadSpinerView: (() -> Void)?
    var showLoadSpiner: (() -> Void)?
    
    private var dto: TaskDTO
    private let subject: Subjects
   
    weak var coordinator: SolutionCoordinatorProtocol?
    
    private let adapter: ResultsAdapterProtocol
    private let storage: SolutionTaskStorageUseCaseProtocol
    private let chatService: SolutionOpenChatServiceUseCaseProtocol
    
    init(coordinator: SolutionCoordinatorProtocol,
         adapter: ResultsAdapterProtocol,
         storage: SolutionTaskStorageUseCaseProtocol,
         chatService: SolutionOpenChatServiceUseCaseProtocol,
         subject: Subjects,
         dto: TaskDTO) {
        self.coordinator = coordinator
        self.adapter = adapter
        self.storage = storage
        self.chatService = chatService
        self.subject = subject
        self.dto = dto
        getChat(dto: dto)
    }
    
    private func getChat(dto: TaskDTO) {
        showLoadSpiner?()
        createTaskIfNeeded { [weak self] isTaskCreated in
            guard isTaskCreated else { return }
            self?.fetchAndReloadChat(dto: dto)
            
        }
    }

    private func createTaskIfNeeded(completion: ((Bool) -> Void)?) {
        storage.delete(dto: dto) { _ in
            self.storage.create(taskDTO: self.dto, completion: completion)
        }
    }

    private func fetchAndReloadChat(dto: TaskDTO) {
        chatService.fetchChat(dto: dto) { [weak self] chatDTO in
            guard let chatDTO else { return }
            self?.addChat(to: dto, chat: chatDTO) { dto in
                guard let updatedDTO = dto else { return }
                    self?.reloadData(with: updatedDTO)
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

    private func reloadData(with dto: TaskDTO) {
        let chat = dto.chat
        let taskText = chat.first(
            where: { $0.role == ChatRole.user.rawValue })?.message ?? ""
        let solutionText = chat.first(
            where: { $0.role == ChatRole.assistant.rawValue })?.message ?? ""
        
        self.adapter.reloadData(with: getResultsSection(),
                                taskText: taskText,
                                solutionText: solutionText)
        self.hideLoadSpinerView?()
    }

    private func getResultsSection() -> [ResultsSection] {
        switch subject {
        case .grammar:
            return [.task(.taskRow), .result(.resultRow)]
        default:
            return [.task(.taskRow), .solution(.solutionRow)]
        }
    }
    
    private func removeTask() {
        storage.delete(dto: dto, completion: { [weak self] complition in
            if complition {  self?.coordinator?.finish() }
        })
    }
    
}

extension SolutionVM: SolutionViewModelProtocol {
    
    func subjectType() -> Subjects {
        return subject
    }
    
    func makeTableView() -> UITableView {
        return adapter.makeTableView()
    }
    
    func menuButtonDidTap(sender: UIView) {
        coordinator?.showMenu(sender: sender, delegate: self)
    }
    
    func backButtonDidTap() {
        coordinator?.finish()
    }
    
    func tryAgainButtonDidTap() {
        storage.delete(dto: dto, completion: nil)
        getChat(dto: dto)
    }
    
    func newTaskButtonDidTap() {
        coordinator?.openNewTask()
    }
    
}

extension SolutionVM: ResultsMenuDelegate {
    
    func didSelect(action: ResultsMenuVC.Action) {
        switch action {
        case .edit:
            coordinator?.finish()
            return
        case .askExpert:
            coordinator?.openAIExpertChat(dto: dto)
            return
        case .delete:
            removeTask()
            return
        default: return
        }
    }

}

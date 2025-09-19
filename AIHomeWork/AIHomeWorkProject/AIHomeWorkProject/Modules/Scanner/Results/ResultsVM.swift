//
//  ResultsVM.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 9.09.24.
//

import UIKit
import Storage

protocol ResultsCoordinatorProtocol: AnyObject {
    func showMenu(sender: UIView, delegate: ResultsMenuDelegate)
    func openAIExpertChat(dto: any DTODescription)
    func openCamera()
    func finish()
}

final class ResultsVM {
    
    var hideLoadSpinerView: (() -> Void)?
    var showLoadSpiner: (() -> Void)?
    
    weak var coordinator: ResultsCoordinatorProtocol?
    
    private let storage = TaskStorage()
    private let chatService = OpenAIChatService()
    
    private var dto: TaskDTO
    private let adapter: ResultsAdapterProtocol
    
    init(coordinator: ResultsCoordinatorProtocol, 
         adapter: ResultsAdapter,
         dto: TaskDTO) {
        self.coordinator = coordinator
        self.adapter = adapter
        self.dto = dto
        reloadData(with: dto)
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
            self.storage.create(dto: self.dto, completion: completion)
        }
    }
    
    private func fetchAndReloadChat(dto: TaskDTO) {
        chatService.fetchChat(dto: dto) { [weak self] chatDTO in
            guard let chatDTO else { return }
            self?.addChat(to: dto, chat: chatDTO) { dto in
                guard let updatedDTO = dto else { return }
                self?.reloadData(with: updatedDTO)
                self?.dto = updatedDTO
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
        
        self.adapter.reloadData(with: [.task(.taskRow), .solution(.solutionRow)],
                                taskText: taskText,
                                solutionText: solutionText)
        self.hideLoadSpinerView?()
    }
    
    private func deleteTaskDTO(completion: ((Bool) -> Void)?) {
        storage.delete(dto: dto, completion: completion)
    }
    
}

extension ResultsVM: ResultsViewModelProtocol {
    
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
        self.dto.chat.removeLast()
        getChat(dto: self.dto)
    }
    
    func newTaskButtonDidTap() {
        coordinator?.openCamera()
    }
    
}

extension ResultsVM: ResultsMenuDelegate {
    
    func didSelect(action: ResultsMenuVC.Action) {
        switch action {
        case .edit:
            deleteTaskDTO { [weak self] comletion in
                if comletion { self?.coordinator?.finish()}
            }
            return
        case .askExpert:
            coordinator?.openAIExpertChat(dto: dto)
            return
        case .delete:
            deleteTaskDTO { [weak self] comletion in
                if comletion { self?.coordinator?.openCamera()}
            }
            return
        default: return
        }
    }

}

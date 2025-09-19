//
//  SolvedTaskVM.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 15.09.24.
//

import UIKit
import Storage

protocol SolvedTaskCoordinatorProtocol: AnyObject {
    func showMenu(sender: UIView, delegate: ResultsMenuDelegate)
    func openAIExpertChat(dto: any DTODescription)
    func openEdit(dto: TaskDTO, subject: Subjects)
    func showPaywallReview()
    func showPaywallProdTrial()
    func showPaywallProd()
    func finish()
}

protocol SolvedTaskAdapterProtocol {
    func makeTableView() -> UITableView
    func reloadData(chats: [ChatDTO])
}

protocol SolvedTaskAdaptyServiceUseCaseProtocol {
    var isPremium: Bool { get }
    var remoteConfig: RemoteConfig? { get }
}

final class SolvedTaskVM {
    
    weak var coordinator: SolvedTaskCoordinatorProtocol?
    
    private let adaptyService: SolvedTaskAdaptyServiceUseCaseProtocol
    
    private let storageTask = TaskStorage()
    private var dto: TaskDTO
    
    private var adapter: SolvedTaskAdapterProtocol
    
    init(coordinator: SolvedTaskCoordinatorProtocol,
         adapter: SolvedTaskAdapterProtocol,
         adaptyService: SolvedTaskAdaptyServiceUseCaseProtocol,
         dto: TaskDTO) {
        self.coordinator = coordinator
        self.adapter = adapter
        self.dto = dto
        self.adaptyService = adaptyService
    }
    
}

extension SolvedTaskVM: SolvedTaskViewModelProtocol {
    
    func reload(with updatedDTO: TaskDTO) {
        self.dto = updatedDTO
        adapter.reloadData(chats: updatedDTO.chat)
    }
    
    func viewDidLoad() {
        adapter.reloadData(chats: dto.chat)
    }
    
    func askExpertButtonDidTap() {
        if !showPaywall() {
            coordinator?.openAIExpertChat(dto: dto)
        }
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
    
}

extension SolvedTaskVM: ResultsMenuDelegate {
    
    func didSelect(action: ResultsMenuVC.Action) {
        switch action {
        case .edit:
            guard
                let subject = Subjects.getSubject(title: dto.name)
            else { return }
            coordinator?.openEdit(dto: dto, subject: subject)
            return
        case .delete:
            storageTask.delete(dto: dto, completion: { [weak self] complition in
                if complition {  self?.coordinator?.finish() }
                return
            })
        default:
            return
        }
    }

}

//MARK: - ShowPaywall
extension SolvedTaskVM {
    
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

//
//  ChatsHistoryVM.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 12.09.24.
//

import UIKit
import Storage

protocol ChatsHistoryCoordinatorProtocol: AnyObject {
    func newChatButtonDidTap()
    func openSelectedChat(dto: any DTODescription)
    func finish()
}

protocol ChatsHistoryAdapterProtocol {
    var cellDidSelect: ((any DTODescription) -> Void)? { get set }
    
    func reloadDate(_ dtoList: [any DTODescription])
    func makeTableView() -> UITableView
}

protocol ChatsHistoryFRCServiceUseCaseProtocol {
    var fetchedDTOs: [any DTODescription] { get }
    var didChangeContent: (([any DTODescription]) -> Void)? { get set }
    func startHandle()
}

final class ChatsHistoryVM {
   
    weak var coordinator: ChatsHistoryCoordinatorProtocol?
    
    private let frcService: ChatsHistoryFRCServiceUseCaseProtocol
    private var adapter: ChatsHistoryAdapterProtocol
    
    init(coordinator: ChatsHistoryCoordinatorProtocol,
         adapter: ChatsHistoryAdapterProtocol,
         frcService: ChatsHistoryFRCServiceUseCaseProtocol) {
        self.coordinator = coordinator
        self.adapter = adapter
        self.frcService = frcService
        bindAdapter()
    }
    
}

//MARK: - Bind Adapter
extension ChatsHistoryVM {
    
    private func bindAdapter() {
        adapter.cellDidSelect = { [weak coordinator] dto in
            coordinator?.openSelectedChat(dto: dto as! ConversationDTO)
        }
    }
    
}

extension ChatsHistoryVM: ChatsHistoryViewModelProtocol {
    
    func viewDidLoad() {
        frcService.startHandle()
    }
    
    func viewWillAppear() {
        adapter.reloadDate(frcService.fetchedDTOs)
    }
    
    func makeTableView() -> UITableView {
        adapter.makeTableView()
    }
    
    func newChatButtonDidTap() {
        coordinator?.newChatButtonDidTap()
    }
    
    func backButtonDidTap() {
        coordinator?.finish()
    }
    
}

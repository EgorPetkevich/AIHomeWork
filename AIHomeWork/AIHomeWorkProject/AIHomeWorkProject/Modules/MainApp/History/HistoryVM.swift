//
//  HistoryVM.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 30.08.24.
//

import UIKit
import Storage

protocol HistoryCoordinatorProtocol: AnyObject {
    func openHomeScreen()
    func openSolvedTask(dto: TaskDTO)
}

protocol HistoryAdapterProtocol {
    var cellDidSelect: ((any DTODescription) -> Void)? { get set }
    
    func reloadDate(_ dtoList: [any DTODescription])
    func makeTableView() -> UITableView
}

protocol HistoryFRCServiceUseCaseProtocol {
    var fetchedDTOs: [any DTODescription] { get }
    var didChangeContent: (([any DTODescription]) -> Void)? { get set }
    func startHandle()
}

final class HistoryVM {
    
    var showActionView: ((Bool) -> Void)?
    
    private weak var coordinator: HistoryCoordinatorProtocol?
    
    private let frcService: HistoryFRCServiceUseCaseProtocol
    private var adapter: HistoryAdapterProtocol
    
    
    init(coordinator: HistoryCoordinatorProtocol,
         adapter: HistoryAdapterProtocol,
         frcService: HistoryFRCServiceUseCaseProtocol) {
        self.coordinator = coordinator
        self.adapter = adapter
        self.frcService = frcService
        bindAdapter()
    }
    
}

//MARK: - Bind Adapter
extension HistoryVM {
    
    private func bindAdapter() {
        adapter.cellDidSelect = { [weak coordinator] dto in
            coordinator?.openSolvedTask(dto: dto as! TaskDTO)
        }
    }
    
}

extension HistoryVM: HistoryViewModelProtocol {
    
    func viewDidLoad() {
        frcService.startHandle()
    }
    
    func viewWillAppear() {
        let dtos = frcService.fetchedDTOs
        adapter.reloadDate(dtos)
        self.showActionView?(dtos.count == .zero)
    }
    
    func makeTableView() -> UITableView {
        adapter.makeTableView()
    }
    
    
    func solveTaskButtonDidTap() {
        coordinator?.openHomeScreen()
    }
    
}

//
//  ChatsHistoryAdapter.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 17.09.24.
//

import UIKit
import Storage
import SnapKit

final class ChatsHistoryAdapter: NSObject {
    
    var cellDidSelect: ((any DTODescription) -> Void)?
    
    private var dtoList: [any DTODescription] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private(set) var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.selectionFollowsFocus = true
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = nil
        tableView.tableHeaderView?.isHidden = true
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.cornerRadius = 24.0
        return tableView
    }()
    
    override init() {
        super.init()
        setupTableView()
    }
    
}

//MARK: - Collection View Setup/
extension ChatsHistoryAdapter {
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatsHistoryCell.self)
    }
    
}

extension ChatsHistoryAdapter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return dtoList.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChatsHistoryCell = tableView.dequeue(at: indexPath)
        cell.setup(dto: dtoList[indexPath.row] as! ConversationDTO)
        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dto = dtoList[indexPath.row]
        cellDidSelect?(dto)
    }
    
}

extension ChatsHistoryAdapter: UITableViewDelegate {}



extension ChatsHistoryAdapter: ChatsHistoryAdapterProtocol {
    
    func reloadDate(_ dtoList: [any DTODescription]) {
        self.dtoList = dtoList
    }
    
    
    func makeTableView() -> UITableView {
        self.tableView
    }
    
}


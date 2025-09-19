//
//  HistoryAdapter.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 14.09.24.
//

import UIKit
import Storage
import SnapKit

final class HistoryAdapter: NSObject {
    
    private enum Constants {
        static let rowHeight: CGFloat = 110.0
    }
    
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
extension HistoryAdapter {
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HistoryTaskCell.self)
    }
    
}

extension HistoryAdapter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return dtoList.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HistoryTaskCell = tableView.dequeue(at: indexPath)
        cell.setup(dto: dtoList[indexPath.row] as! TaskDTO)
        return cell
    }

    func tableView(_ tableView: UITableView, 
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dto = dtoList[indexPath.row]
        cellDidSelect?(dto)
    }
    
}

extension HistoryAdapter: UITableViewDelegate {}



extension HistoryAdapter: HistoryAdapterProtocol {
    
    func reloadDate(_ dtoList: [any DTODescription]) {
        self.dtoList = dtoList
    }
    
    
    func makeTableView() -> UITableView {
        self.tableView
    }
    
}

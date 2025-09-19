//
//  AIExpertChatAdapter.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 12.09.24.
//

import UIKit
import Storage

final class AIExpertChatAdapter: NSObject {
    
    var rows: [ChatDTO] = [] {
        didSet {
            tableView.reloadData()
            scrollToBottom()
        }
    }
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = true
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    override init() {
        super.init()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AIBotCell.self)
        tableView.register(UserCell.self)
        tableView.register(LoadingCell.self)
        tableView.register(ImageCell.self)
        tableView.register(AIBotHiCell.self)
    }
    
}

extension AIExpertChatAdapter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[indexPath.row]

        switch row.role {
        case ChatRole.user.rawValue:
            if let imagePath = row.imageUrl {
                let cell: ImageCell = tableView.dequeue(at: indexPath)
                cell.setup(imagePath: imagePath)
                return cell
            } else {
                let cell: UserCell = tableView.dequeue(at: indexPath)
                cell.setup(text: row.message)
                return cell
            }
        case ChatRole.assistant.rawValue:
            if row.message == AIExpertChatVM.hiMessage {
                let cell: AIBotHiCell = tableView.dequeue(at: indexPath)
                cell.setup(text: row.message)
                return cell
            } else {
                let cell: AIBotCell = tableView.dequeue(at: indexPath)
                cell.setup(text: row.message)
                return cell
            }
        default:
            let cell: LoadingCell = tableView.dequeue(at: indexPath)
            cell.setup()
            return cell
        }
    }
    
}
extension AIExpertChatAdapter: UITableViewDelegate { }


extension AIExpertChatAdapter: AIExpertChatAdapterProtocol {
    
    func reloadData(whith chat: [ChatDTO]) {
        self.rows = chat
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func makeTableView() -> UITableView {
        return tableView
    }
    
    func scrollToBottom() {
        guard rows.count >= 2 else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let rowsCount = self?.rows.count else { return }
            let indexPath = IndexPath(row: rowsCount - 1, section: 0)
            self?.tableView.scrollToRow(at: indexPath,
                                       at: .bottom,
                                       animated: true)
        }
    }
    
}

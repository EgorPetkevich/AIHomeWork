//
//  SolvedTaskAdapter.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 16.09.24.
//

import UIKit
import Storage

final class SolvedTaskAdapter: NSObject {
    
    var chats: [ChatDTO] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .appDarkGray
        tableView.isScrollEnabled = true
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.cornerRadius = 20.0
        return tableView
    }()
    
    override init() {
        super.init()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(QuestionCell.self)
        tableView.register(AnswerCell.self)
    }
    
}

extension SolvedTaskAdapter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = chats[indexPath.row]
        
        switch chat.role {
        case ChatRole.user.rawValue:
            let cell: QuestionCell = tableView.dequeue(at: indexPath)
            cell.setup(chat.message)
            return cell
        case ChatRole.assistant.rawValue:
            let cell: AnswerCell = tableView.dequeue(at: indexPath)
            cell.setup(chat.message)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}

extension SolvedTaskAdapter: UITableViewDelegate {
    
}


extension SolvedTaskAdapter: SolvedTaskAdapterProtocol {
    
    func reloadData(chats: [ChatDTO]) {
        self.chats = chats
    }
    
    func makeTableView() -> UITableView {
        return tableView
    }
    
    
}


//
//  ResultsMenuAdapter.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 10.09.24.
//

import UIKit

final class ResultsMenuAdapter: NSObject, ResultsMenuAdapterProtocol {
    
    private enum Const {
        static let rowHeight: CGFloat = 45.0
    }
    
    private(set) var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .appWhite
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = Const.rowHeight
        tableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    var contentHeight: CGFloat {
        return CGFloat(actions.count) * Const.rowHeight
    }
    
    var actions: [ResultsMenuVC.Action]
    
    var didSelectAction: ((ResultsMenuVC.Action) -> Void)?
    
    init(actions: [ResultsMenuVC.Action]) {
        self.actions = actions
        super.init()
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(ResultsMenuCell.self)
    }
    
}

extension ResultsMenuAdapter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ResultsMenuCell = tableView.dequeue(at: indexPath)
        cell.setup(actions[indexPath.row])
        return cell
    }
    
}

extension ResultsMenuAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let action = actions[indexPath.row]
        didSelectAction?(action)
    }
    
}

//
//  SettingsAdapter.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 2.09.24.
//

import UIKit
import SnapKit

final class SettingsAdapter: NSObject {
    
    private enum Constants {
        static let rowHeight: CGFloat = 72.0
        static let tableViewCornerRadius: CGFloat = 24.0
    }
    
    var cellDidSelect: ((SettingsSection.Settings) -> Void)?
    
    private let cells: [SettingsSection.Settings] =
    [.privacy, .rate, .restore, .share, .terms]
    
    private(set) var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.allowsSelection = true
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = Constants.rowHeight
        tableView.separatorColor = .clear
        tableView.cornerRadius = Constants.tableViewCornerRadius
        return tableView
    }()
    
    override init() {
        super.init()
        setupTableView()
    }
    
}

//MARK: - Collection View Setup/
extension SettingsAdapter {
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingsCell.self)
    }
    
}

extension SettingsAdapter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsCell = tableView.dequeue(at: indexPath)
        cell.setup(cells[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = cells[indexPath.row]
        cellDidSelect?(cell)
    }
    
}

extension SettingsAdapter: UITableViewDelegate {}



extension SettingsAdapter: SettingsAdapterProtocol {
    
    func makeTableView() -> UITableView {
        self.tableView
    }
    
}

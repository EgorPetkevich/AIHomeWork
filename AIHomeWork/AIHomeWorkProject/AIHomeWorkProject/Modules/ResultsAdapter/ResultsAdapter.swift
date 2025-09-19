//
//  ResultsAdapter.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 11.09.24.
//

import UIKit
import Storage

protocol ResultsAdapterProtocol {
    func makeTableView() -> UITableView
    func reloadData(with sections: [ResultsSection],
                    taskText: String,
                    solutionText: String)
}

final class ResultsAdapter: NSObject {
    
    private enum Constants {
        static var headerHeight: CGFloat = 56.0
    }
    
    var taskText: String = "task not found"
    var solutionText: String = "solution not found"
    
    var sections: [ResultsSection] = [] {
        didSet {
            tableView.reloadData()
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
        tableView.register(ResultsCell.self)
        tableView.register(QuestionResultCell.self)
    }
    
}

extension ResultsAdapter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
        
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return sections[section].numberOfRows
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        
        switch section {
        case .task(let row):
            let cell: QuestionResultCell = tableView.dequeue(at: indexPath)
            cell.setup(row, text: taskText)
            return cell
        case .solution(let row):
            let cell: ResultsCell = tableView.dequeue(at: indexPath)
            cell.setup(row, text: solutionText)
            return cell
        case .result(let row):
            let cell: ResultsCell = tableView.dequeue(at: indexPath)
            cell.setup(row, text: solutionText)
            return cell
        }
        
    }
}

extension ResultsAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let section = sections[section]
        let header = ResultsHeader()
        header.frame = CGRect(x: .zero, y: .zero, 
                              width: tableView.frame.width,
                              height: Constants.headerHeight)
        header.text = section.titleHeader
        header.icon = section.iconImage
        header.headerViewColor = section.backgroundColor
        return header
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.headerHeight
    }
    
}


extension ResultsAdapter: ResultsAdapterProtocol {
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func reloadData(with sections: [ResultsSection],
                    taskText: String,
                    solutionText: String) {
        self.taskText = taskText
        self.solutionText = solutionText
        self.sections = sections
    }
    
    func makeTableView() -> UITableView {
        return tableView
    }
    
    
}

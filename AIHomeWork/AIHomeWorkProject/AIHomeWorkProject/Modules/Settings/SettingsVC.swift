//
//  SettingsVC.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 2.09.24.
//

import UIKit
import SnapKit

protocol SettingsViewModelProtocol {
    func backButtonDidTap()
    func makeTableView() -> UITableView
}

final class SettingsVC: UIViewController {
    
    private enum Constants {
        //MARK: - Text
        static var titleText: String = "Settings"
        
        //MARK: - Constains
        static var tableViewHeight: CGFloat = 360.0
        static var backArrowButtonSize: CGSize = CGSize(width: 30.0,
                                                        height: 24.0)
    }
    
    private let viewModel: SettingsViewModelProtocol
    
    private lazy var titleLabel: UILabel = .titleLabel(Constants.titleText,
                                                       size: 20.0)
    
    private lazy var tableView: UITableView = viewModel.makeTableView()
    
    private lazy var backArrowButton: UIButton = .backArrowButton()
        .addAction(self, action: #selector(backButtonDidTap))
    
    init(viewModel: SettingsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - View Controller Life cycle
extension SettingsVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstrains()
    }
    
}

//MARK: - UI Setup
extension SettingsVC {
    
    private func setupUI() {
        view.backgroundColor = .appBg
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(backArrowButton)
    }
    
}

//MARK: - Constrains Setup
extension SettingsVC {

    private func setupConstrains() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(19.0)
        }
        
        backArrowButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(21.0)
            make.size.equalTo(Constants.backArrowButtonSize)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(19.0)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(124.0)
            make.horizontalEdges.equalToSuperview().inset(16.0)
            make.height.equalTo(Constants.tableViewHeight)
        }
        
    }
    
}

//MARK: - Buttons Actions
extension SettingsVC {
    
    @objc private func backButtonDidTap() {
        self.viewModel.backButtonDidTap()
    }
    
}

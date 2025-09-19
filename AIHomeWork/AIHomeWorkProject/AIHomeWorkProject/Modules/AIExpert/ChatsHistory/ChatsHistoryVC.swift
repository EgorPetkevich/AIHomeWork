//
//  ChatsHistoryVC.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 12.09.24.
//

import UIKit
import SnapKit

protocol ChatsHistoryViewModelProtocol {
    func viewDidLoad()
    func viewWillAppear()
    func makeTableView() -> UITableView
    func newChatButtonDidTap()
    func backButtonDidTap()
}

final class ChatsHistoryVC: UIViewController {
    
    private enum Constants {
        //MARK: - Text
        static var titleText: String = "AI Expert"
        static var newChatButtonText: String = "New chat"
        
        //MARK: - Constains
        static var backArrowButtonSize: CGSize = CGSize(width: 30.0,
                                                        height: 24.0)
        static var actionButtonHeight: CGFloat = 64.0
        static var actionButtonCornerRadius = actionButtonHeight / 2
    }
    
    private let viewModel: ChatsHistoryViewModelProtocol
    
    private lazy var titleLabel: UILabel = .titleLabel(Constants.titleText,
                                                       size: 20.0)
    private lazy var tableView: UITableView = viewModel.makeTableView()
    
    private lazy var backArrowButton: UIButton = .backArrowButton()
        .addAction(self, action: #selector(backButtonDidTap))
    
    private lazy var newChatButton: UIButton =
        .actionButton(title: Constants.newChatButtonText,
                      image: .AppIcon.plusImage)
        .addAction(self, action: #selector(newChatButtonDidTap))
    
    init(viewModel: ChatsHistoryViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - View Controller Life cycle
extension ChatsHistoryVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        setupUI()
        setupConstrains()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewWillAppear()
    }
    
}

//MARK: - UI Setup
extension ChatsHistoryVC {
    
    private func setupUI() {
        view.backgroundColor = .appBg
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(backArrowButton)
        
        view.addSubview(newChatButton)
        newChatButton.layer.zPosition = .greatestFiniteMagnitude
        newChatButton.cornerRadius = Constants.actionButtonCornerRadius
        
    }
    
}

//MARK: - Constrains Setup
extension ChatsHistoryVC {

    private func setupConstrains() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(57.0)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(3.0)
        }
        
        backArrowButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(21.0)
            make.size.equalTo(Constants.backArrowButtonSize)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(newChatButton.snp.top).inset(30.0)
        }
        
        newChatButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16.0)
            make.height.equalTo(Constants.actionButtonHeight)
            make.bottom.equalToSuperview().inset(42.0)
        }
        
    }
    
}

//MARK: - Buttons Actions
extension ChatsHistoryVC {
    
    @objc private func backButtonDidTap() {
        self.viewModel.backButtonDidTap()
    }
    
    @objc private func newChatButtonDidTap() {
        viewModel.newChatButtonDidTap()
    }
    
}


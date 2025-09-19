//
//  SolvedTaskVC.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 15.09.24.
//

import UIKit
import SnapKit
import Storage

protocol SolvedTaskViewModelProtocol {
    
    func viewDidLoad()
    func makeTableView() -> UITableView
    func backButtonDidTap()
    func askExpertButtonDidTap()
    func menuButtonDidTap(sender: UIView)
    func reload(with: TaskDTO) 
}

final class SolvedTaskVC: UIViewController {
    
    private enum Constants {
        //MARK: - Text
        static var titleText: String = "Solved tasks"
        static var askExpertButtonText: String = "Ask an Expert"
        
        //MARK: - Constains
        static var backArrowButtonSize: CGSize = CGSize(width: 30.0,
                                                        height: 24.0)
        static var editButtonSize: CGSize = CGSize(width: 24.0,
                                                   height: 24.0)
        static var askExpertButtonHeight: CGFloat = 64.0
        static var askExpertButtonCornerRadius = askExpertButtonHeight / 2
    }
    
    private var viewModel: SolvedTaskViewModelProtocol
    
    private lazy var titleLabel: UILabel = .titleLabel(Constants.titleText,
                                                       size: 20.0)
    private lazy var tableView: UITableView = viewModel.makeTableView()
    
    private lazy var backArrowButton: UIButton = .backArrowButton()
        .addAction(self, action: #selector(backButtonDidTap))
    
    private lazy var editButton: UIButton =
        .editButton()
        .addAction(self, action: #selector(menuButtonDidTap))
    
    private lazy var askExpertButton: UIButton =
        .actionButton(title: Constants.askExpertButtonText)
        .addAction(self, action: #selector(askExpertButtonDidTap))
    
    init(viewModel: SolvedTaskViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with dto: TaskDTO) {
        viewModel.reload(with: dto)
    }
    
}

//MARK: - Bind View Model
extension SolvedTaskVC {
    
    private func bindViewModel() {
        
    }
    
}

//MARK: - View Controller Life cycle
extension SolvedTaskVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        setupUI()
        setupConstrains()
    }
    
}

//MARK: - UI Setup
extension SolvedTaskVC {
    
    private func setupUI() {
        view.backgroundColor = .appBg
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(backArrowButton)
        view.addSubview(editButton)
        view.addSubview(tableView)
        view.addSubview(askExpertButton)
        askExpertButton.cornerRadius = Constants.askExpertButtonCornerRadius
        
    }
    
}

//MARK: - Constrains Setup
extension SolvedTaskVC {

    private func setupConstrains() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(19.0)
        }
        
        backArrowButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(21.0)
            make.size.equalTo(Constants.backArrowButtonSize)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        editButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16.0)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.size.equalTo(Constants.editButtonSize)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(124.0)
            make.horizontalEdges.equalToSuperview().inset(16.0)
        }
        
        askExpertButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(58.0)
            make.horizontalEdges.equalToSuperview().inset(16.0)
            make.height.equalTo(Constants.askExpertButtonHeight)
            make.top.equalTo(tableView.snp.bottom).inset(-38.0)
        }
        
        
    }
    
}

//MARK: - Buttons Actions
extension SolvedTaskVC {
    
    @objc private func backButtonDidTap() {
        self.viewModel.backButtonDidTap()
    }
    
    @objc private func askExpertButtonDidTap() {
        viewModel.askExpertButtonDidTap()
    }
    
    
    @objc private func menuButtonDidTap(_ sender: UIButton) {
        viewModel.menuButtonDidTap(sender: sender)
    }
    
}

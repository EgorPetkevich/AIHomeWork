//
//  SolutionVC.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 11.09.24.
//

import UIKit
import SnapKit

protocol SolutionViewModelProtocol {
    var hideLoadSpinerView: (() -> Void)? { get set }
    var showLoadSpiner: (() -> Void)? { get set }
    
    func subjectType() -> Subjects
    func makeTableView() -> UITableView
    func backButtonDidTap()
    func tryAgainButtonDidTap()
    func newTaskButtonDidTap()
    func menuButtonDidTap(sender: UIView)
}

final class SolutionVC: UIViewController {
    
    private enum Constants {
        //MARK: - Text
        static func titleText(for subject: Subjects) -> String {
            switch subject {
            case .biology: return "Biology task"
            case .chemistry: return "Chemistry task"
            case .grammar: return "Grammar check"
            case .litSummary: return "Literary Summary"
            case .math: return "Mathematics task"
            case .physics: return "Physics task"
            case .result: return "Results"
            }
        }
        
        static var newTaskButtonText: String = "New task"
        static var tryAgainButtonText: String = "Try again"
        static var loadSubTitleText: String = "Scanning in progress. Please wait\nwhile your task are being processed..."
        
        //MARK: - Constains
        static var backArrowButtonSize: CGSize = CGSize(width: 30.0,
                                                        height: 24.0)
        static var editButtonSize: CGSize = CGSize(width: 24.0,
                                                   height: 24.0)
        static var actionButtonHeight: CGFloat = 64.0
        static var actionButtonCornerRadius = actionButtonHeight / 2
    }
    
    private var viewModel: SolutionViewModelProtocol
    
    private lazy var titleLabel: UILabel = .titleLabel(Constants.titleText(for: viewModel.subjectType()),
                                                       size: 20.0)
    private lazy var tableView: UITableView = viewModel.makeTableView()
    private lazy var actionView: UIView = .contentView()
    private lazy var loadSpinerView: LoadSpinerView = LoadSpinerView(
        titleText: Constants.titleText(for: viewModel.subjectType()),
        subTitleText: Constants.loadSubTitleText)
    
    private lazy var backArrowButton: UIButton = .backArrowButton()
        .addAction(self, action: #selector(backButtonDidTap))
    
    private lazy var editButton: UIButton =
        .editButton()
        .addAction(self, action: #selector(menuButtonDidTap))
    
    private lazy var newTaskButton: UIButton =
        .actionButton(title: Constants.newTaskButtonText)
        .addAction(self, action: #selector(newTaskButtonDidTap))
    
    private lazy var tryAgainButton: UIButton =
        .clearButton(Constants.tryAgainButtonText,
                     tintColor: .appBlack,
                     borderWidth: 1.5)
        .addAction(self, action: #selector(tryAgainButtonDidTap))
    
    init(viewModel: SolutionViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Bind View Model
extension SolutionVC {
    
    private func bindViewModel() {
        viewModel.hideLoadSpinerView = { [weak loadSpinerView] in
            loadSpinerView?.isHidden = true
        }
        
        viewModel.showLoadSpiner = { [weak loadSpinerView] in
            loadSpinerView?.isHidden = false
        }
    }
    
}

//MARK: - View Controller Life cycle
extension SolutionVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstrains()
    }
    
}

//MARK: - UI Setup
extension SolutionVC {
    
    private func setupUI() {
        view.backgroundColor = .appBg
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(backArrowButton)
        view.addSubview(actionView)
        view.addSubview(editButton)
        view.addSubview(loadSpinerView)
        loadSpinerView.layer.zPosition = .greatestFiniteMagnitude
        
        actionView.addSubview(newTaskButton)
        actionView.addSubview(tryAgainButton)
        newTaskButton.cornerRadius = Constants.actionButtonCornerRadius
        tryAgainButton.cornerRadius = Constants.actionButtonCornerRadius
        
    }
    
}

//MARK: - Constrains Setup
extension SolutionVC {

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
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(actionView.snp.top)
        }
        
        actionView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
        }
        
        newTaskButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(16.0)
            make.height.equalTo(Constants.actionButtonHeight)
            make.bottom.equalToSuperview().inset(42.0)
            make.left.equalTo(actionView.snp.centerX).offset(4)
        }
        
        tryAgainButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16.0)
            make.height.equalTo(Constants.actionButtonHeight)
            make.right.equalTo(actionView.snp.centerX).inset(-4)
            make.bottom.equalToSuperview().inset(42.0)
        }
        
        loadSpinerView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview()
        }
        
    }
    
}

//MARK: - Buttons Actions
extension SolutionVC {
    
    @objc private func backButtonDidTap() {
        self.viewModel.backButtonDidTap()
    }
    
    @objc private func newTaskButtonDidTap() {
        viewModel.newTaskButtonDidTap()
    }
    
    @objc private func tryAgainButtonDidTap() {
        viewModel.tryAgainButtonDidTap()
    }
    
    @objc private func menuButtonDidTap(_ sender: UIButton) {
        viewModel.menuButtonDidTap(sender: sender)
    }
    
}


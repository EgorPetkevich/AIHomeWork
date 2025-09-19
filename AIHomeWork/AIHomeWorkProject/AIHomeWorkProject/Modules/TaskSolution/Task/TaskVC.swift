//
//  TaskVC.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 3.09.24.
//

import UIKit
import SnapKit

protocol TaskViewModelProtocol {
    var keyboardOnWillShow: (() -> Void)? { get set }
    var keyboardOnWillHide: (() -> Void)? { get set }
    var taskMessage: ((String) -> Void)? { get set }
    var showLoadSpiner: (() -> Void)? { get set }
    var hideLoadSpinerView: (() -> Void)? { get set }
    
    func viewDidLoad()
    func scanButtonDidTap()
    func backButtonDidTap()
    func actionButtonDidTap(task: String)
    func subjectType() -> Subjects
}

final class TaskVC: UIViewController {
    
    private enum Constants {
        
        //MARK: - Text
        static let typeTitleText: String = "Type"
        static var loadSubTitleText: String = "Scanning in progress. Please wait\nwhile your task are being processed..."
        
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
        
        static func actionButtonText(for subject: Subjects) -> String {
            switch subject {
            case .litSummary: return "Summary"
            case .grammar: return "Check"
            default: return "Get solution"
            }
        }
        
        //MARK: - Constrains
        static var backArrowButtonSize: CGSize = CGSize(width: 30.0,
                                                        height: 24.0)
        
    }
    
    private var viewModel: TaskViewModelProtocol
    
    private lazy var titleLabel: UILabel = 
        .titleLabel(Constants.titleText(for: viewModel.subjectType()),
                    size: 20.0)
    private lazy var loadSpinerView: LoadSpinerView = LoadSpinerView(
        titleText: Constants.titleText(for: viewModel.subjectType()),
        subTitleText: Constants.loadSubTitleText)
    
    private lazy var backArrowButton: UIButton = .backArrowButton()
        .addAction(self, action: #selector(backButtonDidTap))
    private lazy var actionButton: ActivityButton = 
    ActivityButton(
        target: self,
        action: #selector(actionButtonDidTap)
    ).setTitle(Constants.actionButtonText(for: viewModel.subjectType()))
    
    private lazy var buttonBlockingView: UIView = .buttonBlockingView()
    
    private lazy var scanButton: ScanButton =
    ScanButton(target: self, action: #selector(scanButtonDidTap))
    
    private lazy var questionTextView: QuestionTextView = QuestionTextView()
    
    init(viewModel: TaskViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindKeyboard()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clearTextView() {
        self.questionTextView.textViewIsEmpty = true
    }
    
}

//MARK: Bind View Model
extension TaskVC {
    
    private func bindViewModel() {
        viewModel.taskMessage = { [weak questionTextView] taskMessage in
            questionTextView?.setText(taskMessage)
        }
        
        viewModel.hideLoadSpinerView = { [weak loadSpinerView] in
            loadSpinerView?.isHidden = true
        }
        
        viewModel.showLoadSpiner = { [weak loadSpinerView] in
            loadSpinerView?.isHidden = false
        }
    }
    
}

//MARK: - View Controller Life cycle
extension TaskVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        addTapGesture()
        setupUI()
        setupConstrains()
    }
    
}

//MARK: - UI Setup
extension TaskVC {
    
    private func setupUI() {
        view.backgroundColor = .appBg
        view.addSubview(titleLabel)
        view.addSubview(backArrowButton)
        view.addSubview(actionButton)
        view.addSubview(questionTextView)
        view.addSubview(scanButton)
        view.addSubview(loadSpinerView)
        loadSpinerView.layer.zPosition = .greatestFiniteMagnitude
        loadSpinerView.isHidden = true
        actionButton.addSubview(buttonBlockingView)
        
    }
    
}

//MARK: - Constrains Setup
extension TaskVC {

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
        
        actionButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(58.0)
            make.horizontalEdges.equalToSuperview().inset(16.0)
        }
        
        questionTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16.0)
            make.top.equalTo(titleLabel.snp.bottom).inset(-16.0)
        }
        
        scanButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(15.0)
            make.top.equalTo(questionTextView.snp.bottom).inset(-40.0)
        }
        
        buttonBlockingView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview()
        }
        
        loadSpinerView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview()
        }
        
    }
    
}


//MARK: - Buttons Actions
extension TaskVC {
    
    @objc private func scanButtonDidTap() {
        viewModel.scanButtonDidTap()
    }
    
    @objc private func actionButtonDidTap() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        actionButton.strartActivityAnimation()
        
        DispatchQueue.main.async { [weak actionButton] in
            actionButton?.stopActivityAnimation()
        }
        
        self.viewModel.actionButtonDidTap(task: questionTextView.textViewText)
    }
    
    @objc private func backButtonDidTap() {
        self.viewModel.backButtonDidTap()
    }
    
}

//MARK: - Bind Keybord
extension TaskVC {
    
    private func bindKeyboard() {
        viewModel.keyboardOnWillShow = { [weak questionTextView] in
            questionTextView?.symbolCountLabelIsHiden = false
        }
        viewModel.keyboardOnWillHide = { [weak self] in
            self?.questionTextView.symbolCountLabelIsHiden = true
            self?.toggleActionButtonOnKeyboardDismiss()
        }
        
    }
    
    private func toggleActionButtonOnKeyboardDismiss() {
        if questionTextView.textViewIsEmpty {
            buttonBlockingView.isHidden = false
        } else {
            buttonBlockingView.isHidden = true
        }
    }
    
}

//MARK: - Add TapGesture To Hide Keyboard
extension TaskVC {
    
    private func addTapGesture() {
        let tapGesture =
        UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func tapGesture() {
        questionTextView.hideKeybord()
    }
    
}

//
//  AIExpertChatVC.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 12.09.24.
//

import UIKit
import SnapKit

protocol AIExpertChatViewModelProtocol {
    var keyboardOnWillShow: ((CGRect) -> Void)? { get set }
    var keyboardOnWillHide: (() -> Void)? { get set }
    var newConversationName: ((String) -> Void)? { get set }
    var allowSendind: ((Bool) -> Void)? { get set }
    var imageDidSelect: ((UIImage) -> Void)? { get set }
    var allowImagePicking: ((Bool) -> Void)? { get set }
    var saveImageCompleted: (() -> Void)? { get set }
    var allowChatEditing: ((Bool) -> Void)? { get set } 
    
    func viewDidLoad()
    func sendButtonDidTap(userRequest: String)
    func makeTableView() -> UITableView
    func backButtonDidTap()
    func openGalleryButtonDidTap()
    func menuButtonDidTap(sender: UIView)
    func loadingImageCanceled()
    func loadImageAnimationCompleted()
}

final class AIExpertChatVC: UIViewController {
    
    private enum Constants {
        //MARK: - Text
        static var titleText: String = "New Chat"
        
        //MARK: - Constains
        static var backArrowButtonSize: CGSize = CGSize(width: 30.0,
                                                        height: 24.0)
        static var editButtonSize: CGSize = CGSize(width: 24.0,
                                                   height: 24.0)
    }
    
    private var loadingImageCancelled = false
    
    private var viewModel: AIExpertChatViewModelProtocol
    
    private lazy var titleLabel: UILabel = .titleLabel(Constants.titleText,
                                                       size: 20.0)
    private lazy var tableView: UITableView = viewModel.makeTableView()
    private lazy var chatView: ChatView = ChatView(
        target: self,
        sendAction: #selector(sendButtonDidTap),
        openGalleryAction: #selector(openGalleryButtonDidTap))
    
    private lazy var backArrowButton: UIButton = .backArrowButton()
        .addAction(self, action: #selector(backButtonDidTap))
    
    private lazy var editButton: UIButton =
        .editButton()
        .addAction(self, action: #selector(menuButtonDidTap))
    
    private lazy var selectedImageView: UIView = UIView()
    
    private lazy var loadingImageView: LoadingImageView = LoadingImageView(
        target: self, action: #selector(cancelLoadingImageButtonDidTap))
    
    init(viewModel: AIExpertChatViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
        addTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: Bind View Model
extension AIExpertChatVC {
    
    private func bindViewModel() {
        viewModel.keyboardOnWillShow = { [weak chatView] keybordFrame in
            chatView?.snp.removeConstraints()
            chatView?.snp.makeConstraints({ make in
                make.height.equalTo(50.0)
                make.bottom.equalToSuperview().inset(keybordFrame.height)
                make.horizontalEdges.equalToSuperview()
            })
        }
        viewModel.keyboardOnWillHide = { [weak chatView] in
            chatView?.snp.removeConstraints()
            chatView?.snp.makeConstraints({ make in
                make.horizontalEdges.equalToSuperview()
                make.height.equalTo(50.0)
                make.bottom.equalToSuperview().inset(44.0)
            })
        }
        
        viewModel.newConversationName = { [weak titleLabel] newName in
            titleLabel?.text = newName
        }
        
        viewModel.allowSendind = { [weak chatView] sender in
            chatView?.allowSendind = sender
        }
        
        viewModel.allowImagePicking = { [weak chatView] sender in
            chatView?.allowImagePicking = sender
        }
        
        viewModel.allowChatEditing = { [weak chatView] sender in
            chatView?.allowTextViewEditing = sender
        }
        
        viewModel.imageDidSelect = { [weak selectedImageView, loadingImageView]
            image in
            loadingImageView.show(on: selectedImageView, image: image)
            self.loadingImageCancelled = false
        }
        
        viewModel.saveImageCompleted = { [weak self] in
            self?.loadingImageView.finishActivityIndicator {
                guard self?.loadingImageCancelled == false else { return }
                self?.chatView.allowImageSending = true
                self?.viewModel.loadImageAnimationCompleted()
            }
        }
    }

    
}

//MARK: - View Controller Life cycle
extension AIExpertChatVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        setupUI()
        setupConstrains()
    }
    
}

//MARK: - UI Setup
extension AIExpertChatVC {
    
    private func setupUI() {
        view.backgroundColor = .appBg
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(backArrowButton)
        view.addSubview(editButton)
        view.addSubview(chatView)
        view.addSubview(selectedImageView)
        selectedImageView.layer.zPosition = .greatestFiniteMagnitude
    }
    
}

//MARK: - Constrains Setup
extension AIExpertChatVC {

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
        
        editButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16.0)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.size.equalTo(Constants.editButtonSize)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(chatView.snp.top)
        }
        
        chatView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(44.0)
            make.height.equalTo(44.0)
        }
        
        selectedImageView.snp.makeConstraints { make in
            make.bottom.equalTo(chatView.snp.top).inset(-10.0)
            make.left.equalToSuperview().inset(16.0)
        }
        
    }
    
}

//MARK: - Buttons Actions
extension AIExpertChatVC {
    
    @objc private func backButtonDidTap() {
        self.viewModel.backButtonDidTap()
    }
    
    @objc private func menuButtonDidTap(_ sender: UIButton) {
        viewModel.menuButtonDidTap(sender: sender)
    }
    
    @objc private func sendButtonDidTap() {
        loadingImageView.hide()
        viewModel.sendButtonDidTap(userRequest: chatView.getText)
        chatView.textViewIsEmpty = true
    }
    
    @objc private func openGalleryButtonDidTap() {
        viewModel.openGalleryButtonDidTap()
    }
    
    @objc private func cancelLoadingImageButtonDidTap() {
        self.loadingImageCancelled = true
        chatView.allowImageSending = false
        chatView.allowSendind = true
        chatView.allowImagePicking = true
        chatView.allowTextViewEditing = true
        loadingImageView.hide()
        viewModel.loadingImageCanceled()
    }
    
}

//MARK: - Add TapGesture To Hide Keyboard
extension AIExpertChatVC {
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        tableView.addGestureRecognizer(tapGesture)
    }


    @objc private func tapGesture() {
        chatView.hideKeybord()
    }
    
}


//
//  TaskNotRecognizedVC.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 10.09.24.
//

import UIKit
import SnapKit
import Lottie

protocol TaskNotRecognizedViewModelProtocol {
    var delayAnimation: (() -> Void)? { get set }
    func viewDidLoad()
    func retakePhotoButtonDidTap()
}

final class TaskNotRecognizedVC: UIViewController {
    
    private enum Constants {
        //MARK: - Text
        static let titleText: String = "Task not Recognized"
        static let subTitleText: String = "Please take a new photo and\ntry again."
        static let retakePhotoButtonText: String = "Retake photo"
        
        //MARK: - Constrains
        static let crossAnimationViewSize = CGSize(width: 74.0, height: 74.0)
        static let retakePhotoButtonHeight: CGFloat = 64.0
        static let retakePhotoButtonRadius = retakePhotoButtonHeight / 2
    }
    
    private var viewModel: TaskNotRecognizedViewModelProtocol
    
    private lazy var crossAnimationView: LottieAnimationView = .crossAnimation
    
    private lazy var titleLabel: UILabel = .titleLabel(
        Constants.titleText, size: 20)
    private lazy var subTitleLabel: UILabel = .subTitleLabel(
        Constants.subTitleText, size: 15.0)
    
    private lazy var retakePhotoButton: UIButton = .actionButton(
        title: Constants.retakePhotoButtonText)
    .addAction(self, action: #selector(retakePhotoButtonDidTap))
    
    init(viewModel: TaskNotRecognizedViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Bind View Model
extension TaskNotRecognizedVC {
    
    private func bindViewModel() {
        viewModel.delayAnimation = { [weak self] in
            self?.crossAnimationView.play()
        }
    }
    
}

//MARK: - View Controller Life Cycle
extension TaskNotRecognizedVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        setupUI()
        setupConstrains()
    }
    
}

//MARK: - UI Setup
extension TaskNotRecognizedVC {
    
    private func setupUI() {
        preferredContentSize = CGSize(width: view.frame.width, height: 300)
        view.backgroundColor = .appBg
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(crossAnimationView)
        view.addSubview(retakePhotoButton)
        retakePhotoButton.cornerRadius = Constants.retakePhotoButtonRadius
    }
    
}

//MARK: - Constrains Setup
extension TaskNotRecognizedVC {
    
    private func setupConstrains() {
        
        crossAnimationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(8.0)
            make.size.equalTo(Constants.crossAnimationViewSize)
        }
    
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(crossAnimationView.snp.bottom).inset(-10.0)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).inset(-10.0)
        }
        
        retakePhotoButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16.0)
            make.top.equalTo(subTitleLabel.snp.bottom).inset(-24.0)
            make.height.equalTo(Constants.retakePhotoButtonHeight)
        }
       
    }
    
}

//MARK: - Button Actions
extension TaskNotRecognizedVC {
    
    @objc private func retakePhotoButtonDidTap() {
        viewModel.retakePhotoButtonDidTap()
    }
    
}

extension TaskNotRecognizedVC: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController
    ) -> UIPresentationController? {
            return CustomPresentationController(
                presentedViewController: presented,
                presenting: presenting)
        }
    
}


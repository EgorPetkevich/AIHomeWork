//
//  OnboardingRevFirstStepVC.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 27.08.24.
//

import UIKit

protocol OnboardingRevFirstStepViewModelProtocol {
    
    func activityButtonDidTap()
}

final class OnboardingRevFirstStepVC: UIViewController {
    
    private enum Constants {
        
        // MARK: - Text
        static let titleText: String = "Detailed Guide: Step-\nBy-Step Solution"
        static let subTitleText: String = "Receive instant, detailed explanations\nthrough step-by-step guidance"
        static let activityButtonTitle: String = "Go"
        
    }
    
    private let viewModel: OnboardingRevFirstStepViewModelProtocol
    
    private lazy var contentView: UIView = .contentView()
    private lazy var mainImageView: UIImageView =
    UIImageView(image: .Onboarding.FirstStep.bgImage)
    
    private lazy var titleLabel: UILabel =
        .titleLabel(Constants.titleText)
    private lazy var subTitleLabel: UILabel =
        .revSubTitleLabel(Constants.subTitleText)
    
    private lazy var activityButton: ActivityButton =
    ActivityButton(target: self,
                   action: #selector(activityButtonDidTap))
    .setTitle(Constants.activityButtonTitle)
    
    init(viewModel: OnboardingRevFirstStepViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - View Controller Life cycle
extension OnboardingRevFirstStepVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstrains()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityButton.startBounceAnimation()
    }
    
}

//MARK: - Bind ViewModel
extension OnboardingRevFirstStepVC {
    
    private func bind() {
        
    }
    
}

//MARK: - Setup UI
extension OnboardingRevFirstStepVC {
    
    private func setupUI() {
        view.backgroundColor = .appBg
        view.addSubview(mainImageView)
        view.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(activityButton)
    }
    
}
//MARK: - Constrains Setup
extension OnboardingRevFirstStepVC {
    
    private func setupConstrains() {
        mainImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.horizontalEdges.equalToSuperview().inset(12.0)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-16.0)
            make.horizontalEdges.equalToSuperview().inset(12.0)
            make.bottom.equalTo(activityButton.snp.top).inset(-24.0)
        }
        
        activityButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(58.0)
            make.horizontalEdges.equalToSuperview().inset(16.0)
        }
        
    }
    
}

//MARK: - Button action
extension OnboardingRevFirstStepVC {
    
    @objc private func activityButtonDidTap() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        activityButton.strartActivityAnimation()
        
        DispatchQueue.main.async { [weak activityButton] in
            activityButton?.stopActivityAnimation()
        }
        
        self.viewModel.activityButtonDidTap()
    }
    
}

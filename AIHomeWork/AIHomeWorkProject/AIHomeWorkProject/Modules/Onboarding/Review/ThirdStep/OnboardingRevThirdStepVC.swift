//
//  OnboardingRevThirdStepVC.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 27.08.24.
//

import UIKit

protocol OnboardingRevThirdStepProdViewModelProtocol {
    
    func activityButtonDidTap()
}

final class OnboardingRevThirdStepVC: UIViewController {
    
    private enum Constants {
        
        // MARK: - Text
        static let titleText: String = "Assistance With\nStudying Any Subject"
        static let subTitleText: String = "Support for All Core Subjects: Math,\nScience, Essay Writing"
        static let activityButtonTitle: String = "Continue"
        
    }
    
    private let viewModel: OnboardingRevThirdStepProdViewModelProtocol
    
    private lazy var contentView: UIView = .contentView()
    private lazy var imageBgView: UIView = UIView()
    
    private lazy var titleLabel: UILabel =
        .titleLabel(Constants.titleText)
    private lazy var subTitleLabel: UILabel =
        .revSubTitleLabel(Constants.subTitleText)
    
    private lazy var activityButton: ActivityButton =
    ActivityButton(target: self,
                   action: #selector(activityButtonDidTap))
    .setTitle(Constants.activityButtonTitle)
    
    init(viewModel: OnboardingRevThirdStepProdViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - View Controller Life cycle
extension OnboardingRevThirdStepVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupMainImageView()
        setupConstrains()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityButton.startBounceAnimation()
    }
    
}

//MARK: - Bind ViewModel
extension OnboardingRevThirdStepVC {
    
    private func bind() {
        
    }
    
}

//MARK: - Setup UI
extension OnboardingRevThirdStepVC {
    
    private func setupUI() {
        view.backgroundColor = .appBg
        view.addSubview(imageBgView)
        view.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(activityButton)
        contentView.layer.zPosition = .greatestFiniteMagnitude
    }
    
}
//MARK: - Constrains Setup
extension OnboardingRevThirdStepVC {
    
    private func setupConstrains() {
        imageBgView.snp.makeConstraints { make in
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

//MARK: - Button Action
extension OnboardingRevThirdStepVC {
    
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

//MARK: - Setup main ImageView
extension OnboardingRevThirdStepVC {
    
    private func setupMainImageView() {
        let iphoneImageView: UIImageView =
        UIImageView(image: .Onboarding.ThirdStep.iponeImage)
        let overviewImageView: UIImageView =
        UIImageView(image: .Onboarding.ThirdStep.overviewImage)
        
        //UI Setup
        imageBgView.addSubview(iphoneImageView)
        imageBgView.addSubview(overviewImageView)
        overviewImageView.layer.zPosition = .greatestFiniteMagnitude
        
        //Constrains Setup
        iphoneImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(65.0)
            make.bottom.equalToSuperview()
        }
        overviewImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(contentView.snp.top).inset(20)
        }
    }
    
}

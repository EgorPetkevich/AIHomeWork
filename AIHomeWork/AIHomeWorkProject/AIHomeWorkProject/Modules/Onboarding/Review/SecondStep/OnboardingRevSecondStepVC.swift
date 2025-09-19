//
//  OnboardingRevSecondStepVC.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 27.08.24.
//

import UIKit

protocol OnboardingRevSecondStepViewModelProtocol {
    func viewDidLoad()
    func activityButtonDidTap()
}

final class OnboardingRevSecondStepVC: UIViewController {
    
    private enum Constants {
        
        // MARK: - Text
        static let titleText: String = "Scan & Type\nAny Task "
        static let subTitleText: String = "Get quick and efficient help by scanning\nany task with your camera."
        static let activityButtonTitle: String = "Continue"
        
        //MARK: - Layer Z Position
        static let iphoneContentImageViewZPosition: CGFloat = 1
        static let solutionImageViewZPosition: CGFloat = 2
        static let girlImageViewZPosition: CGFloat = 2
        
    }
    
    private let viewModel: OnboardingRevSecondStepViewModelProtocol
    
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
    
    init(viewModel: OnboardingRevSecondStepViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - View Controller Life cycle
extension OnboardingRevSecondStepVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
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
extension OnboardingRevSecondStepVC {
    
    private func bind() {
        
    }
    
}

//MARK: - Setup UI
extension OnboardingRevSecondStepVC {
    
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
extension OnboardingRevSecondStepVC {
    
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
extension OnboardingRevSecondStepVC {
    
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
extension OnboardingRevSecondStepVC {
    
    private func setupMainImageView() {
        let girlImageView: UIImageView =
        UIImageView(image: .Onboarding.SecondStep.girlImage)
        let iphoneImageView: UIImageView =
        UIImageView(image: .Onboarding.SecondStep.ihoneImage)
        let solutionImageView: UIImageView =
        UIImageView(image: .Onboarding.SecondStep.solutionImage)
        let iphoneContentImageView: UIImageView =
        UIImageView(image: .Onboarding.SecondStep.iponeContentImage)
        
        //UI Setup
        imageBgView.addSubview(iphoneImageView)
        imageBgView.addSubview(girlImageView)
        imageBgView.addSubview(solutionImageView)
        imageBgView.addSubview(iphoneContentImageView)
        iphoneContentImageView.layer.zPosition = 
        Constants.iphoneContentImageViewZPosition
        solutionImageView.layer.zPosition =
        Constants.solutionImageViewZPosition
        girlImageView.layer.zPosition = 
        Constants.girlImageViewZPosition
        
        
        //Constrains Setup
        iphoneImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(65.0)
            make.bottom.equalToSuperview()
        }
        girlImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalTo(contentView.snp.top)
        }
        solutionImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16.0)
            make.top.equalTo(iphoneImageView.snp.top).inset(103.0)
        }
        iphoneContentImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(11.0)
            make.top.equalTo(solutionImageView.snp.top).inset(26.0)
        }
    }
    
}

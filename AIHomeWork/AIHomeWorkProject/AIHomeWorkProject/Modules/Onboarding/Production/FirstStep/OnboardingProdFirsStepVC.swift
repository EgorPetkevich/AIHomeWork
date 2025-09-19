//
//  OnbordingProdFirstStepVC.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 25.08.24.
//

import UIKit

protocol OnboardingProdFirstStepViewModelProtocol {
    func activityButtonDidTap()
}

final class OnboardingProdFirstStepVC: UIViewController {
    
    private enum Constants {
        
        // MARK: - Text
        static let titleText: String = "Detailed Guide: Step-\nBy-Step Solution"
        static let subTitleText: String = "Receive instant, detailed explanations\nthrough step-by-step guidance"
        static let activityButtonTitle: String = "Go"
        
        // MARK: - Page Control
        static let numOfPages: Int = OnboardingManager.numOfPages
        static let currentPage: Int = OnboardingManager.ProductionOnboardingPage.first.rawValue
        
    }
    
    private let viewModel: OnboardingProdFirstStepViewModelProtocol
    
    private lazy var contentView: UIView = .contentView()
    private lazy var mainImageView: UIImageView =
    UIImageView(image: .Onboarding.FirstStep.bgImage)
    
    private lazy var titleLabel: UILabel = 
        .titleLabel(Constants.titleText)
    private lazy var subTitleLabel: UILabel =
        .prodSubTitleLabel(Constants.subTitleText)
    
    private lazy var pageControl: UIPageControl =
        .set(numOfPages: Constants.numOfPages,
             currentPage: Constants.currentPage)
    
    private lazy var activityButton: ActivityButton =
    ActivityButton(target: self,
                   action: #selector(activityButtonDidTap))
    .setTitle(Constants.activityButtonTitle)
    
    init(viewModel: OnboardingProdFirstStepViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - View Controller Life cycle
extension OnboardingProdFirstStepVC {
    
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
extension OnboardingProdFirstStepVC {
    
    private func bind() {
        
    }
    
}

//MARK: - Setup UI
extension OnboardingProdFirstStepVC {
    
    private func setupUI() {
        view.backgroundColor = .appBg
        view.addSubview(mainImageView)
        view.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(pageControl)
        contentView.addSubview(activityButton)
    }
    
}
//MARK: - Constrains Setup
extension OnboardingProdFirstStepVC {
    
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
            make.bottom.equalTo(activityButton.snp.top).inset(-54.0)
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(activityButton.snp.top).inset(-10.0)
            make.centerX.equalToSuperview()
        }
        
        activityButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(58.0)
            make.horizontalEdges.equalToSuperview().inset(16.0)
        }
        
    }
    
}

//MARK: - Button action
extension OnboardingProdFirstStepVC {
    
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



//
//  PaywallReviewVC.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 28.08.24.
//

import UIKit
import SnapKit

protocol PaywallReviewViewModelProtocol {
    var trialPrice: String { get }
    var weaklyPrice: String { get }
    
    var changeWeaklyText: ((_ price: String) -> Void)? { get set }
    var changeTrialText: ((_ price: String) -> Void)? { get set }
    var showCrossButton: (() -> Void)? { get set }
    var stopActivityAnimation: (() -> Void)? { get set }
    
    func switchStatusDidChanged(_ sender: Bool)
    func activityButtonDidTap()
    func privacyButtonDidTap()
    func restoreButtonDidTap()
    func termsButtonDidTap()
    func crossButtonDidTap()
    
    func viewDidAppear()
}

final class PaywallReviewVC: UIViewController {
    
    private enum Constants {
        
        // MARK: - Text
        static let titleText: String = "Full Access\nTo All Features"
        
        static func subTitleText(with price: String) -> String {
            "Start AI Homework app\nwith no limits just for \(price)/week."
        }
        static func subTitleTrialText(with price: String) -> String {
            "Start a 3-day free trial of AI Homework with no limits just for \(price)/week."
        }
        static func activityButtonTitle(with price: String) -> String {
            "Continue for just \(price)/week"
        }
        static func activityButtonTrialTitle(with price: String) -> String {
            "Try 3-day free trial, then \(price)/week"
        }
        
        //MARK: - Layer Z Position
        static let biologyImageViewZPosition: CGFloat = 1
        static let physicsImageViewZPosition: CGFloat = 2
        static let grammarImageViewZPosition: CGFloat = 1
    }
    
    private var viewModel: PaywallReviewViewModelProtocol
    
    private lazy var contentView: UIView = .contentView()
    private lazy var imageBgView: UIView = UIView()
    
    private lazy var titleLabel: UILabel =
        .titleLabel(Constants.titleText)
    private lazy var subTitleLabel: UILabel =
        .revSubTitleLabel(
            Constants
                .subTitleText(with: viewModel.weaklyPrice)
        )
    
    private lazy var trialSwitch: PaywallTrialSwitch =
    PaywallTrialSwitch(target: self, action: #selector(switchStatusDidChange))
    
    private lazy var activityButton: ActivityButton =
    ActivityButton(
        target: self,
        action: #selector(activityButtonDidTap)
    )
    .setPaywallRevTitle(Constants.activityButtonTitle(with: viewModel.trialPrice))
    
    private lazy var privacyButton: UIButton =
        .underActionButton(title: "Privacy")
        .addAction(self,action: #selector(privacyButtonDidTap))
    private lazy var restoreButton: UIButton =
        .underActionButton(title: "Restore")
        .addAction(self, action: #selector(restoreButtonDidTap))
    private lazy var termsButton: UIButton =
        .underActionButton(title: "Terms")
        .addAction(self, action: #selector(termsButtonDidTap))
    
    private lazy var crossButton: UIButton =
        .crossButton()
        .addAction(self, action: #selector(crossButtonDidTap))
    
    init(viewModel: PaywallReviewViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - View Controller Life cycle
extension PaywallReviewVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupMainImageView()
        setupConstrains()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
        activityButton.startBounceAnimation()
    }
    
}

//MARK: - Bind ViewModel
extension PaywallReviewVC {
    
    private func bind() {
        viewModel.changeTrialText = { [weak self]  price in
            self?.subTitleLabel.text =
            Constants.subTitleText(with: price)
            self?.activityButton.setPaywallRevTitle =
            Constants.activityButtonTitle(with: price)
        }
        
        viewModel.changeWeaklyText = { [weak self] price in
            self?.subTitleLabel.text =
            Constants.subTitleTrialText(with: price)
            self?.activityButton.setPaywallRevTitle =
            Constants.activityButtonTrialTitle(with: price)
        }
        
        viewModel.showCrossButton = { [weak crossButton] in
            crossButton?.isHidden = false
        }
        
        viewModel.stopActivityAnimation = { [weak activityButton] in
            activityButton?.stopActivityAnimation()
        }
    }
    
}

//MARK: - Setup UI
extension PaywallReviewVC {
    
    private func setupUI() {
        view.backgroundColor = .appBg
        view.addSubview(imageBgView)
        view.addSubview(contentView)
        view.addSubview(crossButton)
        crossButton.isHidden = true
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(trialSwitch)
        contentView.addSubview(activityButton)
        contentView.addSubview(restoreButton)
        contentView.addSubview(privacyButton)
        contentView.addSubview(termsButton)
        contentView.layer.zPosition = .greatestFiniteMagnitude
    }
    
}
//MARK: - Constrains Setup
extension PaywallReviewVC {
    
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
            make.bottom.equalTo(trialSwitch.snp.top).inset(-26.0)
        }
        
        trialSwitch.snp.makeConstraints { make in
            make.bottom.equalTo(activityButton.snp.top).inset(-8.0)
            make.horizontalEdges.equalToSuperview().inset(16.0)
        }
        
        activityButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(58.0)
            make.horizontalEdges.equalToSuperview().inset(16.0)
        }
        
        privacyButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(34.0)
            make.top.equalTo(activityButton.snp.bottom).offset(4.0)
            make.height.equalTo(17.0)
        }
        
        restoreButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(activityButton.snp.bottom).offset(4.0)
            make.height.equalTo(17.0)
        }
        
        termsButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(34.0)
            make.top.equalTo(activityButton.snp.bottom).offset(4.0)
            make.height.equalTo(17.0)
        }
        
        crossButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(69.0)
            make.left.equalTo(16.0)
            make.size.equalTo(20.0)
        }
        
    }
    
}

//MARK: - Button Action
extension PaywallReviewVC {
    
    @objc private func activityButtonDidTap() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        activityButton.strartActivityAnimation()
        
        self.viewModel.activityButtonDidTap()
    }
    
    @objc private func privacyButtonDidTap() {
        viewModel.privacyButtonDidTap()
    }
    
    @objc private func restoreButtonDidTap() {
        viewModel.restoreButtonDidTap()
    }
    
    @objc private func termsButtonDidTap() {
        viewModel.termsButtonDidTap()
    }
    
    @objc func crossButtonDidTap() {
        viewModel.crossButtonDidTap()
    }
    
}

//MARK: - Setup main ImageView
extension PaywallReviewVC {
    
    private func setupMainImageView() {
        let iphoneImageView: UIImageView =
        UIImageView(image: .Paywall.iphoneImage)
        let biologyImageView: UIImageView =
        UIImageView(image: .Paywall.biologyImage)
        let physicsImageView: UIImageView =
        UIImageView(image: .Paywall.physicsImage)
        let grammarImageView: UIImageView =
        UIImageView(image: .Paywall.grammerImage)
        
        //UI Setup
        imageBgView.addSubview(iphoneImageView)
        imageBgView.addSubview(biologyImageView)
        imageBgView.addSubview(physicsImageView)
        imageBgView.addSubview(grammarImageView)
        biologyImageView.layer.zPosition = Constants.biologyImageViewZPosition
        physicsImageView.layer.zPosition = Constants.physicsImageViewZPosition
        grammarImageView.layer.zPosition = Constants.grammarImageViewZPosition
        
        //Constrains Setup
        iphoneImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(65.0)
            make.bottom.equalToSuperview()
        }
        
        biologyImageView.snp.makeConstraints { make in
            make.right.equalTo(physicsImageView.snp.right).inset(120.0)
            make.top.equalTo(physicsImageView.snp.top).inset(15.0)
        }
        physicsImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(contentView.snp.top).inset(50.0)
        }
        grammarImageView.snp.makeConstraints { make in
            make.left.equalTo(physicsImageView.snp.left).inset(140.0)
            make.top.equalTo(physicsImageView.snp.top).inset(35.0)
        }
        
    }
    
}

//MARK: - Trial Action Switch
extension PaywallReviewVC {
    
    @objc func switchStatusDidChange(_ sender: UISwitch) {
        viewModel.switchStatusDidChanged(sender.isOn)
    }
    
}

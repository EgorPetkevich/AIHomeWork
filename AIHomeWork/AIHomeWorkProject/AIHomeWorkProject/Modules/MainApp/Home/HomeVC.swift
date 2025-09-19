//
//  HomeVC.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 30.08.24.
//

import UIKit

protocol HomeViewModelProtocol {
    func viewWillAppear()
    func makeCollectionView() -> UICollectionView
    func settingButtonDidTap()
    func askExpertButtonDidTap()
}

final class HomeVC: UIViewController {
    
    private enum Constants {
        
        // MARK: - Text
        static let titleText: String = "Let’s solve\nyour task"
        static let tabBarItemText: String = "Home"
        
        //MARK: - Constrains
        static let tabBarHeight: CGFloat = 88.0
        static let settingButtonSide: CGFloat = 56.0
        static let settingRadius: CGFloat = Constants.settingButtonSide / 2
        static let askButtonHeight: CGFloat = 64
        static let askButtonWidth: CGFloat = 175
        static let askButtonRadius: CGFloat = askButtonHeight / 2
        
    }
    
    private var viewModel: HomeViewModelProtocol
    
    private lazy var collectionView: UICollectionView =
    viewModel.makeCollectionView()
    
    private lazy var titleLabel: UILabel =
        .homeTitleLabel(Constants.titleText, size: 28.0)
    
    private lazy var contentView: UIView = .contentView()
    private lazy var assistantImageView: UIImageView =
    UIImageView(image: .MainApp.Home.assistantImage)
    
    private lazy var settingButton: UIButton =
        .settingButton()
        .addAction(self, action: #selector(settingButtonDidTap))
    private lazy var askExpertButton: UIButton =
        .actionButton(title: "Ask an Expert")
        .addAction(self, action: #selector(askExpertButtonDidTap))
    
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setupTabBarItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - View Controller Life Cycle
extension HomeVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAssistantView()
        setupConstrains()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
}

//MARK: - TabBar Item Setup
extension HomeVC {
    
    private func setupTabBarItem() {
        self.tabBarItem = UITabBarItem(title: Constants.tabBarItemText,
                                       image: .MainApp.TabBar.homeImage,
                                       tag: .zero)
        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 10,
                                                      vertical: -5.0)
        let attributes = [NSAttributedString.Key.font: UIFont.semiBold(size: 10)]
        tabBarItem.setTitleTextAttributes(attributes, for: .normal)
    }
    
}

//MARK: - Setup UI
extension HomeVC {
    
    private func setupUI() {
        view.backgroundColor = .appBg
        view.addSubview(contentView)
        
        contentView.addSubview(collectionView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(settingButton)
        settingButton.cornerRadius = Constants.settingRadius
        contentView.addSubview(assistantImageView)
    }
    
}

//MARK: - Constrains Setup
extension HomeVC {
    
    private func setupConstrains() {
        contentView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(Constants.tabBarHeight)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(16.0)
            make.top.equalTo(58.0)
        }
        
        settingButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(58.0)
            make.right.equalToSuperview().inset(16.0)
            make.size.equalTo(Constants.settingButtonSide)
        }
        
        assistantImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(28.0)
            make.horizontalEdges.equalToSuperview().inset(16.0)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(assistantImageView.snp.bottom).inset(-10.0)
            make.bottom.equalToSuperview().inset(14.0)
            make.horizontalEdges.equalToSuperview().inset(16.0)
        }
    }
    
}

//MARK: - Setup Assistant View
extension HomeVC {
    
    private func setupAssistantView() {
        assistantImageView.addSubview(askExpertButton)
        askExpertButton.cornerRadius = Constants.askButtonRadius
        assistantImageView.isUserInteractionEnabled = true
        //Constrains Setup
        askExpertButton.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.height.equalTo(Constants.askButtonHeight)
            make.right.equalTo(assistantImageView.snp.centerX)
        }
    }
    
}

//MARK: - Buttons Actions
extension HomeVC {
    
    @objc private func settingButtonDidTap(_ sender: UIButton) {
        viewModel.settingButtonDidTap()
    }
    
    @objc private func askExpertButtonDidTap(_ sender: UIButton) {
        viewModel.askExpertButtonDidTap()
    }
    
}

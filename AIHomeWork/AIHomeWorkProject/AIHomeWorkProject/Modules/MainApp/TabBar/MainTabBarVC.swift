//
//  MainTabBarVC.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 30.08.24.
//

import UIKit
import SnapKit

@objc protocol MainTabBarViewModelProtocol {
    @objc func cameraButtonDidTap()
}

final class MainTabBarVC: UITabBarController {
    
    private enum Constants {
        static let tabBarHeight: CGFloat = 88.0
        static let scanButtonSide: CGFloat = 50.0
        static let scanButtonCornerRadius =  Constants.scanButtonSide / 2
    }
    
    private lazy var scanButton: UIButton =
        .scanButton()
        .addAction(self, action: #selector(cameraButtonDidTap))
    
    private var viewModel: MainTabBarViewModelProtocol
    
    init(viewModel: MainTabBarViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - TabBar Controller Life cycle
extension MainTabBarVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstrains()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.tabBar.itemPositioning = .fill
        self.tabBar.frame.size.height = Constants.tabBarHeight
        self.tabBar.frame.origin.y = view.frame.height - Constants.tabBarHeight
    }
    
}

//MARK: - Setup UI
extension MainTabBarVC {
    
    private func setupUI() {
        tabBar.tintColor = .appBlack
        tabBar.backgroundColor = .appBg
        tabBar.unselectedItemTintColor = .TabBar.unselectedItemColor
   
        tabBar.addSubview(scanButton)
        scanButton.cornerRadius =  Constants.scanButtonCornerRadius
    }
    
}

//MARK: - Constrains Setup
extension MainTabBarVC {
    
    private func setupConstrains() {
        scanButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(2.0)
            make.size.equalTo(Constants.scanButtonSide)
        }
    }
    
}

//MARK: - Button Action
extension MainTabBarVC {
    
    @objc func cameraButtonDidTap() {
        viewModel.cameraButtonDidTap()
    }
    
}

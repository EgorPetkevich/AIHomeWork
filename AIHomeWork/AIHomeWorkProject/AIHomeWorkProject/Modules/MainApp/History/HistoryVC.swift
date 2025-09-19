//
//  HistoryVC.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 30.08.24.
//

import UIKit
import SnapKit

protocol HistoryViewModelProtocol {
    var showActionView: ((Bool) -> Void)? { get set }
    
    func viewDidLoad()
    func viewWillAppear()
    func solveTaskButtonDidTap()
    func makeTableView() -> UITableView
}

final class HistoryVC: UIViewController {
    
    private enum Constants {
        
        // MARK: - Text
        static let tabBarItemText: String = "History"
        static let headerTitleText: String = "Solved tasks"
        static let titleText: String = "Nothing here yet"
        static let subTitleText: String = "Scan your task using the camera or\ninput text manually."
        static let solveTaskButtonText: String = "Solve task"
        
        //MARK: - Constrains
        static let solveButtonSize: CGSize = CGSize(width: 200.0, height: 64.0)
        static let solveButtonCornerRadius: CGFloat = 32.0
    }
    
    private var viewModel: HistoryViewModelProtocol
    
    private lazy var actionView: UIView = .contentView()
    private lazy var headerTitleLabel: UILabel =
        .titleLabel(Constants.headerTitleText, size: 20)
    private lazy var titleLabel: UILabel =
        .semiBoldTitleLabel(Constants.titleText, size: 20.0)
    private lazy var subTitleLabal: UILabel =
        .subTitleLabel(Constants.subTitleText, size: 12)
    
    private lazy var tableView: UITableView = viewModel.makeTableView()
    
    private lazy var solveTaskButton: UIButton =
        .actionButton(title: Constants.solveTaskButtonText)
        .addAction(self, action: #selector(solveTaskButtonDidTap))
    
    private lazy var professorImageView: UIImageView =
    UIImageView(image: .MainApp.History.professorImage)
    
    
    init(viewModel: HistoryViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
        setupTabBarItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Bind View Model
extension HistoryVC {
    
    private func bindViewModel() {
        viewModel.showActionView = { [weak self] showActionView in
            if showActionView {
                self?.actionView.isHidden = false
                self?.tableView.isHidden = true
            } else {
                self?.actionView.isHidden = true
                self?.tableView.isHidden = false
            }
        }
    }
    
}

//MARK: - View Controller Life cycle
extension HistoryVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        setupUI()
        setupConstrains()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
}

//MARK: - TabBar Item Setup
extension HistoryVC {
    
    private func setupTabBarItem() {
        self.tabBarItem = UITabBarItem(title: Constants.tabBarItemText,
                                       image: .MainApp.TabBar.historyImage,
                                       tag: .zero)
        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: -10,
                                                      vertical: -5.0)
        let attributes = [NSAttributedString.Key.font: UIFont.semiBold(size: 10)]
        tabBarItem.setTitleTextAttributes(attributes, for: .normal)
    }
}

//MARK: - Setup UI
extension HistoryVC {
    
    private func setupUI() {
        view.backgroundColor = .appBg
        view.addSubview(headerTitleLabel)
        view.addSubview(actionView)
        view.addSubview(tableView)
        
        actionView.addSubview(professorImageView)
        actionView.addSubview(titleLabel)
        actionView.addSubview(subTitleLabal)
        actionView.addSubview(solveTaskButton)
        solveTaskButton.layer.masksToBounds = true
        solveTaskButton.cornerRadius = Constants.solveButtonCornerRadius
    }
    
}

//MARK: - Constrains Setup
extension HistoryVC {
    
    private func setupConstrains() {
        headerTitleLabel.snp.makeConstraints  { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(57.0)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(3.0)
        }
        
        actionView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        professorImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(professorImageView.snp.bottom).inset(-21.0)
            make.centerX.equalToSuperview()
        }
        
        subTitleLabal.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-8.0)
            make.centerX.equalToSuperview()
        }
        
        solveTaskButton.snp.makeConstraints { make in
            make.size.equalTo(Constants.solveButtonSize)
            make.top.equalTo(subTitleLabal.snp.bottom).inset(-24)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerTitleLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(88.0)
        }
        
    }
    
}

//MARK: - Button Actions
extension HistoryVC {
    
    @objc private func solveTaskButtonDidTap(_ sender: UIButton) {
        viewModel.solveTaskButtonDidTap()
    }
    
}

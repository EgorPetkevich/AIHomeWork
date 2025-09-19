//
//  PaywallTrialSwitch.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 28.08.24.
//

import UIKit
import SnapKit

final class PaywallTrialSwitch: UIView {
    
    private enum Constants {
        static let height: CGFloat = 64.0
        static let cornerRadius: CGFloat = Constants.height / 2
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "I want my Free Trial."
        label.font = .regularFont(size: 11.0)
        label.textColor = .appWhite
        return label
    }()
    
    private lazy var switchView: UISwitch = {
        let switchView = UISwitch()
        switchView.addTarget(target, action: action, for: .valueChanged)
        return switchView
    }()
    
    private var target: Any?
    private var action: Selector
    
    init(target: Any?, action: Selector) {
        self.target = target
        self.action = action
        super.init(frame: .zero)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isOn: Bool {
        get { switchView.isOn }
        set { switchView.isOn = newValue}
    }
    
    private func commonInit() {
        setupUI()
        setupConstrains()
    }
    
    private func setupUI() {
        self.backgroundColor = .appBlack
        self.cornerRadius = Constants.cornerRadius
        addSubview(titleLabel)
        addSubview(switchView)
        
        switchView.onTintColor = .PaywallTrialSwitch.OnTintColor
        switchView.backgroundColor = .PaywallTrialSwitch.tintColor
        switchView.cornerRadius = switchView.bounds.height / 2
    }
    
    private func setupConstrains() {
        self.snp.makeConstraints { make in
            make.height.equalTo(Constants.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24.0)
            make.centerY.equalToSuperview()
        }
        
        switchView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(14.0)
            make.centerY.equalToSuperview()
        }
    }
    
}

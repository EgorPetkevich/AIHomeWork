//
//  ScanButton.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 4.09.24.
//

import UIKit
import SnapKit

final class ScanButton: UIView {
    
    private enum Constants {
        
        //MARK: - Text
        static var separatorText = "Or"
        static var scanButtonText = "Scan"
        
        //MARK: - Constains
        static let buttonHeight: CGFloat = 64.0
        static let widthHeight: CGFloat = 200.0
        static let scanButtonSize: CGSize = CGSize(width: widthHeight,
                                                   height: buttonHeight)
        static let titleFontSize: CGFloat = 13.0
        static let buttonCornerRadius: CGFloat = Constants.buttonHeight / 2
    }
    
    private let target: Any?
    private let action: Selector
    
    private lazy var scanButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.background.backgroundColor = .appBlack
        configuration.image = .AppIcon.scannerImage
        configuration.baseForegroundColor = .appWhite
        configuration.title = Constants.scanButtonText
        configuration.imagePadding = 8
        configuration.attributedTitle?.font = .regularFont(size: 13.0)
        let button = UIButton(configuration: configuration)
            .addAction(target, action: action)
        button.titleLabel?.font = .regularFont(size: 13.0)
        return button
    }()
    
    private lazy var separatorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appGrey
        label.text = Constants.separatorText
        label.font = .regularFont(size: 13.0)
        return label
    }()
    
    private lazy var leftSeparatorView: UIView =  {
        let view = UIView()
        view.backgroundColor = .appGrey
        return view
    }()
    
    private lazy var rightSeparatorView: UIView =  {
        let view = UIView()
        view.backgroundColor = .appGrey
        return view
    }()
    
    private lazy var activityCirculeView: UIView = {
        let view = UIView()
        view.backgroundColor = .appWhite
        return view
    }()
    
    init(target: Any?,
         action: Selector) {
        self.target = target
        self.action = action
        super.init(frame: .zero)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI Setup
extension ScanButton {
    
    private func setupUI() {
        self.backgroundColor = .clear
        self.addSubview(separatorLabel)
        self.addSubview(leftSeparatorView)
        self.addSubview(rightSeparatorView)
        self.addSubview(scanButton)
        scanButton.layer.masksToBounds = true
        scanButton.cornerRadius = Constants.buttonCornerRadius
    }
    
}

// MARK: - Constraints Setup
extension ScanButton {
    
    private func setupConstraints() {
        separatorLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        leftSeparatorView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalTo(separatorLabel.snp.centerY)
            make.height.equalTo(0.5)
            make.right.equalTo(separatorLabel.snp.left).inset(-16.0)
        }
        
        rightSeparatorView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalTo(separatorLabel.snp.centerY)
            make.height.equalTo(0.5)
            make.left.equalTo(separatorLabel.snp.right).offset(16.0)
        }
        
        scanButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(Constants.scanButtonSize)
            make.top.equalTo(separatorLabel.snp.bottom).inset(-32.0)
        }
        
    }
    
}


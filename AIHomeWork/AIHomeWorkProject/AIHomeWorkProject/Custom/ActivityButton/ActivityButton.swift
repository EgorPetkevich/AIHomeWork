//
//  ActivityButton.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 25.08.24.
//

import UIKit
import SnapKit

final class ActivityButton: UIView {
    
    private enum Constants {
        static let height: CGFloat = 64.0
        static let circuleHeight: CGFloat = 53.0
        static let titleFontSize: CGFloat = 13.0
        static let titleFontWeight: UIFont.Weight = UIFont.Weight(410)
        static let cornerRadius: CGFloat = Constants.height / 2
        static let circuleCornerRadius: CGFloat = Constants.circuleHeight / 2
    }
    
    private let target: Any?
    private let action: Selector
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.addAction(target, action: action)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appWhite
        return label
    }()
    
    private lazy var activityCirculeView: UIView = {
        let view = UIView()
        view.backgroundColor = .appWhite
        return view
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView(image: .ActivityButton.arrowImage)
        imageView.tintColor = .appBlack
        imageView.backgroundColor = .appWhite
        return imageView
    }()
    
    
    lazy var activityIndicator: CircularSpinnerView = {
        
        let indicator = CircularSpinnerView()
        
        return indicator
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

// MARK: - Properties
extension ActivityButton {
    
    var setTitle: String {
        get { titleLabel.text ?? "" }
        set {
            titleLabel.font = .regularFont(size: 13.0)
            titleLabel.text = newValue
        }
    }
    
    var setPaywallRevTitle: String {
        get { titleLabel.text ?? "" }
        set {
            titleLabel.font = .regularFont(size: 10.0)
            titleLabel.text = newValue
        }
    }
    
    var buttonisEnabled: Bool {
        get { button.isEnabled }
        set { button.isEnabled = newValue }
    }
    
    var isArrowImageViewHidden: Bool {
        get { arrowImageView.isHidden }
        set { arrowImageView.isHidden = newValue }
    }
    
}

// MARK: - UI Setup
extension ActivityButton {
    
    private func setupUI() {
        self.backgroundColor = .appActive
        self.cornerRadius = Constants.cornerRadius
        
        addSubview(titleLabel)
        addSubview(activityCirculeView)
        
        activityCirculeView.addSubview(arrowImageView)
        activityCirculeView.addSubview(activityIndicator)
        activityCirculeView.cornerRadius = Constants.circuleCornerRadius
        addSubview(button)
    }
    
}

// MARK: - Constraints Setup
extension ActivityButton {
    
    private func setupConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(Constants.height)
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        activityCirculeView.snp.makeConstraints { make in
            make.size.equalTo(Constants.circuleHeight)
            make.right.equalToSuperview().inset(5.5)
            make.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}

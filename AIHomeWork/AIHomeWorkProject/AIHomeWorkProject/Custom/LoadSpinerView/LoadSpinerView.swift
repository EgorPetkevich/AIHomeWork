//
//  LoadSpinerView.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 11.09.24.
//

import UIKit

final class LoadSpinerView: UIView {
    
    private var titleText: String
    private var subTitleText: String
    
    private lazy var spinerView: CustomSpinerView = CustomSpinerView().start()
    
    private lazy var titleLabel: UILabel = .titleLabel(titleText, size: 20.0)
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = subTitleText
        label.font = .systemFont(ofSize: 15.0,
                                 weight: .light,
                                 width: .expanded)
        label.numberOfLines = 3
        label.textAlignment = .center
        label.textColor = .appLightGrey
        return label
    }()
    
    init(titleText: String, subTitleText: String) {
        self.titleText = titleText
        self.subTitleText = subTitleText
        super.init(frame: .zero)
        setupUI()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - UI Setup
extension LoadSpinerView {
    
    private func setupUI() {
        self.backgroundColor = .appBg
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        self.addSubview(spinerView)
        
    }
    
}

//MARK: - Constrains Setup
extension LoadSpinerView {
    
    private func setupConstrains() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(19.0)
        }
        
        spinerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(spinerView.snp.bottom).inset(-104.0)
        }
    }
    
}

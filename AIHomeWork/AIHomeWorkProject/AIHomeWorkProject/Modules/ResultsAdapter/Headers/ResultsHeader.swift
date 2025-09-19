//
//  ResultsHeader.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 11.09.24.
//

import UIKit
import SnapKit

protocol ResultsHeaderProtocol {
    var titleHeader: String { get }
    var iconImage: UIImage { get }
    var backgroundColor: UIColor { get }
}

final class ResultsHeader: UIView {
    
    private lazy var headerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16.0,
                                 weight: .medium,
                                 width: .expanded)
        return label
    }()
    
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var text: String? {
        get { titleLabel.text}
        set { titleLabel.text = newValue }
    }
    
    var icon: UIImage? {
        get { iconView.image }
        set { iconView.image = newValue }
    }
    
    var headerViewColor: UIColor? {
        get { headerView.backgroundColor }
        set { headerView.backgroundColor = newValue }
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(iconView)
        headerView.cornerRadius = 18.0
    }
    
    private func setupConstrains() {
        headerView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalTo(36.0)
            make.top.bottom.equalToSuperview().inset(10.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(8.0)
            make.left.equalToSuperview().inset(38.0)
        }
        
        iconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(10.0)
        }
    }
    
}


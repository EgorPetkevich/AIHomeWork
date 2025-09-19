//
//  SettingsCell.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 2.09.24.
//

import UIKit
import SnapKit

protocol SettingsCellSetupProtocol {
    var title: String { get }
    var icon: UIImage { get }
}

final class SettingsCell: UITableViewCell {
    
    private enum Constants {
        static var iconHeight: CGFloat = 32.0
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .regularFont(size: 15.0)
        label.textColor = .appBlack
        return label
    }()
    
    private lazy var iconImage: UIImageView = UIImageView()
    private lazy var arrowImageView = UIImageView(image: .AppIcon.rightArrowImage)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        setupSelectedBackgroundView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setup(_ item: SettingsCellSetupProtocol) {
        titleLabel.text = item.title
        iconImage.image = item.icon
    }
    
    func setupUI() {
        contentView.backgroundColor = .appWhite
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconImage)
        contentView.addSubview(arrowImageView)
    }
    
    private func setupSelectedBackgroundView() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = .appActiveSelect
        selectedBackgroundView = bgColorView
        
        selectedBackgroundView?.layer.masksToBounds = true
        selectedBackgroundView?.layer.zPosition =
        CGFloat(Float.greatestFiniteMagnitude)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectedBackgroundView?.center.y = contentView.center.y
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImage.snp.right).offset(8.0)
        }
        
        iconImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(Constants.iconHeight)
            make.left.equalToSuperview().inset(16.0)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16.0)
        }
    }
    
    
}

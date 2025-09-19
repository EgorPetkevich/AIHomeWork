//
//  ChatsHistoryCell.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 17.09.24.
//

import UIKit
import Storage
import SnapKit

final class ChatsHistoryCell: UITableViewCell {
    
    private lazy var contentCellView: UIView = {
        let view = UIView()
        view.backgroundColor = .appDarkGray
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20.0, weight: .bold,
                                 width: .expanded)
        label.textColor = .appBlack
        return label
    }()
    
    private lazy var firstLetterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appWhite
        label.font = .systemFont(ofSize: 25.0, weight: .bold)
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .regularFont(size: 15.0)
        label.textColor = .appMessageBlack
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var iconView: UIView = {
        let view = UIView()
        view.backgroundColor = .appBlack
        return view
    }()
    
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
    
    func setup(dto: ConversationDTO) {
        titleLabel.text = dto.name
        if let firstLetter = dto.name.first {
            firstLetterLabel.text = String(firstLetter)
        }
        messageLabel.text = dto.chat.last?.message
    }
    
    func setupUI() {
        self.backgroundColor = .clear
        self.addSubview(contentCellView)
        contentCellView.addSubview(iconView)
        iconView.addSubview(firstLetterLabel)
        contentCellView.addSubview(titleLabel)
        contentCellView.addSubview(arrowImageView)
        contentCellView.addSubview(messageLabel)
        contentCellView.cornerRadius = 24.0
        iconView.layer.masksToBounds = true
        iconView.cornerRadius = 8.0
    }
    
    private func setupSelectedBackgroundView() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = .appLightGrey
        bgColorView.cornerRadius = 24.0
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
        self.contentView.snp.makeConstraints { make in
            make.height.equalTo(120)
        }
        
        contentCellView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4.0)
            make.horizontalEdges.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(16.0)
            make.size.equalTo(44.0)
        }
        
        firstLetterLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16.0)
            make.left.equalTo(iconView.snp.right).offset(10.0)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16.0)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(10.0)
            make.right.equalToSuperview().inset(40.0)
            make.top.equalTo(titleLabel.snp.bottom).inset(-8.0)
            make.bottom.equalToSuperview().inset(16.0)
        }
    }
    
    
}

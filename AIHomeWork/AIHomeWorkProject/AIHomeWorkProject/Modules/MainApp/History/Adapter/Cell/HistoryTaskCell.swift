//
//  HistoryTaskCell.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 14.09.24.
//

import UIKit
import Storage
import SnapKit

final class HistoryTaskCell: UITableViewCell {
    
    private lazy var contentCellView: UIView = {
        let view = UIView()
        view.backgroundColor = .appWhite
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18.0, weight: .bold,
                                 width: .expanded)
        label.textColor = .appBlack
        return label
    }()
    
    private lazy var taskLabel: UILabel = {
        let label = UILabel()
        label.text = "Task:"
        label.font = .systemFont(ofSize: 12.0,
                                 weight: .light,
                                 width: .expanded)
        label.textColor = .appBlack
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .regularFont(size: 15.0)
        label.textColor = .appMessageBlack
        label.numberOfLines = 3
        return label
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
    
    func setup(dto: TaskDTO) {
        titleLabel.text = dto.name
        messageLabel.text = dto.chat.first?.message
    }
    
    func setupUI() {
        self.backgroundColor = .clear
        self.addSubview(contentCellView)
        contentCellView.addSubview(titleLabel)
        contentCellView.addSubview(arrowImageView)
        contentCellView.addSubview(taskLabel)
        contentCellView.addSubview(messageLabel)
        contentCellView.cornerRadius = 24.0
        contentCellView.setShadow()
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
            make.height.equalTo(110)
        }
        
        contentCellView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4.0)
            make.horizontalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10.0)
            make.left.equalToSuperview().inset(15.0)
        }
        
        taskLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-6.0)
            make.left.equalToSuperview().inset(15.0)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16.0)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15.0)
            make.right.equalToSuperview().inset(40.0)
            make.top.equalTo(taskLabel.snp.bottom).inset(-4.0)
            make.bottom.equalToSuperview().inset(10.0)
        }
    }
    
    
}

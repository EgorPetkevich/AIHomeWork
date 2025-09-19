//
//  ResultsMenuCell.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 10.09.24.
//

import UIKit

protocol ResultsMenuItem {
    var title: String { get }
    var icon: UIImage { get }
    var tintColor: UIColor { get }
}

final class ResultsMenuCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .appBlack
        label.font = .systemFont(ofSize: 17.0, weight: .regular)
        return label
    }()
    
    private lazy var iconImageView: UIImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setup(_ item: ResultsMenuItem) {
        titleLabel.text = item.title
        iconImageView.image = item.icon
        titleLabel.textColor = item.tintColor
        iconImageView.tintColor = item.tintColor
    }
    
    func setupUI() {
        self.backgroundColor = .appWhite
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconImageView)
    }
    
    private func setupConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16.0)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16.0)
            make.centerY.equalToSuperview()
        }
    }
    
}

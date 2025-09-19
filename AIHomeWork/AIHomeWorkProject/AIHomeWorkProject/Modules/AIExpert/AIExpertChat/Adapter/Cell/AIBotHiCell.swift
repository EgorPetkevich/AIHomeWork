//
//  AIBotHiCell.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 24.09.24.
//

import UIKit
import SnapKit

final class AIBotHiCell: UITableViewCell {
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .AIExpertChat.professorImage
        return imageView
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.textColor = .appBlack
        textView.font = .regularFont(size: 15.0)
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.backgroundColor = .appDarkGray
        return textView
    }()
        
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = true
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setup(text: String) {
        textView.text = text
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        addSubview(textView)
        addSubview(iconImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textView.roundCornersExeptBottomLeft(cornerRadius: 16.0)
    }
    
    private func setupConstraints() {
        textView.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(8.0)
            make.width.equalTo(self.snp.width).inset(24.0)
            make.verticalEdges.equalToSuperview().inset(8)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(8.0)
            make.size.equalTo(32.0)
        }
    }
    
}


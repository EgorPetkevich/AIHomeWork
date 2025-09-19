//
//  AIBotCell.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 12.09.24.
//

import UIKit
import SnapKit

final class AIBotCell: UITableViewCell {
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .AIExpertChat.professorImage
        return imageView
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.textColor = .appBlack
        textView.font = .regularFont(size: 15.0)
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 70, right: 16)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.backgroundColor = .appDarkGray
        return textView
    }()
    
    private lazy var copieButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.AppIcon.copieImage, for: .normal)
        button.tintColor = .appBlack
        button.addAction(self, action: #selector(copieButtonDidTap))
        return button
        
    }()
    
    private lazy var copieView: UIView = {
        let view = UIView()
        view.backgroundColor = .appBg
        return view
    }()
    
    private lazy var copiedTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Copied text"
        label.textColor = .appBlack
        label.font = .systemFont(ofSize: 15.0,
                                 weight: .medium,
                                 width: .expanded)
        return label
    }()
    
    private lazy var copiedIcon = UIImageView(image: .AppIcon.solutionImage)
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = true
        setupUI()
        setupConstraints()
        setupCopiedButton()
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
    
    private func setupCopiedButton() {
        self.addSubview(copieButton)
        copieButton.layer.zPosition = .greatestFiniteMagnitude
        copieButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(26.0)
            make.right.equalTo(textView.snp.right).inset(15.0)
        }
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
    
    private func setupCopiedView() {
        self.addSubview(copieView)
        copieView.addSubview(copiedTextLabel)
        copieView.addSubview(copiedIcon)
        copieView.layer.zPosition = .greatestFiniteMagnitude
        copieView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(13.0)
            make.height.equalTo(48.0)
            make.width.equalTo(207.0)
            make.centerX.equalTo(textView.snp.centerX)
        }
        copieView.cornerRadius = 24.0
        copiedTextLabel.snp.makeConstraints { make in
            make.left.equalTo(copiedIcon.snp.right).offset(4.0)
            make.centerY.equalToSuperview()
        }
        copiedIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(22.0)
            make.left.equalToSuperview().inset(32.0)
        }
        
    }
    
    @objc private func copieButtonDidTap(){
         UIPasteboard.general.string = textView.text
         
         setupCopiedView()
         
         DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
             self?.copieView.removeFromSuperview()
         }
    }
    
    
}


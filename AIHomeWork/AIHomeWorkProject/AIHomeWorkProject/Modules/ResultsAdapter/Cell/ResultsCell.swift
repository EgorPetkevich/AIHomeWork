//
//  ResultsCell.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 11.09.24.
//

import UIKit
import SnapKit

protocol ResultsCellProtocol {
    var backgroundColor: UIColor { get }
    var showCopieButton: Bool { get }
}

final class ResultsCell: UITableViewCell {
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.textColor = .appBlack
        textView.font = .regularFont(size: 15.0)
        
        textView.isScrollEnabled = false 
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
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
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setup(_ sender: ResultsCellProtocol, text: String) {
        textView.text = text
        textView.backgroundColor = sender.backgroundColor
        if sender.showCopieButton {
            setupCopiedButton()
            textView.textContainerInset =
            UIEdgeInsets(top: 16, left: 16, bottom: 70, right: 16)
        }
    }
    
    private func setupCopiedButton() {
        self.addSubview(copieButton)
        copieButton.layer.zPosition = .greatestFiniteMagnitude
        copieButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(18.0)
            make.right.equalToSuperview().inset(25.0)
        }
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        addSubview(textView)
        textView.cornerRadius = 24.0
    }
    
    private func setupConstraints() {
        textView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview()
        }
    }
    
    private func setupCopiedView() {
        self.addSubview(copieView)
        copieView.addSubview(copiedTextLabel)
        copieView.addSubview(copiedIcon)
        copieView.layer.zPosition = .greatestFiniteMagnitude
        copieView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(5.0)
            make.height.equalTo(48.0)
            make.width.equalTo(207.0)
            make.centerX.equalToSuperview()
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



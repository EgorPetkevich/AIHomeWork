//
//  QuestionCell.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 25.09.24.
//

import UIKit
import SnapKit

final class QuestionResultCell: UITableViewCell {
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.textColor = .appBlack
        textView.font = .regularFont(size: 15.0)
        textView.textContainerInset =
        UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
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
    
    func setup(_ sender: ResultsCellProtocol, text: String) {
        textView.text = text
        textView.backgroundColor = sender.backgroundColor
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
    
}


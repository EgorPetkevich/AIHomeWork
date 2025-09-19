//
//  UserCell.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 12.09.24.
//

import UIKit
import SnapKit

final class UserCell: UITableViewCell {
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.textColor = .appWhite
        textView.font = .regularFont(size: 15.0)
        textView.textContainerInset =
        UIEdgeInsets(top: 16, left: 16, bottom: 20, right: 16)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.backgroundColor = .appActive
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textView.roundCornersExeptBottomRight(cornerRadius: 16.0)
    }
    
    private func setupConstraints() {
        textView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(8.0)
            make.width.lessThanOrEqualTo(self.snp.width)
        }
    }
    
}



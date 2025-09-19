//
//  QuestionCell.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 16.09.24.
//

import UIKit
import SnapKit

final class QuestionCell: UITableViewCell {
    
    private lazy var taskTitle: UILabel = {
        let label = UILabel()
        label.text = "Task"
        label.font = .systemFont(ofSize: 14.0,
                                 weight: .semibold,
                                 width: .expanded)
        label.textColor = .appActive
        return label
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.textColor = .appBlack
        textView.font = .regularFont(size: 15.0)
//        textView.textContainerInset =
//        UIEdgeInsets(top: 16, left: 16, bottom: 20, right: 16)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.backgroundColor = .clear
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
    
    func setup(_ message: String) {
        textView.text = message
        
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        addSubview(taskTitle)
        addSubview(textView)
    }
    
    private func setupConstraints() {
        taskTitle.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        textView.snp.makeConstraints { make in
            make.top.equalTo(taskTitle.snp.bottom).inset(-4.0)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(16.0)
        }
    }
    
}

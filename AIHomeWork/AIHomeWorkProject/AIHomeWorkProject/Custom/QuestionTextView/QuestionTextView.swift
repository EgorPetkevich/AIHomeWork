//
//  QuestionTextView.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 4.09.24.
//

import UIKit
import SnapKit

final class QuestionTextView: UIView {
    
    private enum Constants {
        
        //MARK: - Text
        static var typeLabelText = "Type"
        static var placeholder = "Type task or description"
        
        //MARK: - Constrains
        static var characterCountLimit = 500
        static var textViewHeight: CGFloat = 200.0
        static var textViewMaxHeight: CGFloat = 400.0
        static var textViewCornerRadius: CGFloat = 24

    }
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.typeLabelText
        label.textColor = .appBlack
        label.font = .systemFont(ofSize: 16.0, weight: .medium, width: .expanded)
        return label
    }()
    
    private lazy var symbolCountLabel: UILabel = {
        let label = UILabel()
        label.text = "\(0)/"+"\(Constants.characterCountLimit)"
        label.textColor = .appGrey
        label.font = .regularFont(size: 12.0)
        return label
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = Constants.placeholder
        textView.textColor = .appGrey
        textView.backgroundColor = .appDarkGray
        textView.font = .regularFont(size: 14.0)
        textView.returnKeyType = .go
        textView.textContainerInset =
        UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textView.textContainer.lineFragmentPadding = 10
        return textView
    }()
    
    init() {
        super.init(frame: .zero)
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(handleTextViewDidChange(_:)),
                         name: UITextView.textDidChangeNotification,
                         object: nil)
        commonInit()
    }
    
    deinit {
        NotificationCenter
            .default
            .removeObserver(self,
                            name: UITextView.textDidChangeNotification,
                            object: nil)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        textView.delegate = self
        setupUI()
        setupConstrains()
    }
    
}

// MARK: - Properties
extension QuestionTextView {
    
    var textViewIsEmpty: Bool {
        get { textView.text.isEmpty }
        set {
            if newValue {
                textView.text = Constants.placeholder
                textView.textColor = .appGrey
            }
        }
    }
    
    var symbolCountLabelIsHiden: Bool {
        get { symbolCountLabel.isHidden }
        set { 
            if newValue && textView.text.isEmpty {
                symbolCountLabel.isHidden = !newValue
            } else {
                symbolCountLabel.isHidden = newValue}
        }
    }
    
    var textViewText: String {
        get { textView.text }
    }
    
    func setText(_ text: String) {
        textView.text = text
        textView.textColor = .appBlack
        updateCharacterCount()
    }
    
}

//MARK: - UI Setup
extension QuestionTextView {
    
    private func setupUI() {
        self.backgroundColor = .clear
        self.addSubview(typeLabel)
        self.addSubview(symbolCountLabel)
        symbolCountLabel.layer.zPosition = .greatestFiniteMagnitude
        self.addSubview(textView)
        textView.cornerRadius = Constants.textViewCornerRadius
    }
    
}

//MARK: - Constrains Setup
extension QuestionTextView {
    
    private func setupConstrains() {
        typeLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
        }
        textView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(Constants.textViewHeight)
            make.top.equalTo(typeLabel.snp.bottom).inset(-8.0)
        }
        symbolCountLabel.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview().inset(16.0)
        }
    }
    
}

//MARK: - TextView Did Change Content Handler
extension QuestionTextView {
    
    @objc func handleTextViewDidChange(_ notification: Notification) {
        let currentTextWithoutNewlines =
        textView.text.replacingOccurrences(of: "\n", with: "")
        symbolCountLabel.text =
        "\(currentTextWithoutNewlines.count)/\(Constants.characterCountLimit)"
    }
    
}

//MARK: - TextView Halpers
extension QuestionTextView {
    
    private func updateCharacterCount() {
        let currentTextWithoutNewlines =
        textView.text.replacingOccurrences(of: "\n", with: "")
        symbolCountLabel.text =
        "\(currentTextWithoutNewlines.count)/\(Constants.characterCountLimit)"
    }
    
    func hideKeybord() {
        textView.resignFirstResponder()
    }
    
}

extension QuestionTextView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .appGrey {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let currentTextWithoutNewlines =
        textView.text.replacingOccurrences(of: "\n", with: "")
        if currentTextWithoutNewlines.isEmpty {
            textView.text = Constants.placeholder
            textView.textColor = .appGrey
            textView.text = Constants.placeholder
        }
    }

    
    func textView(_ textView: UITextView,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let characterCountLimit = Constants.characterCountLimit
        let startingLength = textView.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace = range.length
        
        let newLength = startingLength + lengthToAdd - lengthToReplace
        symbolCountLabel.text = 
        "\(textView.text.count)/"+"\(Constants.characterCountLimit)"
        return newLength <= characterCountLimit
    }
    
    func textView(_ textView: UITextView, 
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        let newText =
        (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if text == "\n" { hideKeybord() }
        
        let newTextWithoutNewlines =
        newText.replacingOccurrences(of: "\n", with: "")
        let newLength = newTextWithoutNewlines.count
        
        if newLength <= Constants.characterCountLimit {
            return true
        } else {
            let allowedLength = 
            Constants.characterCountLimit - (
                currentText.replacingOccurrences(of: "\n", with: "").count)
            if allowedLength > 0 {
                let trimmedText = text.prefix(allowedLength)
                let finalText = 
                (currentText as NSString)
                    .replacingCharacters(in: range, with: String(trimmedText))
                textView.text = finalText
                updateCharacterCount()
            }
            return false
        }
    }
    
}

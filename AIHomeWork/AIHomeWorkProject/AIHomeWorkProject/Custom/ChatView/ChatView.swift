//
//  ChatView.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 12.09.24.
//

import UIKit
import SnapKit

final class ChatView: UIView {
    
    private enum Constants {
        
        //MARK: - Text
        static var placeholder = "Type here"
        
        //MARK: - Constrains
        static var characterCountLimit = 500
        static var textViewHeight: CGFloat = 44.0
        static var textViewMaxHeight: CGFloat = 200.0
        static var textViewCornerRadius: CGFloat = textViewHeight / 2
        static var sendButtonHeight: CGFloat = 44.0
        static var sendButtonCornerRadius = sendButtonHeight / 2
        
    }
    
    var allowSendind: Bool = true {
        willSet {
            allowImagePicking = newValue
        }
    }
    
    var allowImageSending: Bool = false {
        willSet {
            sendButton.isEnabled = newValue
            if newValue {
                sendButton.tintColor = .appWhite
                sendButton.backgroundColor = .appActive
            } else {
                sendButton.tintColor = .appWhite
                sendButton.backgroundColor = .appActiveDisable
            }
        }
    }
    
    var allowImagePicking: Bool = true {
        willSet {
            galleryButton.isEnabled = newValue
        }
    }
    
    var allowTextViewEditing: Bool = true {
        willSet {
            textView.isEditable = newValue
            if !newValue {
                textView.text = nil
            } else {
                textView.text = Constants.placeholder
                textView.textColor = .appGrey
            }
        }
    }
    
    
    private let target: Any?
    private let sendAction: Selector
    private let openGalleryAction: Selector
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = Constants.placeholder
        textView.textColor = .appGrey
        textView.backgroundColor = .appDarkGray
        textView.font = .regularFont(size: 14.0)
        textView.returnKeyType = .go
        textView.textContainerInset =
        UIEdgeInsets(top: 15, left: 12, bottom: 13, right: 12)
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        return textView
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .appActive
        button.setImage(.AppIcon.arrowUpImage, for: .normal)
        button.tintColor = .appWhite
        button.addAction(target, action: sendAction)
        return button
    }()
    
    private lazy var galleryButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setImage(.AppIcon.galeryImage, for: .normal)
        button.tintColor = .appBlack
        button.addAction(target, action: openGalleryAction)
        return button
    }()
    
    init(target: Any?, sendAction: Selector, openGalleryAction: Selector) {
        self.target = target
        self.sendAction = sendAction
        self.openGalleryAction = openGalleryAction
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        textView.delegate = self
        setupUI()
        setupConstrains()
        updateSendButtonState()
    }
    
}

// MARK: - Properties
extension ChatView {
    
    var textViewIsEmpty: Bool {
        get { textView.text.isEmpty }
        set {
            if newValue {
                textView.text = nil
                updateSendButtonState()
            }
        }
    }
    
    var getText: String {
        get { textView.text }
    }
    
}

//MARK: - UI Setup
extension ChatView {
    
    private func setupUI() {
        self.backgroundColor = .clear
        self.addSubview(textView)
        self.addSubview(sendButton)
        self.addSubview(galleryButton)
        textView.cornerRadius = Constants.textViewCornerRadius
        sendButton.cornerRadius = Constants.sendButtonCornerRadius
    }
    
}

//MARK: - Constrains Setup
extension ChatView {
    
    private func setupConstrains() {
        textView.snp.makeConstraints { make in
            make.left.equalTo(galleryButton.snp.right).offset(10.0)
            make.centerY.equalToSuperview()
            make.right.equalTo(sendButton.snp.left).offset(-12)
            make.bottom.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        sendButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(Constants.sendButtonHeight)
            make.right.equalToSuperview().inset(16.0)
        }
        
        galleryButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16.0)
            make.centerY.equalToSuperview()
            make.size.equalTo(24.0)
        }
        
    }
    
}

//MARK: - TextView Halpers
extension ChatView {
    
    func updateSendButtonState() {
        if textView.text != Constants.placeholder &&
            allowSendind &&
            !textView.text.trimmingCharacters (in: .whitespacesAndNewlines)
            .isEmpty {
            sendButton.isEnabled = true
            sendButton.tintColor = .appWhite
            sendButton.backgroundColor = .appActive
        } else {
            sendButton.isEnabled = false
            sendButton.tintColor = .appWhite
            sendButton.backgroundColor = .appActiveDisable
        }
    }
    
    func hideKeybord() {
        textView.resignFirstResponder()
    }
    
}

extension ChatView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .appGrey {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        updateSendButtonState()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let currentTextWithoutNewlines = textView.text.replacingOccurrences(
            of: "\n", with: "")
        if currentTextWithoutNewlines.isEmpty {
            textView.text = Constants.placeholder
            textView.textColor = .appGrey
        }
        updateSendButtonState()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateSendButtonState()
    }
    
    func textView(_ textView: UITextView, 
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range,
                                                                    with: text)
        
        if text == "\n" && sendButton.isEnabled && allowSendind {
            sendButton.sendActions(for: .touchUpInside)
            textViewIsEmpty = true
            return false
        } else if text == "\n"{
            textViewIsEmpty = true
            return false
        }
        
        let newTextWithoutNewlines = newText.replacingOccurrences(of: "\n",
                                                                  with: "")
        let newLength = newTextWithoutNewlines.count
        
        if newLength <= Constants.characterCountLimit {
            return true
        } else {
            let allowedLength = Constants.characterCountLimit - currentText.replacingOccurrences(of: "\n", with: "").count
            if allowedLength > 0 {
                let trimmedText = text.prefix(allowedLength)
                let finalText = (currentText as NSString).replacingCharacters(
                    in: range, with: String(trimmedText))
                textView.text = finalText
            }
            return false
        }
    }
}

//
//  KeyboardHelper+Chat.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 12.09.24.
//

import Foundation

struct AIExpertChatKeyboardHelperUseCase:
    AIExpertChatKeyboardHelperUseCaseProtocol {
    
    private let keyboardHelper: KeyboardHelper
    
    init(keyboardHelper: KeyboardHelper) {
        self.keyboardHelper = keyboardHelper
    }
    
    func onWillShow(_ handler: @escaping (CGRect) -> Void) -> KeyboardHelper {
        keyboardHelper.onWillShow(handler)
    }
    
    func onWillHide(_ handler: @escaping (CGRect) -> Void) -> KeyboardHelper {
        keyboardHelper.onWillHide(handler)
    }
}

//
//  KeyboardHelper+Task.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 4.09.24.
//

import Foundation

struct TaskKeyboardHelperUseCase: TaskKeyboardHelperUseCaseProtocol {
    
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

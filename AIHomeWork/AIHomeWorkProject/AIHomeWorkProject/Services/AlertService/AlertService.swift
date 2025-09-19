//
//  AlertService.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 6.09.24.
//

import UIKit

final class AlertService: NSObject {
    
    typealias AlertActionHandler = () -> Void
    typealias ActionHandler = (_ text: String?) -> Void
    private let windowManager: WindowManager
    
    init(container: Container) {
        self.windowManager = container.resolve()
    }
    
    func showAlert(title: String?,
                   message: String? = nil,
                   cancelTitle: String? = nil,
                   cancelHandler: AlertActionHandler? = nil,
                   okTitle: String? = nil,
                   okHandler: AlertActionHandler? = nil,
                   settingTitle: String? = nil,
                   settingHandler: AlertActionHandler? = nil
    ) {
        //Build
        let alertVC = buildAlert(title: title,
                                 message: message,
                                 cancelTitle: cancelTitle,
                                 cancelHandler: cancelHandler,
                                 okTitle: okTitle,
                                 okHandler: okHandler,
                                 settingTitle: settingTitle,
                                 settingHandler: settingHandler)
        
        let window = windowManager.get(type: .alert)
        window.rootViewController = UIViewController()
        windowManager.show(type: .alert)
        window.rootViewController?.present(alertVC, animated: true)
    }
    
    
    
    func showActionSheet(title: String? = nil,
                         message: String? = nil,
                         actionTitle: String,
                         actionHandler: AlertActionHandler? = nil,
                         secondActionTitle: String,
                         secondActionHandler: AlertActionHandler? = nil,
                         cancelTitle: String) {
        //Build
        let alertVC = buildActionSheet(title: title,
                                       message: message,
                                       actionTitle: actionTitle,
                                       actionHandler: actionHandler,
                                       secondActionTitle: secondActionTitle,
                                       secondActionHandler: secondActionHandler,
                                       cancelTitle: cancelTitle)
        
        let window = windowManager.get(type: .alert)
        window.rootViewController = UIViewController()
        windowManager.show(type: .alert)
        window.rootViewController?.present(alertVC, animated: true)
    }
    
    func hideAlert() {
        windowManager.hideAndRemove(type: .alert)
    }
    
}

//MARK: - Alert Bilder
extension AlertService {
    
    private func buildAlert(title: String?,
                            message: String?,
                            cancelTitle: String? = nil,
                            cancelHandler: AlertActionHandler? = nil,
                            okTitle: String? = nil,
                            okHandler: AlertActionHandler? = nil,
                            settingTitle: String? = nil,
                            settingHandler: AlertActionHandler? = nil
                            
    ) -> UIAlertController {
        let alertVC = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: .alert)
        
        if let cancelTitle {
            let action = UIAlertAction(title: cancelTitle,
                                       style: .cancel) { [weak self] _ in
                cancelHandler?()
                self?.windowManager.hideAndRemove(type: .alert)
            }
            alertVC.addAction(action)
        }
        
        if let okTitle {
            let action = UIAlertAction(title: okTitle,
                                       style: .default) { [weak self] _ in
                okHandler?()
                self?.windowManager.hideAndRemove(type: .alert)
            }
            alertVC.addAction(action)
        }
        
        if let settingTitle {
            let action = UIAlertAction(title: settingTitle,
                                       style: .default) { [weak self] _ in
                settingHandler?()
                self?.windowManager.hideAndRemove(type: .alert)
            }
            alertVC.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel) { [weak self] _ in
                self?.windowManager.hideAndRemove(type: .alert)
            })
            alertVC.addAction(action)
        }
        
        return alertVC
    }
    
}

//MARK: ActionSheet Bilder
extension AlertService {
    
    private func buildActionSheet(title: String? = nil,
                                  message: String? = nil,
                                  actionTitle: String,
                                  actionHandler: AlertActionHandler? = nil,
                                  secondActionTitle: String,
                                  secondActionHandler: AlertActionHandler? = nil,
                                  cancelTitle: String
    ) -> UIAlertController {
        let alertVC = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: .actionSheet)
        
        
        alertVC.addAction(UIAlertAction(title: actionTitle,
                                        style: .default) { [weak self] _ in
            actionHandler?()
            self?.windowManager.hideAndRemove(type: .alert)
        })
        
        alertVC.addAction(UIAlertAction(title: secondActionTitle,
                                        style: .default) { [weak self] _ in
            secondActionHandler?()
            self?.windowManager.hideAndRemove(type: .alert)
        })
        
        alertVC.addAction(UIAlertAction(title: cancelTitle,
                                        style: .cancel) { [weak self] _ in
            self?.windowManager.hideAndRemove(type: .alert)
        })
        
        return alertVC
    }
    
    func showRenameChatInput(title: String? = nil,
                             subtitle: String? = nil,
                             actionTitle: String? = nil,
                             cancelTitle: String? = nil,
                             inputPlaceholder: String? = nil,
                             inputKeyboardType: UIKeyboardType = UIKeyboardType.default,
                             actionHandler: ActionHandler? = nil) {
        
        let alertVC = UIAlertController(title: title,
                                        message: subtitle,
                                        preferredStyle: .alert)
        alertVC.addTextField { (textField: UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
            textField.delegate = self
        }
        
        let action = UIAlertAction(title: actionTitle,
                                   style: .default) { [weak self] _ in
            guard let textField = alertVC.textFields?.first else {
                actionHandler?(nil)
                self?.windowManager.hideAndRemove(type: .alert)
                return
            }
            actionHandler?(textField.text)
            self?.windowManager.hideAndRemove(type: .alert)
        }
        
        let cancel = UIAlertAction(title: cancelTitle,
                                   style: .default) { [weak self] _ in
            self?.windowManager.hideAndRemove(type: .alert)
        }
        
        alertVC.addAction(cancel)
        alertVC.addAction(action)
        
        let window = windowManager.get(type: .alert)
        window.rootViewController = UIViewController()
        windowManager.show(type: .alert)
        window.rootViewController?.present(alertVC, animated: true)
    }

    
}

extension AlertService: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        return updatedText.count <= 15
    }
}


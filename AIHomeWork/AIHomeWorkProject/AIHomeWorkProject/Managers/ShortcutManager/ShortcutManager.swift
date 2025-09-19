//
//  ShortcutManager.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 25.09.24.
//

import UIKit

struct ShortcutManager {
    static let sharedInstance = ShortcutManager()
    
    enum ShortcutIdentifier: String {
        case cancelPayment = "com.aihomework.cancelPayment"
        
        init?(fullType: String) {
            guard
                let last = fullType.components(separatedBy: ".").last else
            { return nil }
            self.init(rawValue: last)
        }
    }
    
    func shortcutItem() -> UIApplicationShortcutItem {
        let cancelPayment = UIApplicationShortcutItem(
            type: ShortcutIdentifier.cancelPayment.rawValue,
            localizedTitle: title(),
            localizedSubtitle: subtitle(),
            icon: UIApplicationShortcutIcon(systemImageName: "trash"),
            userInfo: nil
        )
        return cancelPayment
    }
    
    func handle(shortcutItem: UIApplicationShortcutItem,
                rootVC: UIViewController?) -> Bool {
        if shortcutItem.type == ShortcutIdentifier.cancelPayment.rawValue {
            print("Cancel Payment action triggered")
            presentEmai(rootVC: rootVC)
            }
        return true
    }
    
    private func title() -> String {
        let htmlString = "❌Cancel payment❌"
        return htmlString
    }
    
    private func subtitle() -> String {
        let htmlString = "💵Contact us to find out how to unsubscribe"

        return htmlString
    }
    
    func presentEmai(rootVC: UIViewController?) {
        guard
            let rootVC,
            let mailVC = MailCoordinator(rootVC: rootVC).start()
        else { return }
        rootVC.present(mailVC, animated: true)
    }
}

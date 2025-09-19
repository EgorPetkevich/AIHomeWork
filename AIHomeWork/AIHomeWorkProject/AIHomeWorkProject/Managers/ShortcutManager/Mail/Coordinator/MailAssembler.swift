//
//  MailAssembler.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 25.09.24.
//

import UIKit
import MessageUI

final class MailAssembler {
    
    private init() {}
    
    static func make(rootVC: UIViewController) -> MailVC? {
        if MFMailComposeViewController.canSendMail() {
            let mail = MailVC()
            mail.configureMailView(
                recipients: [Constant.Settings.mail],
                subject: "Math Solve: AI Homework Helper",
                body: "Hello, I need assistance with your application.",
                from: rootVC
            )
            return mail
        }
        return nil
    }
}

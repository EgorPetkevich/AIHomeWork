//
//  MailVC.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 25.09.24.
//

import UIKit
import MessageUI

class MailVC: MFMailComposeViewController, MFMailComposeViewControllerDelegate {

    func configureMailView(recipients: [String],
                           subject: String,
                           body: String,
                           isHTML: Bool = false,
                           from presentingViewController: UIViewController?) {

        if let presentingViewController = presentingViewController,
           MFMailComposeViewController.canSendMail() {
            
            setToRecipients(recipients)
            setSubject(subject)
            setMessageBody(body, isHTML: isHTML)
            
            mailComposeDelegate = self
            
            presentingViewController.present(self, animated: true, completion: nil)
        } else {
            print("Cannot send mail or presentingViewController is nil")
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true) { [weak self] in
            guard self != nil else { return }
            switch result {
            case .cancelled:
                print("Mail cancelled")
            case .saved:
                print("Mail saved")
            case .sent:
                print("Mail sent")
            case .failed:
                print("[Error MailViewController]: \(error?.localizedDescription ?? "notDetected")")
            @unknown default:
                return
            }
        }
    }
    
}

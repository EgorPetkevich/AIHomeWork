//
//  MailCoordinator.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 25.09.24.
//

import UIKit
import MessageUI

final class MailCoordinator: Coordinator {
    
    private var rootVC: UIViewController
    
    init(rootVC: UIViewController) {
        self.rootVC = rootVC
    }
    
    override func start() -> MailVC? {
        if let vc = MailAssembler.make(rootVC: rootVC) {
            return vc
        }
        return nil
    }
    
}

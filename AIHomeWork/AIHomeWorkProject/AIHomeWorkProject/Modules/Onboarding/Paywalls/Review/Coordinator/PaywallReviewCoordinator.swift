//
//  PaywallReviewCoordinator.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 28.08.24.
//

import Foundation

final class PaywallReviewCoordinator: Coordinator {
    
    private var rootVC: PaywallReviewVC?
    private let container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    override func start() -> PaywallReviewVC {
        let vc = PaywallReviewAssembler.make(container: container,
                                             coordinator: self)
        self.rootVC = vc
        return vc
    }
    
}


extension PaywallReviewCoordinator: PaywallReviewCoordinatorProtocol { }

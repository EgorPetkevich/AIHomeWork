//
//  PaywallProdTrialCoordinator.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 28.08.24.
//

import Foundation

final class PaywallProdTrialCoordinator: Coordinator {
    
    private var rootVC: PaywallProdTrialVC?
    private let container: Container
    private let pageControlIsHiden: Bool
    
    init(container: Container, pageControlIsHiden: Bool) {
        self.container = container
        self.pageControlIsHiden = pageControlIsHiden
    }
    
    override func start() -> PaywallProdTrialVC {
        PaywallProdTrialAssembler.make(container: container,
                                       coordinator: self,
                                       pageControlIsHiden: pageControlIsHiden)
    }
    
}

extension PaywallProdTrialCoordinator:
    PaywallProdTrialCoordinatorProtocol {}

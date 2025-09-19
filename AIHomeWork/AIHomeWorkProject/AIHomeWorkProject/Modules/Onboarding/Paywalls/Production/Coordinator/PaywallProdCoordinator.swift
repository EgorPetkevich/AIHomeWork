//
//  PaywallProdCoordinator.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 28.08.24.
//

import Foundation

final class PaywallProdCoordinator: Coordinator {
    
    private var rootVC: PaywallProdVC?
    private let container: Container
    private let pageControlIsHiden: Bool
    
    init(container: Container, pageControlIsHiden: Bool) {
        self.container = container
        self.pageControlIsHiden = pageControlIsHiden
    }
    
    override func start() -> PaywallProdVC {
        PaywallProdAssembler.make(container: container, coordinator: self,
                                  pageControlIsHiden: pageControlIsHiden)
    }
    
}

extension PaywallProdCoordinator: PaywallProdCoordinatorProtocol {}

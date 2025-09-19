//
//  Adapty+Prod.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 26.09.24.
//

import Foundation

struct PaywallProdAdaptyService: PaywallProdAdaptyServiceUseCaseProtocol {
    
    private var service: AdaptyService
    
    var productWeaklyPrice: String?
    
    init(service: AdaptyService) {
        self.service = service
        self.productWeaklyPrice = service.productWeaklyPrice
    }
    
    func makePurchase(type: AdaptyService.PurchaseType,
                      completion: @escaping (Bool) -> Void) {
        self.service.makePurchase(type: type, completion: completion)
    }
    
    func getProductPrice(type: AdaptyService.PurchaseType,
                         completion: @escaping (String?) -> Void) {
        self.service.getProductPrice(type: type,
                                     completion: completion)
    }
    
    func restorePurchases(completion: @escaping (Bool) -> Void) {
        self.service.restorePurchases(completion: completion)
    }
    
}

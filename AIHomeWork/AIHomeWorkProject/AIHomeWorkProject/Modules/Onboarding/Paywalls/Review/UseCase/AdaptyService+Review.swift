//
//  AdaptyService+Review.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 25.09.24.
//

import Foundation

struct PaywallReviewAdaptyService: PaywallReviewAdaptyServiceUseCaseProtocol {
    
    private var service: AdaptyService
    
    var trialPrice: String?
    var weaklyPrice: String?
    
    init(service: AdaptyService) {
        self.service = service
        trialPrice = service.productTrialPrice
        weaklyPrice = service.productWeaklyPrice
    }
    
    func makePurchase(type: AdaptyService.PurchaseType,
                      completion: @escaping (Bool) -> Void) {
        self.service.makePurchase(type: type, completion: completion)
    }
    
    func getProductPrice(type: AdaptyService.PurchaseType,
                         completion: @escaping (String?) -> Void) {
        self.service.getProductPrice(type: type, completion: completion)
    }
    
    func restorePurchases(completion: @escaping (Bool) -> Void) {
        self.service.restorePurchases(completion: completion)
    }
    
}


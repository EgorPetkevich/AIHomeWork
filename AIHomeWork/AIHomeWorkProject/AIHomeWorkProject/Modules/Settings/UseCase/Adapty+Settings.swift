//
//  Adapty+Settings.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 26.09.24.
//

struct SettingsAdaptyService: SettingsAdaptyServiceUseCaseProtocol {
    
    private var service: AdaptyService
    
    var productTrialPrice: String?
    
    init(service: AdaptyService) {
        self.service = service
    }
    
    func restorePurchases(completion: @escaping (Bool) -> Void) {
        self.service.restorePurchases(completion: completion)
    }
    
}

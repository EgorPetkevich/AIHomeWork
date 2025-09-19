//
//  AdaptyService+Prod.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 13.11.24.
//

import Foundation

struct OnboardingProdAdaptyServiceUseCase:
    OnboardingProdAdaptyServiceUseCaseProtocol {
    
    var isPremium: Bool
    
    init(serivce: AdaptyService) {
        self.isPremium = serivce.isPremium
    }
    
}

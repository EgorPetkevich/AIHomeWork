//
//  AdaptyService+Rev.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 13.11.24.
//

import Foundation

struct OnboardingRevAdaptyServiceUseCase:
    OnboardingRevAdaptyServiceUseCaseProtocol {
    
    var isPremium: Bool
    
    init(serivce: AdaptyService) {
        self.isPremium = serivce.isPremium
    }
    
}

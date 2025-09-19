//
//  OnboardingManager.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 26.08.24.
//

import Foundation

class OnboardingManager {
    
    enum Options {
        case review
        case production
        case reviewWithTrial
        case productionWithTrial
    }
    
    enum ProductionOnboardingPage: Int, CaseIterable {
        case first = 0
        case second
        case third
        case paywall
        case mainApp
    }
    
    static var numOfPages: Int {
        return ProductionOnboardingPage.allCases.count
    }
    
    static func step(for page: ProductionOnboardingPage) -> Int {
        return page.rawValue
    }
    
}

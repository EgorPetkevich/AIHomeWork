//
//  SettingsSection.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 2.09.24.
//

import UIKit

import UIKit

final class SettingsSection {
    
    enum Settings: SettingsCellSetupProtocol {
        case rate
        case share
        case restore
        case terms
        case privacy
        
        var title: String {
            switch self {
            case .rate: return "Rate us"
            case .share: return "Share App"
            case .restore: return "Restore Purchases"
            case .terms: return "Terms of use"
            case .privacy: return "Privacy Policy"
            }
        }
        
        var icon: UIImage {
            switch self {
            case .rate: return .MainApp.Settings.rateImage
            case .share: return .MainApp.Settings.shareImage
            case .restore: return .MainApp.Settings.restoreImage
            case .terms: return .MainApp.Settings.termsImage
            case .privacy: return .MainApp.Settings.privacyImage
            }
        }
    }
    
}

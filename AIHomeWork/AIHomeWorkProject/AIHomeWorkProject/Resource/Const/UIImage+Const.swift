//
//  UIImage+Const.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 23.08.24.
//

import UIKit

extension UIImage {
    
    //MARK: - AppIcon
    enum AppIcon {
        static var leftArrowImage: UIImage = .init(named: "appicon_arrow_left")!
        static var rightArrowImage: UIImage = .init(named: "appicon_arrow_right")!
        static var scannerImage: UIImage = .init(named: "appicon_button_scanner")!
        static var galleryNotFoundImage: UIImage = .init(named: "appicon_notfound_gallery")!
        static var cropImage: UIImage = .init(named: "appicon_edit_crop")!
        static var xMarkImage: UIImage = .init(named: "appicon_xmark")!
        static var menuDotsImage: UIImage = .init(named: "appicon_menu_dots")!
        static var binImage: UIImage = .init(named: "appicon_bin")!
        static var editImage: UIImage = .init(named: "appicon_edit")!
        static var editSparkImage: UIImage = .init(named: "appicon_edit_spark")!
        static var taskImage: UIImage = .init(named: "appicon_task")!
        static var solutionImage: UIImage = .init(named: "appicon_solution")!
        static var plusImage: UIImage = .init(named: "appicon_plus")!
        static var arrowUpImage: UIImage = .init(named: "appicon_up_arrow")!
        static var renameImage: UIImage = .init(named: "appicon_rename")!
        static var galeryImage: UIImage = .init(named: "appicon_galery")!
        static var whiteXMarkImage: UIImage = .init(named: "appicon_white_xmark")!
        static var grayXMarkImage: UIImage = .init(named: "appicon_gray_xmark")!
        static var copieImage: UIImage = .init(named: "appicon_copie")!
    }
    
    //MARK: - Onbording
    enum Onboarding {
        
        enum FirstStep {
            static var bgImage: UIImage = .init(named: "onboarding_firststep_bg")!
        }
        
        enum SecondStep {
            static var girlImage: UIImage = .init(named: "onboarding_secondstep_girl")!
            static var ihoneImage: UIImage = .init(named: "onboarding_secondstep_iphone")!
            static var solutionImage: UIImage = .init(named: "onboarding_secondstep_solution")!
            static var iponeContentImage: UIImage = .init(named: "onboarding_secondstep_iphonecontent")!
        }
        
        enum ThirdStep {
            static var iponeImage: UIImage = .init(named: "onboarding_thirdstep_iphone")!
            static var overviewImage: UIImage = .init(named: "onboarding_thirdstep_overview")!
        }
        
    }
    
    //MARK: - Paywall
    enum Paywall {
        static var biologyImage: UIImage = .init(named: "paywall_cell_biology")!
        static var grammerImage: UIImage = .init(named: "paywall_cell_grammar")!
        static var physicsImage: UIImage = .init(named: "paywall_cell_physics")!
        static var iphoneImage: UIImage = .init(named: "paywall_iphone")!
        static var crossImage: UIImage = .init(named: "paywall_cross")!
    }
    
    //MARK: - ActivityButton
    enum ActivityButton {
        static var arrowImage: UIImage = .init(named: "activitybutton_right_arrow")!
    }
    
    //MARK: - PageControlDots
    enum PageControlDots {
        static var defaultDotImage: UIImage = .init(named: "pagecontorl_default_dot")!
        static var currentDotImage: UIImage = .init(named: "pagecontrol_current_dot")!
        static var pastDotImage: UIImage = .init(named: "pagecontrol_past_dot")!
    }
    
    //MARK: - Main App
    enum MainApp {
        
        enum TabBar {
            static var scanImage: UIImage = .init(named: "main_tabbar_scan")!
            static var homeImage: UIImage = .init(named: "main_tabbar_home")!
            static var historyImage: UIImage = .init(named: "main_tabbar_history")!
        }
        
        enum Home {
            
            enum Adapter {
                static var atomImage: UIImage = .init(named: "main_home_adapter_atom")!
                static var booksImage: UIImage = .init(named: "main_home_adapter_books")!
                static var chalkboardImage: UIImage = .init(named: "main_home_adapter_chalkboard")!
                static var chemistyImage: UIImage = .init(named: "main_home_adapter_chemisty")!
                static var dnkImage: UIImage = .init(named: "main_home_adapter_dnk")!
                static var notebookImage: UIImage = .init(named: "main_home_adapter_notebook")!
            }
            
            static var assistantImage: UIImage = .init(named: "main_home_assistant")!
            static var settingImage: UIImage = .init(named: "main_home_setting")!
        }
        
        enum Settings {
            static var privacyImage: UIImage = .init(named: "main_settings_privacy")!
            static var rateImage: UIImage = .init(named: "main_settings_rate")!
            static var restoreImage: UIImage = .init(named: "main_settings_restore")!
            static var shareImage: UIImage = .init(named: "main_settings_share")!
            static var termsImage: UIImage = .init(named: "main_settings_terms")!
        }
        
        enum History {
            static var professorImage: UIImage = .init(named: "main_history_professor")!
        }
        
        enum Camera {
            static var splashOffImage: UIImage = .init(named: "camera_off_splash")!
            static var splashOnImage: UIImage = .init(named: "camera_on_splash")!
        }
        
    }
    
    enum AIExpertChat {
        static var girlImage: UIImage = .init(named: "aiexpertchat_girl")!
        static var professorImage: UIImage = .init(named: "aiexpertchat_professor")!
    }
    
    
    
}

//
//  AppDelegate.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 23.08.24.
//

import UIKit
import Adapty

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        application.shortcutItems = []
        application.shortcutItems?.append(ShortcutManager.sharedInstance.shortcutItem())
        Adapty.logLevel = .verbose
        // MARK: - For review (disabled Adapty for easier run)
//        Adapty.activate(Constant.Adapty.adaptyKEY)
        //
        return true
    }
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
   
        return UISceneConfiguration(name: "Default Configuration", 
                                    sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }


}


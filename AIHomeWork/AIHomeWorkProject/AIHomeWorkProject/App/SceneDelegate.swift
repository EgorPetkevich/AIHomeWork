//
//  SceneDelegate.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 23.08.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, 
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let container = ContainerRegister.makeContainer()
        container.register({ WindowManager(scene: windowScene) })
        appCoordinator = AppCoordinator(container: container)
        
        appCoordinator?.startApp()
    }
    
    func windowScene(_ windowScene: UIWindowScene,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        completionHandler(
            ShortcutManager
                .sharedInstance
                .handle(shortcutItem: shortcutItem,
                        rootVC: windowScene.keyWindow?.rootViewController)
        )
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        appCoordinator?.startFromForeground()
    }

}


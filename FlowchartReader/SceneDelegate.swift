//
//  SceneDelegate.swift
//  FlowchartReader
//
//  Created by Jason Nugraha on 08/06/21.
//

import UIKit

class CustomWindow : UIWindow {
    
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let defaults = UserDefaults.standard
                
        // check if first download
        let isFirstOpen = defaults.bool(forKey: "isFirstOpen")
        
        // tambahin code buat ngerun
        
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//
//        let storyboard = UIStoryboard(name: "djWorkspace", bundle: nil)
//        let initialViewController = storyboard.instantiateViewController(withIdentifier: "NavigationControllerHomepage")
//
//        window = CustomWindow(windowScene: windowScene)
//        window?.rootViewController = initialViewController
//        window!.makeKeyAndVisible()
        
        if (isFirstOpen != false) {
            defaults.setValue(true, forKey: "isFirstOpen")
            guard let windowScene = (scene as? UIWindowScene) else { return }

            let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController")

            window = CustomWindow(windowScene: windowScene)
            window?.rootViewController = initialViewController
            window!.makeKeyAndVisible()

        } else {
            guard let windowScene = (scene as? UIWindowScene) else { return }

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")

            window = CustomWindow(windowScene: windowScene)
            window?.rootViewController = initialViewController
            window!.makeKeyAndVisible()

        }
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}


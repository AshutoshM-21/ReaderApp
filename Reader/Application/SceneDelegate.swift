//
//  SceneDelegate.swift
//  Reader
//
//  Created by Ashutosh Muraskar on 15/09/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
        guard let windowScene = (scene as? UIWindowScene) else { return }

            ThemeManager.applyGlobalTheme()

          
            let newsVC = CustomNavigationController(rootViewController: ArticlesViewController(category: .general))
            newsVC.tabBarItem = UITabBarItem(title: "News", image: UIImage(systemName: "newspaper"), tag: 0)

            
            let bookmarksVC = CustomNavigationController(rootViewController: BookmarksViewController())
            bookmarksVC.tabBarItem = UITabBarItem(title: "Bookmarks", image: UIImage(systemName: "bookmark"), tag: 1)

            
            let tabBar = UITabBarController()
            tabBar.viewControllers = [newsVC, bookmarksVC]

           
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = tabBar
            self.window = window
            window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
       
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
       
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
      
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }


}


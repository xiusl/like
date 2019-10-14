//
//  AppDelegate.swift
//  Like
//
//  Created by xiusl on 2019/9/29.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        let _ = User.read()
        if User.isLogin {
            let vc = MainTabBarController()
            self.window?.rootViewController = vc
        } else {
            let vc = PasswordLoginViewController()
            vc.isPrefersHidden = true
            let nav = MainNavigationController(rootViewController: vc)
            self.window?.rootViewController = nav
        }
        self.window?.makeKeyAndVisible()
        
        return true
    }

    // MARK: UISceneSession Lifecycle



}


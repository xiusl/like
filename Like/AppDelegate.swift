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
            self.reCheckUserAuth()
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

    
    func reCheckUserAuth() {
        let request = SettingApiRequest.ping(())
        ApiManager.shared.request(request: request, success: { (result) in
            
        }) { (error) in
            if error == "Please login" {
                User.delete()
                let vc = PasswordLoginViewController()
                vc.isPrefersHidden = true
                let nav = MainNavigationController(rootViewController: vc)
                self.window?.rootViewController = nav
            }
        }
    }

}


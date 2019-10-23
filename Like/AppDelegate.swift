//
//  AppDelegate.swift
//  Like
//
//  Created by xiusl on 2019/9/29.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate {

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
        WXApi.registerApp("wxd07ead9c827a04f5", universalLink: "https://ins.sleen.top/")
        
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

    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let url = userActivity.webpageURL
            if url != nil {
                let urlStr = url!.absoluteString
                if urlStr.contains("articles") {
                    let vc = ArticleDetailViewController()
                    vc.urlStr = urlStr
                    self.getTopViewController().present(vc, animated: true, completion: nil)
                }
            }
        }
        return true
    }
    
    func getTopViewController() -> UIViewController {
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController!
        }
        return topVC!
    }
}


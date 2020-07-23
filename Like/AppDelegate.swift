//
//  AppDelegate.swift
//  Like
//
//  Created by xiusl on 2019/9/29.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit
import LeanCloud
import SwiftyJSON

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
        WXApi.registerApp("wxd07ead9c827a04f5", universalLink: "https://ins.sleen.top/weixin/")
        
//        do {
//            let d = try Data(contentsOf: URL(fileURLWithPath: "/Users/xiusl/Desktop/456.jpg"))
//            let _ = qn_eTag(data: d)
//        } catch let error as Error? {
//            print(error ?? "")
//        }
        LCApplication.logLevel = .all
        do {
            try LCApplication.default.set(
                id: "gq4MUUJhLQ3rAy3jhcVbl5H3-gzGzoHsz",
                key: "Kr4uOYW18Xz2RPtkCFsehKhB",
                serverURL: "https://like-im.sleen.top")
        } catch {
            print(error)
        }
        
        // init
        _ = LCApplication.default.currentInstallation
        _ = Client.delegator
        
        registerNoti()
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    
    func reCheckUserAuth() {
        let request = SettingApiRequest.ping(())
        ApiManager.shared.request(request: request, success: { [weak self ] (result) in
            let data = JSON(result)
            print(data)
            let uid = data["user_id"].stringValue
            Configuration.UserOption.clientID.set(value: uid)
            self?.clientInitializing(isReopen: true)
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
                } else if urlStr.contains("weixin") {
                    return WXApi.handleOpenUniversalLink(userActivity, delegate: self)
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
    
    func onReq(_ req: BaseReq) {
        
    }
    
    func onResp(_ resp: BaseResp) {
        if resp.isKind(of: SendMessageToWXResp.self) {
            let msgResp = resp as! SendMessageToWXResp
            debugPrint(msgResp.errStr)
        }
    }
    
    func registerNoti() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
                    if granted {
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                }
            default:
                break
            }
        }

    }
}

extension AppDelegate {
    func clientInitializing(isReopen: Bool) {
        do {
            
            let clientID: String = Configuration.UserOption.clientID.stringValue ?? ""
            let tag: String? = (Configuration.UserOption.isTagEnabled.boolValue ? "mobile" : nil)
            let options: IMClient.Options = Configuration.UserOption.isLocalStorageEnabled.boolValue
                ? .default
                : { var dOptions = IMClient.Options.default; dOptions.remove(.usingLocalStorage); return dOptions }()
            
            let client = try IMClient(
                ID: clientID,
                tag: tag,
                options: options,
                delegate: Client.delegator,
                eventQueue: Client.queue
            )
            
            if options.contains(.usingLocalStorage) {
                try client.prepareLocalStorage { (result) in
                    Client.specificAssertion
                    switch result {
                    case .success:
                        do {
                            try client.getAndLoadStoredConversations(completion: { (result) in
                                Client.specificAssertion
                                switch result {
                                case .success(value: let storedConversations):
                                    var conversations: [IMConversation] = []
                                    var serviceConversations: [IMServiceConversation] = []
                                    for item in storedConversations {
                                        if type(of: item) == IMConversation.self {
                                            conversations.append(item)
                                        } else if let serviceItem = item as? IMServiceConversation {
                                            serviceConversations.append(serviceItem)
                                        }
                                    }
                                    self.open(
                                        client: client,
                                        isReopen: isReopen,
                                        storedConversations: (conversations.isEmpty ? nil : conversations),
                                        storedServiceConversations: (serviceConversations.isEmpty ? nil : serviceConversations)
                                    )
                                case .failure(error: let error):
                                    break
                                }
                            })
                        } catch {
                            
                        }
                    case .failure(error: let error):
                        break
                    }
                }
            } else {
                self.open(client: client, isReopen: isReopen)
            }
        } catch {
        }
    }
    
    func open(
        client: IMClient,
        isReopen: Bool,
        storedConversations: [IMConversation]? = nil,
        storedServiceConversations: [IMServiceConversation]? = nil)
    {
        let options: IMClient.SessionOpenOptions
        if let _ = client.tag {
            options = Configuration.UserOption.isAutoOpenEnabled.boolValue ? [] : [.forced]
        } else {
            options = .default
        }
        client.open(options: options, completion: { (result) in
            Client.specificAssertion
            
            switch result {
            case .success:
                mainQueueExecuting {
                    Client.current = client
                    Client.storedConversations = storedConversations
                    Client.storedServiceConversations = storedServiceConversations
                }
                break
            case .failure(error: let error):
                if error.code == 4111 {
                    Client.delegator.client(client, event: .sessionDidClose(error: error))
                }
            }
        })
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let str = String(data: deviceToken, encoding: .utf8)
        print(str ?? "")
        let token = deviceToken.reduce("", {$0 + String(format: "%02x", $1)})
        
        print(token)
        
        Client.installationOperatingQueue.async {
            let installation = LCApplication.default.currentInstallation
            installation.set(deviceToken: deviceToken, apnsTeamId: "3S73583C2C")
            if let error = installation.save().error {
                print(error)
            }
            
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // handle notification
        print("收到吐送送神农氏")
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // handle notification
        print("收到吐送送神农氏")
    }
}


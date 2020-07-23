//
//  MainTabBarController.swift
//  Like
//
//  Created by xiusl on 2019/10/11.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeVc = HomeTabViewController()
        self.setupChildVc(vc: homeVc,
                          title: "首页",
                          imageName: "tabbar_home_nor",
                          selectedImageName: "tabbar_home_sel")
        
        let orderVc = DiscoverTabViewController()
        self.setupChildVc(vc: orderVc,
                          title: "发现",
                          imageName: "tabbar_discover_nor",
                          selectedImageName: "tabbar_discover_sel")
        
        let msgVc = MessageTableViewController()
        self.setupChildVc(vc: msgVc,
                          title: "消息",
                          imageName: "tabbar_msg_nor",
                          selectedImageName: "tabbar_msg_sel")
        
        let meVc = MeTabViewController()
        self.setupChildVc(vc: meVc,
                          title: "我的",
                          imageName: "tabbar_me_nor",
                          selectedImageName: "tabbar_me_sel")
    
        let font = UIFont.systemFont(ofSize: 10, weight: .medium)
        let color = UIColor.init(hex: 0xB1B1B1)
        let sColor = UIColor.init(hex: 0x44C7FB)
        if #available(iOS 13.0, *) {
            self.tabBar.tintColor = .white
            self.tabBar.unselectedItemTintColor = color
            let item = UITabBarItem.appearance()
            item.setTitleTextAttributes([.font: font], for: .normal)
            item.setTitleTextAttributes([.font: font], for: .selected)
        } else {
            let item = UITabBarItem.appearance()
            item.setTitleTextAttributes([.font: font, .foregroundColor: color], for: .normal)
            item.setTitleTextAttributes([.font: font, .foregroundColor: sColor], for: .selected)
        }
        self.tabBar.isTranslucent = false
    }
    
        func setupChildVc(vc: UIViewController, title: String, imageName: String, selectedImageName: String) {
            let navVc = MainNavigationController.init(rootViewController: vc)
            vc.title = title
            navVc.tabBarItem.title = title
            navVc.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
            navVc.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.withRenderingMode(.alwaysOriginal)
            
            let font = UIFont.systemFont(ofSize: 10, weight: .medium)
            let color = UIColor.init(hex: 0xB1B1B1)
            let sColor = UIColor.init(hex: 0x44C7FB)
            let textStyle = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor:color]
            let sTextStyle = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor:sColor]
            
            navVc.tabBarItem.setTitleTextAttributes(textStyle, for: .normal)
            navVc.tabBarItem.setTitleTextAttributes(sTextStyle, for: .selected)
            
            
            self.addChild(navVc)
        }
    
    
    override var childForStatusBarStyle: UIViewController? {
        return self.selectedViewController
    }
}

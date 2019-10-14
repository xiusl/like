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
            
            let meVc = MeTabViewController()
            self.setupChildVc(vc: meVc,
                              title: "我的",
                              imageName: "tabbar_me_nor",
                              selectedImageName: "tabbar_me_sel")
        }
        
        func setupChildVc(vc: UIViewController, title: String, imageName: String, selectedImageName: String) {
            let navVc = MainNavigationController.init(rootViewController: vc)
            vc.title = title
            navVc.tabBarItem.title = title
            navVc.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
            navVc.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.withRenderingMode(.alwaysOriginal)
            
            var font = UIFont.systemFont(ofSize: 10)
            if #available(iOS 8.2, *) {
                font = UIFont.systemFont(ofSize: 10, weight: .medium)
            }
            let color = UIColor.init(hex: 0x1A2C3F)
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

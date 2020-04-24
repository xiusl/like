//
//  MainNaviagtionController.swift
//  Like
//
//  Created by xiusl on 2019/10/9.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBar.setBackgroundImage(UIImage.imageWith(color: .white), for: .default)
        self.navigationBar.shadowImage = UIImage(color: .cF2F4F8)
        
        UIBarButtonItem.appearance().tintColor = .theme
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
}

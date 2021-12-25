//
//  MainNaviagtionController.swift
//  Like
//
//  Created by xiusl on 2019/10/9.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {

    var currentVc: UIViewController?
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        navigationBar.isTranslucent = false
        self.interactivePopGestureRecognizer?.delegate = self;
        self.delegate = self;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.interactivePopGestureRecognizer {
            return currentVc == self.topViewController
        }
        return true
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewControllers.count == 1 {
            currentVc = nil
        } else {
            currentVc = viewController
        }
    }

    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
}

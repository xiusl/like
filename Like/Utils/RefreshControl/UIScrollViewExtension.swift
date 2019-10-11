//
//  UIScrollViewEx.swift
//  Like
//
//  Created by xiusl on 2019/9/29.
//  Copyright © 2019 likeeee. All rights reserved.
//
//  https://github.com/CoderMJLee/MJRefresh

import UIKit

var name_key = "name_key"
extension UIScrollView {
    
    var refFooter: RefreshBackFooter? {
        get {
            return objc_getAssociatedObject(self, &name_key) as? RefreshBackFooter
        }
        set {
            self.refFooter?.removeFromSuperview()
            self.insertSubview(newValue!, at: 0)
            objc_setAssociatedObject(self, &name_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

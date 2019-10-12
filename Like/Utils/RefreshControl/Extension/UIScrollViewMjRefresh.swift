//
//  UIScrollViewEx.swift
//  Like
//
//  Created by xiusl on 2019/9/29.
//  Copyright © 2019 likeeee. All rights reserved.
//
//  https://github.com/CoderMJLee/MJRefresh

import UIKit

var mjHeaderKey = "mj_header_key"
var mjFooterKey = "mj_footer_key"
extension UIScrollView {
    
    var mjFooter: RefreshFooter? {
        get {
            return objc_getAssociatedObject(self, &mjFooterKey) as? RefreshFooter
        }
        set {
            self.mjFooter?.removeFromSuperview()
            self.insertSubview(newValue!, at: 0)
            objc_setAssociatedObject(self, &mjFooterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var mjHeader: RefreshHeader? {
        get {
            return objc_getAssociatedObject(self, &mjHeaderKey) as? RefreshHeader
        }
        set {
            self.mjHeader?.removeFromSuperview()
            self.insertSubview(newValue!, at: 0)
            objc_setAssociatedObject(self, &mjHeaderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    open func mjTotalDataCount() -> Int {
        var totalCount = 0
        if self.isKind(of: UITableView.self) {
            let tableView = self as! UITableView
            for section in 0...tableView.numberOfSections {
                totalCount += tableView.numberOfRows(inSection: section)
            }
        } else if self.isKind(of: UICollectionView.self) {
            let collectionView = self as! UICollectionView
            for section in 0...collectionView.numberOfSections {
                totalCount += collectionView.numberOfItems(inSection: section)
                
            }
        }
        return totalCount
    }
}

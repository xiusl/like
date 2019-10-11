//
//  ViewController.swift
//  Like
//
//  Created by xiusl on 2019/9/29.
//  Copyright © 2019 likeeee. All rights reserved.
//
//  https://github.com/CoderMJLee/MJRefresh

import UIKit

class RefreshFooter: RefreshComponent {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    class func footer(withRefreshingBlock refreshingBlock: @escaping MjRefreshComponentRefreshingBlock) -> RefreshFooter {
        let footer = self.init()
        footer.refreshingBlock = refreshingBlock
        return footer
    }
    class func footer(withRefreshingTarget refreshingTarget: AnyObject, refreshingAction: Selector) -> RefreshFooter {
        let footer = self.init()
        footer.refreshingTarget = refreshingTarget
        footer.refreshingAction = refreshingAction
        return footer
    }
    
    /** 提示没有更多的数据 */
    open func endRefreshingWithNoMoreData() {
        self.setState(.noMoreData)
    }
    /** 重置没有更多的数据（消除没有更多数据的状态） */
    open func resetNoMoreData() {
        self.setState(.idle)
    }
    
    /** 忽略多少scrollView的contentInset的bottom */
    var ignoredScrollViewContentInsetBottom: Float = 0
    
    
    // MARK: - 重写父类方法
    override func prepare() {
        super.prepare()
        
        // 设置自己的高度
        self.frame.size.height = 44
    }

}

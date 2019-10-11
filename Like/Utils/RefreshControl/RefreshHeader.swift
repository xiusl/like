//
//  RefreshHeader.swift
//  Like
//
//  Created by xiusl on 2019/10/11.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit

class RefreshHeader: RefreshComponent {
    var lastUpdatedTimeKey: String = ""
    var lastUpdatedTime: Date?
    /// 这个key用来存储上一次下拉刷新成功的时间
    var ignoredScrollViewContentInsetTop: Float = 0.0
    
    func headerWithRefreshingTarget() -> RefreshHeader {
        return RefreshHeader()
    }
    
    func headerWithRefreshingBlock() -> RefreshHeader {
        return RefreshHeader()
    }
}

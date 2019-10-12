//
//  RefreshBackStateFooter.swift
//  Like
//
//  Created by xiusl on 2019/10/12.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit

class RefreshBackStateFooter: RefreshBackFooter {
    /** 文字距离圈圈、箭头的距离 */
    open var labelLeftInset: CGFloat = 0
    /** 显示刷新状态的label */
    lazy var stateLabel: UILabel = {
        let stateLabel = UILabel.mjLabel()
        return stateLabel
    }()
    /** 设置state状态下的文字 */
    open func set(title: String, forState state: RefreshState) {
        self.stateTitles[state] = title
    }
    /** 获取state状态下的title */
    open func title(forState state: RefreshState) -> String {
        return self.stateTitles[state] ?? ""
    }
    
    var stateTitles: [RefreshState:String] = [:]
    
    override func prepare() {
        super.prepare()
        
        if self.stateLabel.superview == nil {
            self.addSubview(self.stateLabel)
        }
        
        self.labelLeftInset = 25
        
        self.set(title: "上拉可以加载更多", forState: .idle)
        self.set(title: "松开立即加载更多", forState: .pulling)
        self.set(title: "正在加载更多的数据...", forState: .refreshing)
        self.set(title: "已经全部加载完毕", forState: .noMoreData)
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        if self.stateLabel.constraints.count > 0 { return }
        
        self.stateLabel.frame = self.bounds
    }
    
    override func setState(_ state: RefreshState) {
        let oldState = self.state
        if oldState == state { return }
        super.setState(state)
        self.state = state
        
        self.stateLabel.text = self.stateTitles[state]
    }
}

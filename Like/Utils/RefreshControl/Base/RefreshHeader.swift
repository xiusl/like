//
//  RefreshHeader.swift
//  Like
//
//  Created by xiusl on 2019/10/11.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit

class RefreshHeader: RefreshComponent {
    /// 这个key用来存储上一次下拉刷新成功的时间
    var lastUpdatedTimeKey: String = ""
    /** 上一次下拉刷新成功的时间 */
    var lastUpdatedTime: Date {
        return UserDefaults.standard.value(forKey: self.lastUpdatedTimeKey) as! Date
    }

    /** 忽略多少scrollView的contentInset的top */
    var ignoredScrollViewContentInsetTop: CGFloat = 0 {
        didSet {
            self.setExX(-self.ex_h-self.ignoredScrollViewContentInsetTop)
        }
    }
    
    class func header(withRefreshingTarget refreshingTarget: AnyObject, refreshingAction: Selector) -> RefreshHeader {
        let header = self.init()
        header.refreshingTarget = refreshingTarget
        header.refreshingAction = refreshingAction
        return header
    }
    
    class func header(withRefreshingBlock refreshingBlock: @escaping MjRefreshComponentRefreshingBlock) -> RefreshHeader {
        let header = self.init()
        header.refreshingBlock = refreshingBlock
        return header
    }


    private var insetTDelta: CGFloat = 0
 
    
    override func prepare() {
        super.prepare()
        
        self.lastUpdatedTimeKey = "MjRefreshHeaderLastUpdatedTimeKey"
        
        self.frame.size.height = 54
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        // 设置y值(当自己的高度发生改变了，肯定要重新调整Y值，所以放到placeSubviews方法中设置y值)
//        self.mj_y = - self.mj_h - self.ignoredScrollViewContentInsetTop;
        let h = self.frame.size.height
        self.frame.origin.y = 0 - h - self.ignoredScrollViewContentInsetTop
    }
    
    func resetInset() {
        if #available(iOS 11.0, *) {} else {
            if (self.window == nil) { return }
        }
        if self.scrollView == nil { return }
        
        var insetT = ((0 - self.scrollView!.ex_offsetY) > self.scrollViewOriginalInset.top) ? (0-self.scrollView!.ex_offsetY) : (self.scrollViewOriginalInset.top)
        insetT = (insetT > self.frame.size.height + self.scrollViewOriginalInset.top) ? (self.frame.size.height+self.scrollViewOriginalInset.top) : insetT
        
        self.scrollView?.setExInsetTop(insetT)
        self.insetTDelta = self.scrollViewOriginalInset.top - insetT
    }
    
    override func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(change: change)
        
        if self.state == .refreshing {
            self.resetInset()
            return
        }
        
        self.scrollViewOriginalInset = self.scrollView!.ex_inset
        
        let offsetY = self.scrollView!.ex_offsetY
        let happenOffsetY = -self.scrollViewOriginalInset.top
        
        if offsetY > happenOffsetY { return }
        
        let normal2pullingOffsetY = happenOffsetY - self.ex_h
        let pullingPercent = (happenOffsetY - offsetY) / self.ex_h
        
        if self.scrollView!.isDragging {
            self.pullingPercent = pullingPercent
            if self.state == .idle && offsetY < normal2pullingOffsetY {
                self.setState(.pulling)
            } else if self.state == .pulling && offsetY >= normal2pullingOffsetY {
                self.setState(.idle)
            }
        } else if self.state == .pulling {
            self.beginRefreshing()
        } else if pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }

    }

    
    override func setState(_ state: RefreshState) {
        
        let oldState = self.state
        if oldState == state {return}
        super.setState(state)
        self.state = state
    
        if state == .idle {
            if oldState != .refreshing { return }
            
            UserDefaults.standard.set(Date(), forKey: self.lastUpdatedTimeKey)
            UserDefaults.standard.synchronize()
            
            UIView.animate(withDuration: 0.2, animations: {
                self.scrollView?.setExInsetTop(self.scrollView!.ex_insetTop+self.insetTDelta)
                
                self.endRefreshingAnimateCompletionBlock?()
                
                if self.isAutomaticallyChangeAlpha {
                    self.alpha = 0.0
                }
            }) { (finished) in
                self.pullingPercent = 0.0
                self.endRefreshingCompletionBlock?()
            }
        } else if state == .refreshing {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.25, animations: {
                    if self.scrollView!.panGestureRecognizer.state != .cancelled {
                        let top = self.scrollViewOriginalInset.top + self.ex_h
                        self.scrollView?.setExInsetTop(top)
                        var offset = self.scrollView!.contentOffset
                        offset.y = -top
                        self.scrollView?.setContentOffset(offset, animated: false)
                    }
                }) { (finished) in
                    self.executeRefreshingCallback()
                }
            }
        }
    }
    
    
}

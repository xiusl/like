//
//  RefreshBackFooter.swift
//  Like
//
//  Created by xiusl on 2019/10/11.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit

class RefreshBackFooter: RefreshFooter {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        self.backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open var lastRefreshCount = 0
    open var lastBottomDelta: CGFloat = 0
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.scrollViewContentSizeDidChange(change: nil)
    }
    
    override func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(change: change)
        if self.state == .refreshing {return}
        if self.scrollView == nil { return }
        
        let scrollView = self.scrollView!
        self.scrollViewOriginalInset = scrollView.contentInset
        
        let currentOffsetY = scrollView.contentOffset.y
        let happenOffsetY = self.happenOffsetY()
        if currentOffsetY <= happenOffsetY { return }
        
        let pullingPercent = (currentOffsetY - happenOffsetY) / self.frame.size.height
        
        if self.state == .noMoreData {
            self.pullingPercent = pullingPercent
            return
        }
        
        if scrollView.isDragging {
            self.pullingPercent = pullingPercent
            
            let normal2pullingOffsetY = happenOffsetY + self.frame.size.height
            
            if self.state == .idle && currentOffsetY > normal2pullingOffsetY {
                self.setState(.pulling)// = .pulling
            } else if self.state == .pulling && currentOffsetY <= normal2pullingOffsetY {
                self.setState(.idle)//self.state = .idle
            }
        } else if self.state == .pulling {
            self.beginRefreshing()
        } else if pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }
    }
    
    override func scrollViewContentSizeDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentSizeDidChange(change: change)
        
        if self.scrollView == nil { return }
        let contentHeight = self.scrollView!.contentSize.height
        let scrollHeight = self.scrollView!.frame.size.height - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom
        
        let f = self.frame
        self.frame = CGRect(x: f.origin.x, y: max(contentHeight, scrollHeight), width: f.size.width, height: f.size.height)
    }
    
    override func scrollViewPanStateDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewPanStateDidChange(change: change)
    }
    
    
    override func setState(_ state: RefreshState) {
        
        let oldState = self.state
        if oldState == state {return}
        super.setState(state)
        self.state = state
        
        if self.scrollView == nil {return}
        let scrollView = self.scrollView!
        
        if state == .noMoreData || state == .idle {
            if oldState == .refreshing {
                UIView.animate(withDuration: 0.4, animations: {
                    
                    scrollView.contentInset.bottom = scrollView.contentInset.bottom - self.lastBottomDelta
                    
                }) { (complated) in
                    self.pullingPercent = 0.0
                }
            }
            
            let deltaH = self.heightForContentBreakView()
            if oldState == .refreshing && deltaH > 0 {
                scrollView.setExOffsetY(scrollView.ex_offsetY)
            }
        } else if state == .refreshing {
            
            UIView.animate(withDuration: 0.25, animations: {
                var bottom = self.frame.size.height + self.scrollViewOriginalInset.bottom
                let deltaH = self.heightForContentBreakView()
                if deltaH < 0 {
                    bottom -= deltaH
                }
                self.lastBottomDelta = bottom - scrollView.contentInset.bottom

                scrollView.contentInset.bottom = bottom
                scrollView.setExOffsetY(self.happenOffsetY()+self.ex_h)
            }) { (complated) in
                self.executeRefreshingCallback()
            }
        }
    }
    
    func heightForContentBreakView() -> CGFloat {
        if self.scrollView == nil {return 0}
        let scrollView = self.scrollView!
        let h = scrollView.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top
        return scrollView.contentSize.height - h
    }
    
    func happenOffsetY() -> CGFloat {
        let deltaH = self.heightForContentBreakView()
        if deltaH > 0 {
            return deltaH - self.scrollViewOriginalInset.top
        } else {
            return -self.scrollViewOriginalInset.top
        }
    }
}

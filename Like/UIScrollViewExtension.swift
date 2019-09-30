//
//  UIScrollViewEx.swift
//  Like
//
//  Created by xiusl on 2019/9/29.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit

//enum RefreshFooterState: Int {
//    case idle
//    case pulling
//    case refreshing
//    case willRefresh
//    case noMoreData
//}
//class RefreshFooter222: UIView {
//    
//    weak var scrollView: UIScrollView?
//    weak var pan: UIPanGestureRecognizer?
//    var _state: RefreshFooterState = .idle
//    var state: RefreshFooterState {
//        set {
//            if _state == newValue {
//                return
//            }
//            self.setState(state: newValue)
////            _state = newValue
//            
//        }
//        get {
//            return _state
//        }
//    }
//    override func willMove(toSuperview newSuperview: UIView?) {
//        superview?.willMove(toSuperview: newSuperview)
//        
//        self.removeObservers()
//        
//        if newSuperview == nil {
//            return
//        }
//        if !newSuperview!.isKind(of: UIScrollView.self) {
//            return
//        }
//        
//        let sc: UIScrollView = newSuperview as! UIScrollView
//        self.scrollView = sc
//        let f = sc.frame
//        let t = sc.adjustedContentInset.top - sc.contentInset.top
//        self.frame = CGRect(x: f.origin.x, y: -t, width: f.size.width, height: 44)
//        self.addObservers()
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.backgroundColor = .lightGray
//        
//        
//        let f = self.frame
//        self.frame = CGRect(x: f.origin.x, y: f.origin.y, width: f.size.width, height: 44)
//        self.state = .idle
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        self.backgroundColor = .lightGray
//    }
//    
//    
//    func addObservers() {
//        self.scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [.old, .new], context: nil)
//        self.scrollView?.addObserver(self, forKeyPath: "contentSize", options: [.old, .new], context: nil)
//        
//        self.pan = self.scrollView?.panGestureRecognizer
//        self.pan?.addObserver(self, forKeyPath: "state", options: [.old, .new], context: nil)
//    }
//    
//    func removeObservers() {
//        self.superview?.removeObserver(self, forKeyPath: "contentOffset")
//        self.superview?.removeObserver(self, forKeyPath: "contentSize")
//        self.pan?.removeObserver(self, forKeyPath: "state")
//        self.pan = nil
//    }
//
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        
//        if !self.isUserInteractionEnabled {
//            return
//        }
//        
//        if keyPath == "contentSize" {
//            self.scrollViewContentSizeDidChange(change: change)
//        }
//        if self.isHidden {
//            return
//        }
//        
//        if keyPath == "contentOffset" {
//            self.scrollViewContentOffsetDidChange(change: change)
//        } else if keyPath == "state" {
//            self.scrollViewPanStateDidChange(change: change)
//        }
//        
//    }
//    var pullingPercent: CGFloat = 0.0
//    func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
//        if self.state == .refreshing {return}
//        if self.scrollView == nil { return }
//        
//        let scrollView = self.scrollView!
//        self.scrollViewOriginalInset = scrollView.contentInset
//        
//        let currentOffsetY = scrollView.contentOffset.y
//        let happenOffsetY = self.happenOffsetY()
//        if currentOffsetY <= happenOffsetY { return }
//        
//        let pullingPercent = (currentOffsetY - happenOffsetY) / self.frame.size.height
//        
//        if self.state == .noMoreData {
//            self.pullingPercent = pullingPercent
//            return
//        }
//        
//        if scrollView.isDragging {
//            self.pullingPercent = pullingPercent
//            
//            let normal2pullingOffsetY = happenOffsetY + self.frame.size.height
//            
//            if self.state == .idle && currentOffsetY > normal2pullingOffsetY {
//                self.state = .pulling
//            } else if self.state == .pulling && currentOffsetY <= normal2pullingOffsetY {
//                self.state = .idle
//            }
//        } else if self.state == .pulling {
//            self.beginRefreshing()
//        } else if pullingPercent < 1 {
//            self.pullingPercent = pullingPercent
//        }
//    }
//    var scrollViewOriginalInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    func scrollViewContentSizeDidChange(change: [NSKeyValueChangeKey : Any]?) {
//        if self.scrollView == nil { return }
//        let contentHeight = self.scrollView!.contentSize.height
//        let scrollHeight = self.scrollView!.frame.size.height - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom
//        
//        let f = self.frame
//        self.frame = CGRect(x: f.origin.x, y: max(contentHeight, scrollHeight), width: f.size.width, height: f.size.height)
//    }
//    
//    func scrollViewPanStateDidChange(change: [NSKeyValueChangeKey : Any]?) {
//        
//    }
//    
//    var lastBottomDelta:CGFloat = 0.0
//    func setState(state: RefreshFooterState) {
//        let oldState = self._state
//        if oldState == state {return}
//        if self.scrollView == nil {return}
//        let scrollView = self.scrollView!
//        if state == .noMoreData || state == .idle {
//            if oldState == .refreshing {
//                UIView.animate(withDuration: 0.4, animations: {
//                    let inset = scrollView.contentInset
//                    let o = scrollView.contentInset.bottom - self.lastBottomDelta
//                    scrollView.contentInset = UIEdgeInsets(top: inset.top, left: inset.left, bottom: o, right: inset.right)
//                    
//                }) { (complated) in
//                    self.pullingPercent = 0.0
//                }
//            }
//            
//            let deltaH = self.heightForContentBreakView()
//            if oldState == .refreshing && deltaH > 0 {
//                let offset = scrollView.contentOffset
//                scrollView.contentOffset = CGPoint(x: offset.x, y: offset.y)
//            }
//        } else if state == .refreshing {
//            
//            UIView.animate(withDuration: 0.25, animations: {
//                var bottom = self.frame.size.height + self.scrollViewOriginalInset.bottom
//                let deltaH = self.heightForContentBreakView()
//                if deltaH < 0 {
//                    bottom -= deltaH
//                }
//                self.lastBottomDelta = bottom - scrollView.contentInset.bottom
//                let inset = scrollView.contentInset
//                scrollView.contentInset = UIEdgeInsets(top: inset.top, left: inset.left, bottom: bottom, right: inset.right)
//                
//                
//                let offset = scrollView.contentOffset
//                scrollView.contentOffset = CGPoint(x: offset.x, y: self.happenOffsetY()+self.frame.size.height)
//                
//            }) { (complated) in
////                self.executeRefreshingCallback()
//            }
//        }
//    }
//    
//    func beginRefreshing() {
//        UIView.animate(withDuration: 0.25) {
//            self.alpha = 1.0
//        }
//        self.pullingPercent = 1.0
//        if self.window != nil {
////            self.state = .refreshing
//            self.setState(state: .refreshing)
//        } else {
//            if self.state != .refreshing {
//                self.setState(state: .willRefresh)
////                self.state = .willRefresh
//                self.setNeedsDisplay()
//            }
//        }
//    }
//    
//    
//    func heightForContentBreakView() -> CGFloat {
//        if self.scrollView == nil {return 0}
//        let scrollView = self.scrollView!
//        let h = scrollView.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top
//        return scrollView.contentSize.height - h
//    }
//    func happenOffsetY() -> CGFloat {
//        let deltaH = self.heightForContentBreakView()
//        if deltaH > 0 {
//            return deltaH - self.scrollViewOriginalInset.top
//        } else {
//            return -self.scrollViewOriginalInset.top
//        }
//    }
//}


var name_key = "name_key"
extension UIScrollView {
    
    var refFooter: RefreshBackFooter? {
        get {
            return objc_getAssociatedObject(self, &name_key) as? RefreshBackFooter
        }
        set {
//            [self.mj_header removeFromSuperview];
//            [self insertSubview:mj_header atIndex:0];
            self.refFooter?.removeFromSuperview()
            self.insertSubview(newValue!, at: 0)
            objc_setAssociatedObject(self, &name_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

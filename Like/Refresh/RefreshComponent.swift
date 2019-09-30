//
//  ViewController.swift
//  Like
//
//  Created by xiusl on 2019/9/29.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit
public enum RefreshState: Int {
    case idle
    case pulling
    case refreshing
    case willRefresh
    case noMoreData
}

class RefreshComponent: UIView {
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepare()
        self.setState(.idle)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.state == .willRefresh {
            self.setState(.refreshing)
        }
    }
    
    // MARK: - Property
    var scrollViewOriginalInset: UIEdgeInsets = UIEdgeInsets.zero
    weak var scrollView: UIScrollView?
    weak var pan: UIPanGestureRecognizer?
    
    open var isRefreshing: Bool {
        return self.state == .refreshing || self.state == .willRefresh
    }
    open var state: RefreshState = .idle
    
    open var pullingPercent: CGFloat = 0 {
        didSet {
            if self.isRefreshing { return }
            if self.isAutomaticallyChangeAlpha {
                self.alpha = self.pullingPercent;
            }
        }
    }
    open var isAutoChangeAlpha: Bool {
        set {
            self.isAutomaticallyChangeAlpha = newValue
        }
        get {
            return self.isAutomaticallyChangeAlpha
        }
    }
    open var isAutomaticallyChangeAlpha: Bool = false {
        didSet {
            if self.isRefreshing { return }
            if self.isAutomaticallyChangeAlpha {
                self.alpha = self.pullingPercent
            } else {
                self.alpha = 1.0
            }
        }
    }
    var lastBottomDelta: CGFloat = 0
    
    // MARK: Call Back
    open var refreshingBlock: (() -> ())?
    open weak var refreshingTarget: AnyObject?
    open var refreshingAction: Selector?
    open var completionBlock: (() -> ())?
    open var beginRefreshingCompletionBlock: (() -> ())?
    
    
    // MARK: - Open Method
    open func beginRefreshing() {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1.0
        }
        self.pullingPercent = 1.0
        if self.window != nil {
            self.setState(.refreshing)
        } else {
            if self.state != .refreshing {
                self.setState(.willRefresh)
                self.setNeedsDisplay()
            }
        }
    }
    
    open func endRefreshing() {
        self.setState(.idle)
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        self.placeSubviews()
        super.layoutSubviews()
    }
    override func willMove(toSuperview newSuperview: UIView?) {
        superview?.willMove(toSuperview: newSuperview)
        
        self.removeObservers()
        
        if newSuperview == nil { return }
        if !(newSuperview!.isKind(of: UIScrollView.self)) { return }
        
        let scrollView: UIScrollView = newSuperview as! UIScrollView
        self.scrollView = scrollView
        
        let scrollFrame = scrollView.frame
        let inset = scrollView.contentInset
        let oldFrame = self.frame
        self.frame = CGRect(x: -inset.left, y: self.ex_y, width: scrollFrame.size.width, height: oldFrame.size.height)
        
        self.addObservers()
    }

    open func prepare() {
        self.autoresizingMask = .flexibleWidth
        self.backgroundColor = .clear
    }
    
    open func placeSubviews() {}
    
    // MARK: - Observers
    open func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {}
    
    open func scrollViewContentSizeDidChange(change: [NSKeyValueChangeKey : Any]?) {}
    
    open func scrollViewPanStateDidChange(change: [NSKeyValueChangeKey : Any]?) {}
    
    func addObservers() {
        self.scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [.old, .new], context: nil)
        self.scrollView?.addObserver(self, forKeyPath: "contentSize", options: [.old, .new], context: nil)
        
        self.pan = self.scrollView?.panGestureRecognizer
        self.pan?.addObserver(self, forKeyPath: "state", options: [.old, .new], context: nil)
    }
    
    func removeObservers() {
        self.superview?.removeObserver(self, forKeyPath: "contentOffset")
        self.superview?.removeObserver(self, forKeyPath: "contentSize")
        self.pan?.removeObserver(self, forKeyPath: "state")
        self.pan = nil
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if !self.isUserInteractionEnabled { return }
        
        if keyPath == "contentSize" {
            self.scrollViewContentSizeDidChange(change: change)
        }
        
        if self.isHidden { return }
    
        if keyPath == "contentOffset" {
            self.scrollViewContentOffsetDidChange(change: change)
        } else if keyPath == "state" {
            self.scrollViewPanStateDidChange(change: change)
        }
    }
    
    // MARK: - Open Method
    func setState(_ state: RefreshState) {
        let oldState = self.state
        if oldState == state {return}
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
    
    func executeRefreshingCallback() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            
            self.refreshingBlock?()
            
            let _ = self.refreshingTarget?.perform(self.refreshingAction)
            
            self.beginRefreshingCompletionBlock?()
        }
    }
    
    open func addRefreshingTarget(_ target: AnyObject?, selector aSelector: Selector?) {
        self.refreshingTarget = target
        self.refreshingAction = aSelector
    }
}

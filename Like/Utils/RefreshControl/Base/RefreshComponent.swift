//
//  ViewController.swift
//  Like
//
//  Created by xiusl on 2019/9/29.
//  Copyright © 2019 likeeee. All rights reserved.
//
//  https://github.com/CoderMJLee/MJRefresh

import UIKit

/** 刷新控件的状态 */
public enum RefreshState: Int {
    
    /** 普通闲置状态 */
    case idle
    /** 松开就可以进行刷新的状态 */
    case pulling
    /** 正在刷新中的状态 */
    case refreshing
    /** 即将刷新的状态 */
    case willRefresh
    /** 所有数据加载完毕，没有更多的数据了 */
    case noMoreData  
}

/** 进入刷新状态的回调 */
typealias MjRefreshComponentRefreshingBlock = () -> ()
/** 开始刷新后的回调(进入刷新状态后的回调) */
typealias MjRefreshComponentBeginRefreshingCompletionBlock = () -> ()
/** 结束刷新后的回调 */
typealias MjRefreshComponentEndRefreshingCompletionBlock = () -> ()



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
    /** 记录scrollView刚开始的inset */
    var scrollViewOriginalInset: UIEdgeInsets = UIEdgeInsets.zero
    /** 父控件 */
    weak var scrollView: UIScrollView?
    weak var pan: UIPanGestureRecognizer?
    
    // MARK: - 刷新回调
    /** 正在刷新的回调 */
    open var refreshingBlock: MjRefreshComponentRefreshingBlock?
    /** 设置回调对象和回调方法 */
    open func setRefreshingTarget(_ target: AnyObject?, selector aSelector: Selector?) {
        self.refreshingTarget = target
        self.refreshingAction = aSelector
    }
    /** 回调对象 */
    open weak var refreshingTarget: AnyObject?
    /** 回调方法 */
    open var refreshingAction: Selector?
    
    
    // MARK: - 刷新状态控制
    /** 进入刷新状态 */
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
    open func beginRefreshing(completionBlock: @escaping () -> ()) {
        self.beginRefreshingCompletionBlock = completionBlock
        self.beginRefreshing()
    }
    /** 开始刷新后的回调(进入刷新状态后的回调) */
    open var beginRefreshingCompletionBlock: MjRefreshComponentBeginRefreshingCompletionBlock?
    /** 带动画的结束刷新的回调 */
    open var endRefreshingAnimateCompletionBlock: MjRefreshComponentEndRefreshingCompletionBlock?
    /** 结束刷新的回调 */
    open var endRefreshingCompletionBlock: MjRefreshComponentEndRefreshingCompletionBlock?
//    open var completionBlock: (() -> ())?
    
    /** 结束刷新状态 */
    open func endRefreshing() {
        self.setState(.idle)
    }
    open func endRefreshing(completionBlock: @escaping () -> ()) {
        self.endRefreshingCompletionBlock = completionBlock
        self.endRefreshing()
    }
    
    /** 是否正在刷新 */
    open var isRefreshing: Bool {
        return self.state == .refreshing || self.state == .willRefresh
    }
    /** 刷新状态 一般交给子类内部实现 */
    open var state: RefreshState = .idle
    
    
    // MARK: - 其他
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

    
    // MARK: - 交给子类去实现
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
        self.state = state

        DispatchQueue.main.async {
            self.setNeedsLayout()
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


extension UILabel {
    class func mjLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = UIColor(red: 90/255.0, green: 90/255.0, blue: 90/255.0, alpha: 1.0)
        label.autoresizingMask = .flexibleWidth
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }
    
    func mjTextWidth() -> CGFloat {
        var stringWidth: CGFloat = 0
        let size = CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))
        if (self.text?.count ?? 0) > 0 {
            let s = NSString(string: self.text ?? "")
            stringWidth = s.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: self.font ??  UIFont.systemFont(ofSize: 14, weight: .bold)], context: nil).size.width
        }
        return stringWidth
    }
}

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
    
    
    override func prepare() {
        super.prepare()
        
        let f = self.frame
        self.frame = CGRect(x: f.origin.x, y: f.origin.y, width: f.size.width, height: 44)
    }

}

class RefreshBackFooter: RefreshFooter {
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = .lightGray
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
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
    

    
    
}

class RefreshAutoNormalFooter: RefreshBackFooter {
        override init(frame: CGRect) {
            super.init(frame: frame)
    //        self.backgroundColor = .lightGray
            self.addSubview(self.loadingView)
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
    override func placeSubviews() {
        super.placeSubviews()
        
        if self.loadingView.constraints.count > 0 { return }
        
        let loadingCenterX = self.frame.size.width * 0.5
        let loadingCenterY = self.frame.size.height * 0.5
        self.loadingView.center = CGPoint(x: loadingCenterX, y: loadingCenterY)
    }
    
    override func prepare() {
        super.prepare()
        self.loadingView.style = .gray
    }

    lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(style: .gray)
        
        return loadingView
    }()
    
    override func setState(_ state: RefreshState) {
        super.setState(state)
        
        if state == .noMoreData || state == .idle {
            self.loadingView.stopAnimating()
        } else if state == .refreshing {
            self.loadingView.startAnimating()
            self.refreshingBlock?()
        }
//        if (state == .noma || state == MJRefreshStateIdle) {
//            [self.loadingView stopAnimating];
//        } else if (state == MJRefreshStateRefreshing) {
//            [self.loadingView startAnimating];
//        }
    }
}

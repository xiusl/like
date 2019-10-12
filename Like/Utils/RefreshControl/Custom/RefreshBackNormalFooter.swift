//
//  RefreshBackNormalFooter.swift
//  Like
//
//  Created by xiusl on 2019/10/12.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit

class RefreshBackNormalFooter: RefreshBackStateFooter {
    open var arrowView:UIImageView?
    open var activityIndicatorViewStyle: UIActivityIndicatorView.Style = .gray {
        didSet {
            self.loadingView.style = self.activityIndicatorViewStyle
            self.setNeedsLayout()
        }
    }
    
    open lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(style: self.activityIndicatorViewStyle)
        loadingView.hidesWhenStopped = true
        return loadingView
    }()
    
    override func prepare() {
        super.prepare()
        if self.loadingView.superview == nil {
            self.addSubview(self.loadingView)
        }
        self.activityIndicatorViewStyle = .gray
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        var arrowCenterX = self.frame.size.width * 0.5;
        if !self.stateLabel.isHidden {
            arrowCenterX -= (self.labelLeftInset + self.stateLabel.mjTextWidth() * 0.5)
        }
        let arrowCenterY = self.frame.size.height * 0.5
        let arrowCenter = CGPoint(x: arrowCenterX, y: arrowCenterY)
        
        
        if self.arrowView?.constraints.count == 0 {
            self.arrowView?.frame.size = self.arrowView?.image?.size ?? CGSize.zero
            self.arrowView?.center = arrowCenter
        }
        
        if self.loadingView.constraints.count == 0 {
            self.loadingView.center = arrowCenter
        }
        
        self.loadingView.tintColor = self.stateLabel.textColor
    }

    override func setState(_ state: RefreshState) {
        
        let oldState = self.state
        if oldState == state {return}
        super.setState(state)
        self.state = state
    
        // 根据状态做事情
        if state == .idle {
            if oldState == .refreshing {
                self.arrowView?.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi))
                UIView.animate(withDuration: 0.2, animations: {
                    self.loadingView.alpha = 0.0
                }) { (finished) in
                    if self.state != .idle { return }
                    
                    self.loadingView.alpha = 1.0
                    self.loadingView.stopAnimating()
                    
                    self.arrowView?.isHidden = false
                }
            } else {
                self.arrowView?.isHidden = false
                self.loadingView.stopAnimating()
                UIView.animate(withDuration: 0.2) {
                    self.arrowView?.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi))
                }
            }
        } else if state == .pulling {
            self.arrowView?.isHidden = false
            self.loadingView.stopAnimating()
            UIView.animate(withDuration: 0.2) {
                self.arrowView?.transform = CGAffineTransform.identity
            }
        } else if state == .refreshing {
            self.arrowView?.isHidden = true
            self.loadingView.startAnimating()
        } else if state == .noMoreData {
            self.arrowView?.isHidden = true
            self.loadingView.startAnimating()
        }
    }
}

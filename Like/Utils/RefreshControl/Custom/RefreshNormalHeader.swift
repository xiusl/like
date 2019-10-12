//
//  RefreshNormalHeader.swift
//  Like
//
//  Created by xiusl on 2019/10/12.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit

class RefreshNormalHeader: RefreshStateHeader {
    open lazy var arrowView: UIImageView = {
        let arrowView = UIImageView()
        return arrowView
    }()

    open lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(style: self.activityIndicatorViewStyle)
        loadingView.hidesWhenStopped = true
        return loadingView
    }()
    
    open var activityIndicatorViewStyle: UIActivityIndicatorView.Style = .gray {
        didSet {
            self.loadingView.style = self.activityIndicatorViewStyle
            self.setNeedsLayout()
        }
    }
    
    override func prepare() {
        super.prepare()
        if self.loadingView.superview == nil {
            self.addSubview(self.loadingView)
        }
        self.activityIndicatorViewStyle = .gray
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        var arrowCenterX = self.frame.size.width * 0.5
        if !self.stateLabel.isHidden {
            let stateWidth = self.stateLabel.mjTextWidth()
            var timeWidth: CGFloat = 0
            if !self.lastUpdatedTimeLabel.isHidden {
                timeWidth = self.lastUpdatedTimeLabel.mjTextWidth()
            }
            let textWidth = max(timeWidth, stateWidth)
            arrowCenterX -= (textWidth * 0.5 + self.labelLeftInset)
        }
        let arrowCenterY = self.frame.size.height * 0.5
        let arrowCenter = CGPoint(x: arrowCenterX, y: arrowCenterY)
        
        if self.arrowView.constraints.count == 0 {
            self.arrowView.frame.size = self.arrowView.image?.size ?? CGSize.zero
            self.arrowView.center = arrowCenter
        }
        
        if self.loadingView.constraints.count == 0 {
            self.loadingView.center = arrowCenter
        }
        
        self.arrowView.tintColor = self.stateLabel.textColor
    }
    
    override func setState(_ state: RefreshState) {
        let oldState = self.state
         if oldState == state {return}
         super.setState(state)
         self.state = state
        
        if state == .idle {
            if oldState == .refreshing {
                self.arrowView.transform = CGAffineTransform.identity
                
                UIView .animate(withDuration: 0.4, animations: {
                    self.loadingView.alpha = 0
                }) { (finished) in
                    if self.state != .idle { return }
                    
                    self.loadingView.alpha = 1.0
                    self.loadingView.stopAnimating()
                    self.arrowView.isHidden = false
                }
            } else {
                self.loadingView.stopAnimating()
                self.arrowView.isHidden = false
                UIView.animate(withDuration: 0.2) {
                    self.arrowView.transform = CGAffineTransform.identity
                }
            }
        } else if state == .pulling {
            self.loadingView.stopAnimating()
            self.arrowView.isHidden = false
            UIView.animate(withDuration: 0.2) {
                self.arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi))
            }
        } else if state == .refreshing {
            self.loadingView.alpha = 1
            self.loadingView.startAnimating()
            self.arrowView.isHidden = true
        }
    }
}

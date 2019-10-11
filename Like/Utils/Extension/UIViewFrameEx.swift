//
//  ViewController.swift
//  Like
//
//  Created by xiusl on 2019/9/30.
//  Copyright © 2019 likeeee. All rights reserved.
//
//  https://github.com/CoderMJLee/MJRefresh

import UIKit

extension UIScrollView {
    open var ex_inset: UIEdgeInsets {
        if #available(iOS 11, *) {
            if self.contentInsetAdjustmentBehavior != .never {
                return self.adjustedContentInset
            }
        }
        return self.contentInset
    }
    
    open func setExInsetTop(_ top: CGFloat) {
        var inset = self.contentInset
        inset.top = top

        if #available(iOS 11, *) {
            if self.contentInsetAdjustmentBehavior != .never {
                inset.top -= (self.adjustedContentInset.top - self.contentInset.top);
            }
        }
        self.contentInset = inset
    }
    open var ex_insetTop: CGFloat {
        return self.ex_inset.top
    }
    
    open func setExInsetBottom(_ bottom: CGFloat) {
        var inset = self.contentInset
        inset.bottom = bottom

        if #available(iOS 11, *) {
            if self.contentInsetAdjustmentBehavior != .never {
                inset.bottom -= (self.adjustedContentInset.bottom - self.contentInset.bottom);
            }
        }
        self.contentInset = inset
    }
    open var ex_insetBottom: CGFloat {
        return self.ex_inset.bottom
    }
    
    open func setExInsetLeft(_ left: CGFloat) {
        var inset = self.contentInset
        inset.left = left

        if #available(iOS 11, *) {
            if self.contentInsetAdjustmentBehavior != .never {
                inset.left -= (self.adjustedContentInset.left - self.contentInset.left);
            }
        }
        self.contentInset = inset
    }
    open var ex_insetLeft: CGFloat {
        return self.ex_inset.left
    }
    
    open func setExInsetRight(_ right: CGFloat) {
        var inset = self.contentInset
        inset.right = right

        if #available(iOS 11, *) {
            if self.contentInsetAdjustmentBehavior != .never {
                inset.right -= (self.adjustedContentInset.right - self.contentInset.right);
            }
        }
        self.contentInset = inset
    }
    open var ex_insetRight: CGFloat {
        return self.ex_inset.right
    }
    
    open func setExOffsetX(_ x: CGFloat) {
        var offset = self.contentOffset
        offset.x = x
        self.contentOffset = offset
    }
    open var ex_offsetX: CGFloat {
        return self.contentOffset.x
    }
    
    open func setExOffsetY(_ y: CGFloat) {
        var offset = self.contentOffset
        offset.y = y
        self.contentOffset = offset
    }
    open var ex_offsetY: CGFloat {
        return self.contentOffset.y
    }
    
    open func setExContentSizeW(_ width: CGFloat) {
        var contentSize = self.contentSize
        contentSize.width = width
        self.contentSize = contentSize
    }
    open var ex_contentW: CGFloat {
        return self.contentSize.width
    }
    
    open func setExContentSizeH(_ height: CGFloat) {
        var contentSize = self.contentSize
        contentSize.height = height
        self.contentSize = contentSize
    }
    open var ex_contentH: CGFloat {
        return self.contentSize.height
    }
}

extension UIView {
    open var ex_x: CGFloat {
        return self.frame.origin.x
    }
    open var ex_y: CGFloat {
        return self.frame.origin.y
    }
    open var ex_w: CGFloat {
        return self.frame.size.width
    }
    open var ex_h: CGFloat {
        return self.frame.size.height
    }
    open var ex_size: CGSize {
        return self.frame.size
    }
    open var ex_origin: CGPoint {
        return self.frame.origin
    }
    
    open func setExX(_ x: CGFloat) {
        self.frame.origin.x = x
    }
    open func setExY(_ y: CGFloat) {
        self.frame.origin.y = y
    }
    open func setExWidth(_ width: CGFloat) {
        self.frame.size.width = width
    }
    open func setExHeight(_ height: CGFloat) {
        self.frame.size.height = height
    }
    open func setExSize(_ size: CGSize) {
        self.frame.size = size
    }
    open func setExOrigin(_ origin: CGPoint) {
        self.frame.origin = origin
    }
    
}

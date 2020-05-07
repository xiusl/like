//
//  StatusMoreView.swift
//  Like
//
//  Created by tmt on 2020/5/7.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit

class StatusMoreView: UIView {
    
    private var url: String?
    private var title: String?
    private var image: String?
    
    var actionHandle: (() -> ())?
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        self.alpha = 0
        self.backgroundColor = UIColor(white: 0, alpha: 0.3)
        self.frame = CGRect(x: 0, y: 0,
                            width: UIScreen.main.bounds.size.width,
                            height: UIScreen.main.bounds.size.height)
        
        self.isHidden = true
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        tapGest.delegate = self
        self.addGestureRecognizer(tapGest)
        
        self.addSubview(self.contentView)
        
        
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 20, width: ScreenWidth, height: 44)
        btn.setTitle("删除", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitleColor(UIColor(hex: 0x000000), for: .normal)
        btn.addTarget(self, action: #selector(actionButtonClick), for: .touchUpInside)
        self.contentView.addSubview(btn)
    }
    @objc private func backgroundTap() {
        self.dismiss()
    }
    
    @objc private func actionButtonClick() {
        self.actionHandle?()
        self.dismiss()
    }
    
    open func show() {
        if self.superview == nil {
            UIApplication.shared.keyWindow?.addSubview(self)
        }
        self.isHidden = false
        UIView.animate(withDuration: 0.25, animations: {
            let height: CGFloat = 200
            self.contentView.transform = CGAffineTransform(translationX: 0, y: 0 - height)
            
            self.alpha = 1.0
        }, completion: nil)
    }
    
    open func dismiss(remove: Bool = true) {
        UIView.animate(withDuration: 0.2, animations: {
            self.contentView.transform = .identity
            self.alpha = 0.0001
        }) { (finished) in
            self.isHidden = true
            if remove {
                self.removeFromSuperview()
            }
        }
    }
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        let screenH = self.bounds.size.height
        let height: CGFloat = 200
        let width = self.bounds.size.width
        contentView.frame = CGRect(x: 0, y: screenH, width: width, height: height)
        contentView.backgroundColor = .white
        return contentView
    }()
    
    
}

extension StatusMoreView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.contentView) ?? false {
            return false
        }
        return true
    }
}

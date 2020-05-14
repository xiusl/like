//
//  StatusMoreView.swift
//  Like
//
//  Created by tmt on 2020/5/7.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit

protocol StatusMoreViewDelegate {
    func statusMoreAction(shield: Int, indexPath: IndexPath?)
    func statusMoreAction(report: Int, indexPath: IndexPath?)
    func statusMoreAction(delete: Int, indexPath: IndexPath?)
}

class StatusMoreView: UIView {
    
    private var url: String?
    private var title: String?
    private var image: String?
    
    var delegate: StatusMoreViewDelegate?
    
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
        
        let bgV = UIImageView()
        bgV.frame = CGRect(x: 0, y: 44*3, width: ScreenWidth, height: 12)
        bgV.backgroundColor = .cF2F4F8
        contentView.addSubview(bgV)
        
        contentView.addSubview(shieldButton)
        contentView.addSubview(reportButton)
        contentView.addSubview(deleteButton)
        contentView.addSubview(cancelButton)

    }
    lazy var shieldButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 44)
        button.setTitle("屏蔽", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor(hex: 0x000000), for: .normal)
        button.addTarget(self, action: #selector(shieldButtonAction), for: .touchUpInside)
        
        let v = UIImageView()
        v.backgroundColor = .cF2F4F8
        v.frame = CGRect(x: 0, y: 43.5, width: ScreenWidth, height: 0.5)
        button.addSubview(v)
        
        return button
    }()
    
    
    var indexPath: IndexPath?
    
    @objc
    private func shieldButtonAction() {
        self.delegate?.statusMoreAction(shield: 1, indexPath: indexPath)
    }
    @objc
    private func reportButtonAction() {
        self.delegate?.statusMoreAction(report: 1, indexPath: indexPath)
        
    }
    @objc
    private func deleteButtonAction() {
        self.delegate?.statusMoreAction(delete: 1, indexPath: indexPath)
        
    }
    lazy var reportButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 44, width: ScreenWidth, height: 44)
        button.setTitle("举报", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor(hex: 0x000000), for: .normal)
        button.addTarget(self, action: #selector(reportButtonAction), for: .touchUpInside)
        let v = UIImageView()
        v.backgroundColor = .cF2F4F8
        v.frame = CGRect(x: 0, y: 43.5, width: ScreenWidth, height: 0.5)
        button.addSubview(v)
        return button
    }()
    lazy var deleteButton: UIButton = {
           let button = UIButton()
           button.frame = CGRect(x: 0, y: 44*2, width: ScreenWidth, height: 44)
           button.setTitle("删除", for: .normal)
           button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
           button.setTitleColor(UIColor(hex: 0x000000), for: .normal)
           button.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
        let v = UIImageView()
        v.backgroundColor = .cF2F4F8
        v.frame = CGRect(x: 0, y: 43.5, width: ScreenWidth, height: 0.5)
        button.addSubview(v)
           return button
       }()
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 44*3+12, width: ScreenWidth, height: 44)
        button.setTitle("取消", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor(hex: 0x000000), for: .normal)
        button.addTarget(self, action: #selector(backgroundTap), for: .touchUpInside)
        return button
    }()
    
    @objc
    private func backgroundTap() {
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

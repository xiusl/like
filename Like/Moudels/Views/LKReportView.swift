//
//  LKReportView.swift
//  Like
//
//  Created by tmt on 2020/5/14.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit

class LKReportView: UIView {

    var clickHandle: ((String) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open func show() {
        if self.superview == nil {
            UIApplication.shared.keyWindow?.addSubview(self)
        }
    }

    @objc
    open func dissmiss() {
        UIView.animate(withDuration: 0.1, animations: {
//            self.alpha = 0.00001
        }) { (finished) in
            self.removeFromSuperview()
        }
    }

    private func setupViews() {
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        self.frame = UIScreen.main.bounds
        self.alpha = 1;
        
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(dissmiss))
        tapGest.delegate = self
        self.addGestureRecognizer(tapGest)
        
        self.addSubview(self.contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(lineView)
        
        let arr = ["色情暴力", "封面反感", "内容质量差", "违法信息"]

        var t: CGFloat = 40;
        let h: CGFloat = 32;
        let w: CGFloat = 240;
        for title in arr {
            let button = UIButton()
            button.frame = CGRect(x: 0, y: t, width: w, height: h)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.blackText, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14)
            button.contentHorizontalAlignment = .left
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
            t += h
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            contentView.addSubview(button)
        }
        
        self.contentView.frame = CGRect(x: (ScreenWidth-240)/2.0, y: (ScreenHeight-t)/2.0, width: w, height: t)
    }
    
    @objc
    private func buttonAction(_ button: UIButton) {
        dissmiss()
        clickHandle?(button.currentTitle ?? "")
    }
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 4
        contentView.clipsToBounds = true
        return contentView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 240, height: 40)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.textColor = .blackText
        label.text = "举报"
        return label
    }()
    
    private lazy var lineView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .cF2F4F8
        view.frame = CGRect(x: 0, y: 39, width: 240, height: 1)
        return view
    }()
}

extension LKReportView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.contentView) ?? false {
            return false
        }
        return true
    }
}

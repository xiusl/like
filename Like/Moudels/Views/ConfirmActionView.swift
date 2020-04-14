//
//  ConfirmActionView.swift
//  Like
//
//  Created by xiusl on 2019/11/1.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit

class ConfirmActionView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @discardableResult
    open class func show(inView: UIView) -> ConfirmActionView {
        let view = ConfirmActionView(frame: inView.bounds)
        inView.addSubview(view)
        UIView.animate(withDuration: 0.2) {
            view.alpha = 1;
        };
        return view
    }
    open func dissmiss() {
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0.00001
        }) { (finished) in
            self.removeFromSuperview()
        }
    }

    private func setupViews() {
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        self.alpha = 0;
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.leftButton)
        
        self.contentView.frame = CGRect(x: 0, y: 200, width: 200, height: 100)
        self.leftButton.frame = CGRect(x: 0, y: 50, width: 100, height: 50)
    }
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        return contentView
    }()
    
    private lazy var leftButton: UIButton = {
        let leftButton = UIButton()
        leftButton.setTitle("取消", for: .normal)
        leftButton.setTitleColor(.gray, for: .normal)
        leftButton.addTarget(self, action: #selector(leftButtonClick), for: .touchUpInside)
        return leftButton
    }()
    
    @objc private func leftButtonClick() {
        self.dissmiss()
    }
}

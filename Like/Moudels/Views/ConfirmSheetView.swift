//
//  ConfirmSheetView.swift
//  Like
//
//  Created by xiusl on 2019/11/1.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit

class ConfirmSheetView: UIView {
    let rowHeight: CGFloat = 50

    typealias ActionHandle = (_ action: String) -> ()
    
    var callback: ActionHandle?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @discardableResult
    open class func show(inView: UIView) -> ConfirmSheetView {
        let view = ConfirmSheetView(frame: inView.bounds)
        inView.addSubview(view)
        UIView.animate(withDuration: 0.2) {
            view.alpha = 1;
        };
        return view
    }
    
    @discardableResult
    open class func showInWindow() -> ConfirmSheetView {
        let window = UIApplication.shared.keyWindow!
        let view = ConfirmSheetView(frame: window.bounds)
        window.addSubview(view)
        UIView.animate(withDuration: 0.2) {
            view.showAnimate()
            view.alpha = 1
        };
        return view
    }
        
    @discardableResult
    open class func showInWindow(actions: [String], title: String = "提示") -> ConfirmSheetView {
        let window = UIApplication.shared.keyWindow!
        let view = ConfirmSheetView(frame: window.bounds)
        view.setAction(actions: actions)
        view.titleLabel.text = title
        window.addSubview(view)
        UIView.animate(withDuration: 0.2) {
            view.showAnimate()
            view.alpha = 1
        };
        return view
    }
    
    open func dissmiss() {
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0.00001
            self.contentView.transform = .identity
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    private func showAnimate() {
        let h = self.contentView.bounds.size.height
        self.contentView.transform = CGAffineTransform(translationX: 0, y: -h)
    }
    
    private func setAction(actions: [String]) {
        var t: CGFloat = rowHeight
        for action in actions {
            let btn = UIButton()
            btn.frame = CGRect(x: 0, y: t, width: ScreenWidth, height: rowHeight)
            btn.setTitle(action, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            btn.setTitleColor(self.titleColor(title: action), for: .normal)
            btn.addTarget(self, action: #selector(actionButtonClick(_:)), for: .touchUpInside)
            self.contentView.addSubview(btn)
            t += rowHeight
        }
        let height :CGFloat = rowHeight * CGFloat(actions.count+2) + 10
        var h = height
        if StatusBarHeight > 20 {
            h += 34
        }
        self.lineView.frame = CGRect(x: 0, y: height-60, width: ScreenWidth, height: 10)
        self.leftButton.frame = CGRect(x: 0, y: height-50, width: ScreenWidth, height: 50)
        self.contentView.frame = CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: h)
    }

    private func setupViews() {
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        self.alpha = 0;
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.leftButton)
        self.contentView.addSubview(self.lineView)
    }
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        return contentView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: self.rowHeight)
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = .gray
        titleLabel.textAlignment = .center
        titleLabel.text = "提示"
        
        let lineView = UIImageView()
        lineView.backgroundColor = UIColor(hex: 0xF2F4F8)
        lineView.frame = CGRect(x: 0, y: self.rowHeight-1, width: ScreenWidth, height: 1)
        titleLabel.addSubview(lineView)
        
        return titleLabel
    }()
    
    private lazy var lineView: UIImageView = {
        let lineView = UIImageView()
        lineView.backgroundColor = UIColor(hex: 0xF2F4F8)
        return lineView
    }()
    
    private lazy var leftButton: UIButton = {
        let leftButton = UIButton()
        leftButton.setTitle("取消", for: .normal)
        leftButton.setTitleColor(.black, for: .normal)
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        leftButton.addTarget(self, action: #selector(leftButtonClick), for: .touchUpInside)
        return leftButton
    }()
    
    @objc private func leftButtonClick() {
        self.dissmiss()
    }
    
    @objc private func actionButtonClick(_ button: UIButton) {
        self.dissmiss()
        self.callback?(button.currentTitle ?? "")
    }
    
    private func titleColor(title: String) -> UIColor {
        let dict :[String: UInt64] = ["退出": 0xFF0000 , "删除": 0xFF0000]
        let hex = dict[title]!
        return UIColor(hex: hex)
    }
}

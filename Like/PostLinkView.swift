//
//  PostLinkView.swift
//  Like
//
//  Created by xiusl on 2019/10/14.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit

class PostLinkView: UIView, UIGestureRecognizerDelegate {
    
    typealias callback = (_ url: String) -> ()
    var confirmClickHandle: callback!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.textView)
        self.contentView.addSubview(self.okButton)
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(hide))
        tapGest.delegate = self
        self.addGestureRecognizer(tapGest)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.contentView) ?? false {
            return false
        }
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    func show() {
        self.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        UIView.animate(withDuration: 0.1) {
            self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
            UIApplication.shared.keyWindow?.addSubview(self)
        }
        self.textView.becomeFirstResponder()
    }
    
    @objc func hide() {
        self.endEditing(true)
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }) { (complated) in
            if complated {
                self.removeFromSuperview()
            }
        }
    }
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.frame = CGRect(x: (ScreenWidth-280)/2.0, y: 85+StatusBarHeight, width: 280, height: 202)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 6
        contentView.clipsToBounds = true
        return contentView
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 20, y: 20, width: 240, height: 20)
        titleLabel.font = UIFont.systemFontMedium(ofSize: 18)
        titleLabel.textColor = .blackText
        titleLabel.textAlignment = .center
        titleLabel.text = "Post Link"
        return titleLabel
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.frame = CGRect(x: 20, y: 50, width: 240, height: 80)
        textView.layer.cornerRadius = 2
        textView.layer.borderColor = UIColor.cF2F4F8.cgColor
        textView.layer.borderWidth = 1
        textView.clipsToBounds = true
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .blackText
        return textView
    }()
    
    lazy var okButton: UIButton = {
        let okButton = UIButton()
        okButton.frame = CGRect(x: 40, y: 150, width: 200, height: 32)
        okButton.setTitle("确定", for: .normal)
        okButton.setTitleColor(.white, for: .normal)
        okButton.titleLabel?.font = UIFont.systemFontMedium(ofSize: 16)
        okButton.layer.cornerRadius = 4
        okButton.clipsToBounds = true
        okButton.backgroundColor = .theme
        okButton.addTarget(self, action: #selector(okButtonClick), for: .touchUpInside)
        return okButton
    }()
    
    @objc func okButtonClick() {
        self.hide()
        self.confirmClickHandle(self.textView.text)
    }
}

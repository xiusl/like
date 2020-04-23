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
        
        self.setupViews()
        
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
        self.checkPasteBoard()
    }
    
    private func checkPasteBoard() {
        let paste = UIPasteboard.general.string
        if paste == nil { return }
        if paste!.hasPrefix("http") || paste!.hasPrefix("https") {
            self.textView.text = paste
        }
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
    
    func setupViews() {
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.textView)
        self.contentView.addSubview(self.okButton)
        self.contentView.addSubview(self.clearButton)
        self.contentView.addSubview(self.pasteButton)
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
        
        self.textView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(50)
            make.height.equalTo(120)
        }
        
        self.okButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.textView.snp.bottom).offset(8)
            make.height.equalTo(32)
            make.width.equalTo(240)
        }
        
        self.clearButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.textView)
            make.bottom.equalTo(self.textView)
            make.size.equalTo(CGSize(width: 50, height: 30))
        }
        
        self.pasteButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.textView)
            make.bottom.equalTo(self.textView)
            make.size.equalTo(CGSize(width: 50, height: 30))
        }
    }
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.frame = CGRect(x: 40, y: 85+StatusBarHeight, width: ScreenWidth-80, height: 220)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 6
        contentView.clipsToBounds = true
        return contentView
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFontMedium(ofSize: 18)
        titleLabel.textColor = .blackText
        titleLabel.textAlignment = .center
        titleLabel.text = "Post Link"
        return titleLabel
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 2
        textView.layer.borderColor = UIColor.cF2F4F8.cgColor
        textView.layer.borderWidth = 1
        textView.clipsToBounds = true
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .blackText
        return textView
    }()
    
    lazy var clearButton: UIButton = {
        let clearButton = UIButton()
        clearButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        clearButton.setTitle("清除", for: .normal)
        clearButton.setTitleColor(.blackText, for: .normal)
        clearButton.addTarget(self, action: #selector(clearButtonClick), for: .touchUpInside)
        return clearButton
    }()
    
    lazy var pasteButton: UIButton = {
        let pasteButton = UIButton()
        pasteButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        pasteButton.setTitle("粘贴", for: .normal)
        pasteButton.setTitleColor(.blackText, for: .normal)
        pasteButton.addTarget(self, action: #selector(pasteButtonClick), for: .touchUpInside)
        return pasteButton
    }()
    
    lazy var okButton: UIButton = {
        let okButton = UIButton()
        okButton.setTitle("确定", for: .normal)
        okButton.setTitleColor(.white, for: .normal)
        okButton.titleLabel?.font = UIFont.systemFontMedium(ofSize: 16)
        okButton.layer.cornerRadius = 4
        okButton.clipsToBounds = true
        okButton.backgroundColor = .theme
        okButton.addTarget(self, action: #selector(okButtonClick), for: .touchUpInside)
        return okButton
    }()
    
    @objc private func okButtonClick() {
        self.hide()
        self.confirmClickHandle(self.textView.text)
    }
    
    @objc private func clearButtonClick() {
        self.textView.text = ""
    }
    @objc private func pasteButtonClick() {
        self.checkPasteBoard()
    }
}

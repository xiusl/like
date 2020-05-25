//
//  UserDescEditViewController.swift
//  Like
//
//  Created by xiu on 2020/5/25.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit

fileprivate let DESC_MAX_COUNT = 30
class UserDescEditViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = "设置签名"
        view.backgroundColor = .cF2F4F8
        
        setupNavigationBar()
        
        view.addSubview(contentView)
        
        let bgView = UIView()
        bgView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: textView.bounds.size.height)
        bgView.backgroundColor = .white
        bgView.addSubview(textView)
        contentView.addSubview(bgView)
        textView.addSubview(charCountLabel)
        
        textView.becomeFirstResponder()
        guard let user = User.current else { return }
        textView.text = user.desc
        updateCountShow()
    }
    
    private func setupNavigationBar() {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("取消", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc
    private func closeAction() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    @objc
    private func saveAction() {
        guard let user = User.current else { return }
        let req = UserApiRequest.editUserDesc(id: user.id,
                                              desc: self.textView.text!)
        ApiManager.shared.request(request: req, success: { (result) in
            user.desc = self.textView.text
            let _ = user.save()
            NotificationCenter.default.post(name: NSNotification.Name("UserInfoEdited_noti"), object: nil)
            self.closeAction()
        }) { (error) in
            SLUtil.showTipView(tip: error)
        }
    }
    @objc
    func textChange(_ textField: UITextField) {
        guard let user = User.current else { return }
        guard let text = textField.text else { return }
        self.rightItem.isEnabled = text.count > 0 && text != user.name
    }
    
    
    lazy var contentView: UIScrollView = {
        let content = UIScrollView()
        content.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight-TopSafeHeight)
        content.contentSize = content.bounds.size
        content.alwaysBounceVertical = true
        if #available(iOS 11, *) {
            content.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        return content
    }()
    lazy var rightItem: UIBarButtonItem = {
        let saveButton = UIButton()
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        saveButton.setTitle("完成", for: .normal)
        saveButton.setTitleColor(.white    , for: .normal)
        saveButton.setTitleColor(.c999999, for: .disabled)
        saveButton.setBackgroundImage(UIImage(color: .theme), for: .normal)
        saveButton.setBackgroundImage(UIImage(color: .cF2F4F8), for: .disabled)
        saveButton.bounds = CGRect(x: 0, y: 0, width: 48, height: 28)
        saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        saveButton.isEnabled = false
        saveButton.layer.cornerRadius = 4
        saveButton.clipsToBounds = true
        
        let item = UIBarButtonItem(customView: saveButton)
        item.isEnabled = false
        return item
    }()
    private lazy var textView: UITextView = {
        let view = UITextView()
        view.font = .systemFont(ofSize: 16)
        view.frame = CGRect(x: 8, y: 0, width: ScreenWidth-16, height: 88)
        view.tintColor = .theme
        view.delegate = self
        return view
    }()
    private lazy var charCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .c999999
        label.textAlignment = .right
        label.frame = CGRect(x: ScreenWidth-30-16, y: 88-18, width: 30, height: 14)
        return label
    }()
}

extension UserDescEditViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text?.count ?? 0
        if count > DESC_MAX_COUNT {
            self.textView.text = String(textView.text?.prefix(DESC_MAX_COUNT) ?? "")
        }
        updateCountShow()
        rightItem.isEnabled = count > 0
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "" {
            return true
        }
        return range.location <= DESC_MAX_COUNT
    }
    
    private func updateCountShow() {
        let count = textView.text?.count ?? 0
        charCountLabel.text = "\(DESC_MAX_COUNT - count)"
    }
}

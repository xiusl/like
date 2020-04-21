//
//  UserNameViewController.swift
//  Like
//
//  Created by xiu on 2020/4/21.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit

class UserNameViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "设置名字"
        self.view.backgroundColor = .cF2F4F8
        
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("取消", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        let saveButton = UIButton()
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        saveButton.setTitle("完成", for: .normal)
//        saveButton.setTitle("wanw", for: .disabled)
        saveButton.setTitleColor(.white	, for: .normal)
        saveButton.setTitleColor(.c999999, for: .disabled)
        saveButton.setBackgroundImage(UIImage(color: .theme), for: .normal)
        saveButton.setBackgroundImage(UIImage(color: .cF2F4F8), for: .disabled)
        saveButton.bounds = CGRect(x: 0, y: 0, width: 48, height: 28)
        saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        saveButton.isEnabled = false
        saveButton.layer.cornerRadius = 4
        saveButton.clipsToBounds = true
        let item = UIBarButtonItem(customView: saveButton)
//        item.setTitleTextAttributes([.foregroundColor: UIColor(hex: 0xFF0000, alpha: 0.6)], for: .disabled)
//        item.setTitleTextAttributes([.foregroundColor: UIColor(hex: 0xFF0000, alpha: 1)], for: .normal)
//        item.setBackgroundImage(UIImage(color: .theme), for: .normal, barMetrics: .default)
//        item.setBackgroundImage(UIImage(color: UIColor(hex: 0x000000, alpha: 1)), for: .disabled, barMetrics: .default)
        item.isEnabled = false
        self.navigationItem.rightBarButtonItem = item
        self.rightItem = item
        
        let content = UIScrollView()
        content.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight-TopSafeHeight)
        content.contentSize = content.bounds.size
        content.alwaysBounceVertical = true
        self.view.addSubview(content)
        
        if #available(iOS 11, *) {
            content.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        
        let bgView = UIView()
        bgView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 48)
        bgView.backgroundColor = .white
        content.addSubview(bgView)
        
        let textField = UITextField()
        textField.frame = CGRect(x: 16, y: 0, width: ScreenWidth-32, height: 48)
        textField.addTarget(self, action: #selector(textChange(_:)), for: .editingChanged)
        textField.font = UIFont.systemFont(ofSize: 16)
        bgView.addSubview(textField)
        self.textField = textField
        
        textField.becomeFirstResponder()
        
        guard let user = User.current else { return }
        textField.text = user.name
    }
    var rightItem: UIBarButtonItem?
    var textField: UITextField?
    
    @objc private func closeAction() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    @objc private func saveAction() {
        guard let user = User.current else { return }
        let req = UserApiRequest.editUser(id: user.id, avatar: "", name: self.textField!.text!)
        ApiManager.shared.request(request: req, success: { (result) in
            user.name = self.textField!.text!
            let _ = user.save()
            NotificationCenter.default.post(name: NSNotification.Name("UserInfoEdited_noti"), object: nil)
            self.closeAction()
        }) { (error) in
            
        }
    }
    @objc func textChange(_ textField: UITextField) {
        guard let user = User.current else { return }
        guard let text = textField.text else { return }
        self.rightItem!.isEnabled = text.count > 0 && text != user.name
        
    }
}

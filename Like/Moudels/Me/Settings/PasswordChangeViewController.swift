//
//  PasswordChangeViewController.swift
//  Like
//
//  Created by tmt on 2020/5/14.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit
import SwiftyJSON

class PasswordChangeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "修改密码"
        view.addSubview(tableView)
        tableView.tableFooterView = footerView
        footerView.addSubview(confirmButton)
    }
    
    lazy var data: Array<Dictionary<String, String>> = {
        let data = [[
            "title": "旧密码", "key": "old_password", "placeholder": "请输入旧密码"
            ],[
                "title": "新密码", "key": "password", "placeholder": "请输入新密码"
            ],[
                "title": "确认密码", "key": "password2", "placeholder": "请确认密码"
            ]
        ]
        return data
    }()
    
    lazy var inputData: Dictionary<String, String> = [:]
    
    lazy var tableView: UITableView = {
        let frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        let tableView = UITableView(frame: frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .cF2F4F8
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    lazy var footerView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 52)
        return view
    }()
    lazy var confirmButton: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 16, y: 12, width: ScreenWidth-32, height: 40)
        btn.layer.cornerRadius = 4
        btn.titleLabel?.font = .systemFontMedium(ofSize: 14)
        btn.setTitle("确认", for: .normal)
        btn.setBackgroundImage(.imageWith(color: .theme), for: .normal)
        btn.setBackgroundImage(.imageWith(color: .themeDisable), for: .disabled)
        btn.isEnabled = false
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(confirmButtonAction), for: .touchUpInside)
        return btn
    }()
}

extension PasswordChangeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SLFormInputViewCell.create(tableView: tableView)
        
        let data = self.data[indexPath.row]
        cell.setupTitle(data["title"]!)
        cell.setupPlaceholder(data["placeholder"]!)
        cell.setupIsSecureTextEntry(true)
        
        let key = data["key"]!
        cell.valueChanged = { [weak self] value in
            guard let `self` = self else {
                return
            }
            self.setupDataValue(value, forKey: key)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func setupDataValue(_ value:String, forKey key: String) {
        inputData[key] = value
        confirmButton.isEnabled = verifyData()
    }
    
    private func verifyData() -> Bool {
        let keys = ["old_password", "password", "password2"]
        for key in keys {
            if !inputData.keys.contains(key) {
                return false
            }
            let value = inputData[key]!
            if value.count <= 0 {
                return false
            }
        }
        return true
    }

    @objc
    private func confirmButtonAction() {
        guard let user = User.current else {return}
        
        let password = inputData["password"]!
        let password2 = inputData["password2"]!
        let old_password = inputData["old_password"]!
        
        if password != password2 {
            showTipView(tip: "两次密码不一致")
            return
        }
        
        if password.count < 6 {
            showTipView(tip: "密码长度为6-12位")
            return
        }
        
        if password == old_password {
            showTipView(tip: "新密码不能和旧密码相同")
            return
        }
        
        
        let req = UserApiRequest.editUserPassword(id: user.id, password: password, old_password: old_password)
        SLUtil.showLoading(to: view)
        ApiManager.shared.request(request: req, success: { (data) in
            SLUtil.hideLoading(from: self.view)
            
            let json = JSON(data)
            user.token = json["token"].stringValue
            user.save()
            SLUtil.showMessage("修改成功")
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            SLUtil.hideLoading(from: self.view)
            SLUtil.showMessage(error)
        }
    }
}

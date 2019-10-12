//
//  PasswordLoginViewController.swift
//  Like
//
//  Created by xiusl on 2019/10/12.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit

class PasswordLoginViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.view.addSubview(self.logoView)
        self.view.addSubview(self.phoneView)
        self.view.addSubview(self.passwdView)
        self.view.addSubview(self.confirmButton)
        self.view.addSubview(self.loginFailureButton)
        self.view.addSubview(self.loginSMSButton)
    }
    

    lazy var logoView: UIImageView = {
        let logoView = UIImageView()
        logoView.frame = CGRect(x: (ScreenWidth-64)/2.0, y: TopSafeHeight+20, width: 64, height: 64)
        logoView.layer.cornerRadius = 24
        logoView.clipsToBounds = true
        logoView.image = UIImage(named: "logo")
        return logoView
    }()
    
    lazy var phoneView: AuthInputView = {
        let phoneView: AuthInputView = AuthInputView()
        phoneView.frame = CGRect(x: 0, y: 220, width: ScreenWidth, height: 60)
        phoneView.type = .phone
        phoneView.setupPlaceHolder(text: "LoginPhonePlaceholder".localized)
        phoneView.delegate = self
        phoneView.errorMessage = "请输入正确的手机号"
        return phoneView
    }()

    lazy var passwdView: AuthInputView = {
        let passwdView: AuthInputView = AuthInputView()
        passwdView.frame = CGRect(x: 0, y: 280, width: ScreenWidth, height: 60)
        passwdView.type = .password
        passwdView.setupPlaceHolder(text: "LoginPwdPlaceholder".localized)
        passwdView.delegate = self
        passwdView.errorMessage = "请输入6-12位密码"
        return passwdView
    }()

    lazy var confirmButton: UIButton = {
        let confirmButton: UIButton = UIButton()
        confirmButton.frame = CGRect(x: 24, y: 380, width: ScreenWidth-48, height: 46)
        confirmButton.setTitle("LoginButtonTitle".localized, for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFontMedium(ofSize: 16)
        confirmButton.setBackgroundImage(UIImage(named: "bg_enable"), for: .normal)
        confirmButton.setBackgroundImage(UIImage(named: "bg_disable"), for: .disabled)
        confirmButton.isEnabled = false
        confirmButton.layer.cornerRadius = 2
        confirmButton.clipsToBounds = true
        confirmButton.addTarget(self, action: #selector(confirmButtonClick), for: .touchUpInside)
        return confirmButton
    }()
    
    lazy var loginSMSButton: UIButton = {
        let loginSMSButton = UIButton()
        loginSMSButton.setTitle("LoginWithSMSTitle".localized, for: .normal)
        loginSMSButton.setTitleColor(.theme, for: .normal)
        loginSMSButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        loginSMSButton.titleLabel?.sizeToFit()
        let width = (loginSMSButton.titleLabel?.ex_w ?? 0)+4
        loginSMSButton.frame = CGRect(x: ScreenWidth-width-24, y: 426, width: width, height: 46)
        loginSMSButton.contentHorizontalAlignment = .right
        return loginSMSButton
    }()
    
    lazy var loginFailureButton: UIButton = {
        let loginFailureButton = UIButton()
        loginFailureButton.setTitle("LoginFailedTitle".localized, for: .normal)
        loginFailureButton.setTitleColor(.theme, for: .normal)
        loginFailureButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        loginFailureButton.titleLabel?.sizeToFit()
        let width = (loginFailureButton.titleLabel?.ex_w ?? 0)+4
        loginFailureButton.frame = CGRect(x: 24, y: 426, width: width, height: 46)
        loginFailureButton.contentHorizontalAlignment = .right
        return loginFailureButton
    }()
}

extension PasswordLoginViewController: AuthInputViewDelegate {
    func textFieldValueChanged(text: String) {
        
    }
    
    @objc func confirmButtonClick() {
        
    }
}

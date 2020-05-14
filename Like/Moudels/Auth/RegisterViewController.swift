//
//  RegisterViewController.swift
//  Like
//
//  Created by xiusl on 2019/10/14.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit
import SwiftyJSON

class RegisterViewController: BaseViewController {

    open var isLogin = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWith(color: .white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.phoneView)
        self.view.addSubview(self.codeView)
        self.codeView.addSubview(self.sendCodeBtn)
        self.view.addSubview(self.confirmButton)
        
        if !self.isLogin {
            self.view.addSubview(self.agreeView)
        }
        
        self.phoneView.textField.becomeFirstResponder()
    }
    lazy var phoneView: AuthInputView = {
        let phoneView: AuthInputView = AuthInputView()
        phoneView.frame = CGRect(x: 0, y: 120, width: ScreenWidth, height: 60)
        phoneView.type = .phone
        phoneView.setupPlaceHolder(text: "RegisterPhonePlaceholder".localized)
        phoneView.delegate = self
        phoneView.errorMessage = ""
        return phoneView
    }()
    
    lazy var codeView: AuthInputView = {
        let codeView: AuthInputView = AuthInputView()
        codeView.frame = CGRect(x: 0, y: 180, width: ScreenWidth, height: 60)
        codeView.type = .verifyCode
        codeView.setupPlaceHolder(text: "Confirmation Code".localized)
        codeView.delegate = self
        codeView.errorMessage = ""
        return codeView
    }()

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 0, y: 32, width: ScreenWidth, height: 32)
        titleLabel.font = UIFont.systemFontMedium(ofSize: 28)
        titleLabel.textColor = .blackText
        titleLabel.textAlignment = .center
        titleLabel.text = self.isLogin ? "VerifyCodeLogin".localized : "RegisterVcTitle".localized
        return titleLabel
    }()

    lazy var sendCodeBtn: UIButton = {
        let sendCodeBtn = UIButton()
        sendCodeBtn.setTitle("VerifyCode".localized, for: .normal)
        sendCodeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        sendCodeBtn.setTitleColor(.blackText, for: .normal)
        sendCodeBtn.frame = CGRect(x: ScreenWidth-80-24, y: 0, width: 80, height: 60)
        sendCodeBtn.addTarget(self, action: #selector(sendCodeBtnClick), for: .touchUpInside)
        return sendCodeBtn
    }()
    
    lazy var confirmButton: UIButton = {
        let confirmButton: UIButton = UIButton()
        confirmButton.frame = CGRect(x: 24, y: 260, width: ScreenWidth-48, height: 46)
        let title = self.isLogin ? "LoginButtonTitle".localized : "Login2RegisterTitle".localized
        confirmButton.setTitle(title, for: .normal)
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
    
    lazy var agreeView: UIView = {
        let agreeView = UIView()
        agreeView.frame = CGRect(x: 0, y: 326, width: ScreenWidth, height: 36);
        
        let font = UIFont.systemFont(ofSize: 12)
        
        var str = "注册即表示同意".localized
        
        let label = UILabel()
        label.text = str
        label.font = font
        label.textColor = .blackText
        label.sizeToFit()
        agreeView.addSubview(label)
        let labelW = label.bounds.size.width

        let button1 = UIButton()
        button1.titleLabel?.font  = font
        button1.setTitle("隐私政策".localized, for: .normal)
        button1.setTitleColor(.theme, for: .normal)
        button1.titleLabel?.sizeToFit()
        agreeView.addSubview(button1)
        let btn1W = button1.titleLabel!.bounds.size.width
        
        let label2 = UILabel()
        label2.text = "&"
        label2.font = font
        label2.textColor = .blackText
        label2.sizeToFit()
        agreeView.addSubview(label2)
        let label2W = label2.bounds.size.width
        
        let button2 = UIButton()
        button2.titleLabel?.font  = font
        button2.setTitle("使用协议".localized, for: .normal)
        button2.setTitleColor(.theme, for: .normal)
        button2.titleLabel?.sizeToFit()
        agreeView.addSubview(button2)
        let btn2W = button2.titleLabel!.bounds.size.width
        
        let w = labelW + label2W + btn1W + btn2W
        var left = (ScreenWidth - w) * 0.5
        
        label.frame = CGRect(x: left, y: 0, width: labelW, height: 36)
        
        left += labelW
        button1.frame = CGRect(x: left, y: 0, width: btn1W, height: 36)
        
        left += btn1W
        label2.frame = CGRect(x: left, y: 0, width: label2W, height: 36)
        
        left += label2W
        button2.frame = CGRect(x: left, y: 0, width: btn2W, height: 36)

        button1.addTarget(self, action: #selector(privacyButtonAction), for: .touchUpInside)
        button2.addTarget(self, action: #selector(usageButtonAction), for: .touchUpInside)
        
        return agreeView
    }()
    
    @objc
    private func privacyButtonAction() {
        let vc = WebViewController()
        vc.url = "https://ins.sleen.top/privacy"
        vc.title = "哩嗑隐私政策".localized
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func usageButtonAction() {
        let vc = WebViewController()
        vc.url = "https://ins.sleen.top/usage"
        vc.title = "哩嗑使用协议".localized
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func confirmButtonClick() {
        var phone = self.phoneView.textField.text ?? ""
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        phone = phone.trimmingCharacters(in: whitespace)
        if !(SLUtil.checkPhone(phone: phone)) {
            self.phoneView.isShowError = true
            return
        }

        self.confirmButton.startLoading()
        let code = self.codeView.textField.text ?? ""
        let request = UserApiRequest.resgiterOrLogin(phone: phone, code: code)
        ApiManager.shared.request(request: request, success: { (result) in
            self.confirmButton.endLoading()
            let u = User(fromJson: JSON(result))
            let _ = u.save()
            
            let vc = MainTabBarController()
            let keyWidow = UIApplication.shared.keyWindow
            keyWidow?.rootViewController = vc
        }) { (error) in
            self.confirmButton.endLoading()
            SLUtil.showMessage(error)
        }
    }
    
    @objc func sendCodeBtnClick() {
        if self.timerCount != 59 { return }
        var phone = self.phoneView.textField.text ?? ""
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        phone = phone.trimmingCharacters(in: whitespace)
        if !(SLUtil.checkPhone(phone: phone)) {
            self.phoneView.isShowError = true
            return
        }
        let request = UserApiRequest.getVerifyCode(key: phone)
        ApiManager.shared.request(request: request, success: { (result) in
            let data = JSON(result)
            if data["ok"].stringValue == "1" {
                SLUtil.showMessage("send ok")
                self.startTimer()
            }
        }) { (error) in
            SLUtil.showMessage(error)
        }
        
    }
    
    private var timer: Timer?
    private var timerCount = 59
    func startTimer() {
        self.sendCodeBtn.setTitle(String(format: "%zds", self.timerCount), for: .normal)
        self.timer = Timer(timeInterval: 1, target: self, selector: #selector(catdown), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer!, forMode: .common)
    }
    @objc func catdown() {
        self.timerCount -= 1
        if self.timerCount == 0 {
            self.timerCount = 59
            self.timer?.invalidate()
            self.timer = nil
            self.sendCodeBtn.setTitle("VerifyCode".localized, for: .normal)
        } else {
            self.sendCodeBtn.setTitle(String(format: "%zds", self.timerCount), for: .normal)
        }
    }
}

extension RegisterViewController: AuthInputViewDelegate {
    func textFieldValueChanged(text: String) {
        self.confirmButton.isEnabled = self.phoneView.textField.text?.count ?? 0 > 0 &&
            self.codeView.textField.text?.count ?? 0 > 0
    }
}

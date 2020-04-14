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
        
        var str = NSMutableAttributedString(string: "Agree to Privacy policy")

        str.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: NSMakeRange(0, str.length))
        str.addAttribute(.foregroundColor, value: UIColor.theme, range: NSMakeRange(9, str.length-9))
        var l = NSLocale.preferredLanguages.first ?? "zh"
        if l.starts(with: "zh") {
            str = NSMutableAttributedString(string: "注册即表示同意隐私协议")
            str.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: NSMakeRange(0, str.length))
            str.addAttribute(.foregroundColor, value: UIColor.theme, range: NSMakeRange(7, str.length-7))
        }
        
        let label = UILabel()
        label.attributedText = str
        label.textAlignment = .center
        label.sizeToFit()
        let w = label.bounds.size.width
        label.frame = CGRect(x: (ScreenWidth-w)*0.5, y: 0, width: w, height: 36);
        agreeView.addSubview(label)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(agreeViewTapAction))
        agreeView.addGestureRecognizer(tap)
        
        return agreeView
    }()
    
    @objc func agreeViewTapAction() {
        let vc = WebViewController()
        vc.url = "https://ins.sleen.top/privacy"
        vc.title = "隐私政策"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func confirmButtonClick() {
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

//
//  PasswordLoginViewController.swift
//  Like
//
//  Created by xiusl on 2019/10/12.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit
import SwiftyJSON
import LeanCloud

class PasswordLoginViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.view.addSubview(self.registerButton)
        self.view.addSubview(self.logoView)
        self.view.addSubview(self.phoneView)
        self.view.addSubview(self.passwdView)
        self.view.addSubview(self.confirmButton)
//        self.view.addSubview(self.loginFailureButton)
        self.view.addSubview(self.loginSMSButton)
    }
    

    lazy var logoView: UIImageView = {
        let logoView = UIImageView()
        logoView.frame = CGRect(x: (ScreenWidth-64)/2.0, y: TopSafeHeight+20, width: 64, height: 64)
        logoView.layer.cornerRadius = 8
        logoView.clipsToBounds = true
        logoView.image = UIImage(named: "logo")
        return logoView
    }()
    
    lazy var phoneView: AuthInputView = {
        let phoneView: AuthInputView = AuthInputView()
        let t = TopSafeHeight+20+64+16
        phoneView.frame = CGRect(x: 0, y: t, width: ScreenWidth, height: 60)
        phoneView.type = .phoneEmail
        phoneView.setupPlaceHolder(text: "LoginPhonePlaceholder".localized)
        phoneView.delegate = self
        phoneView.errorMessage = "LoginPhoneInputError".localized
        return phoneView
    }()

    lazy var passwdView: AuthInputView = {
        let passwdView: AuthInputView = AuthInputView()
        let t = TopSafeHeight+20+64+16+60
        passwdView.frame = CGRect(x: 0, y: t, width: ScreenWidth, height: 60)
        passwdView.type = .password
        passwdView.setupPlaceHolder(text: "LoginPwdPlaceholder".localized)
        passwdView.delegate = self
        passwdView.errorMessage = "LoginPwdInputError".localized
        return passwdView
    }()

    lazy var confirmButton: UIButton = {
        let confirmButton: UIButton = UIButton()
        let t = TopSafeHeight+20+64+16+60+55+50
        confirmButton.frame = CGRect(x: 24, y: t, width: ScreenWidth-48, height: 46)
        confirmButton.setTitle("LoginButtonTitle".localized, for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFontMedium(ofSize: 16)
        confirmButton.setBackgroundImage(UIImage(named: "bg_enable"), for: .normal)
        confirmButton.setBackgroundImage(UIImage(named: "bg_disable"), for: .disabled)
        confirmButton.isEnabled = false
        confirmButton.layer.cornerRadius = 4
        confirmButton.clipsToBounds = true
        confirmButton.addTarget(self, action: #selector(confirmButtonClick), for: .touchUpInside)
        return confirmButton
    }()
    
    lazy var loginSMSButton: UIButton = {
        let loginSMSButton = UIButton()
        loginSMSButton.setTitle("LoginWithSMSTitle".localized, for: .normal)
        loginSMSButton.setTitleColor(.blackText, for: .normal)
        loginSMSButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        loginSMSButton.titleLabel?.sizeToFit()
        let width = (loginSMSButton.titleLabel?.ex_w ?? 0)+4
        let t = TopSafeHeight+20+64+16+60+55
        loginSMSButton.frame = CGRect(x: ScreenWidth-width-24, y: t, width: width, height: 46)
        loginSMSButton.contentHorizontalAlignment = .right
        loginSMSButton.addTarget(self, action: #selector(loginSMSButtonClick), for: .touchUpInside)
        return loginSMSButton
    }()
    
    lazy var loginFailureButton: UIButton = {
        let loginFailureButton = UIButton()
        loginFailureButton.setTitle("LoginFailedTitle".localized, for: .normal)
        loginFailureButton.setTitleColor(.blackText, for: .normal)
        loginFailureButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        loginFailureButton.titleLabel?.sizeToFit()
        let width = (loginFailureButton.titleLabel?.ex_w ?? 0)+4
        loginFailureButton.frame = CGRect(x: 24, y: 426-40, width: width, height: 46)
        loginFailureButton.contentHorizontalAlignment = .left
        return loginFailureButton
    }()
    
    lazy var registerButton: UIButton = {
        let registerButton = UIButton()
        registerButton.setTitle("Login2RegisterTitle".localized, for: .normal)
        registerButton.setTitleColor(.blackText, for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        registerButton.titleLabel?.sizeToFit()
        let width = (registerButton.titleLabel?.ex_w ?? 0)+4
        registerButton.frame = CGRect(x: ScreenWidth-width-24, y: TopSafeHeight-46, width: width, height: 46)
        registerButton.contentHorizontalAlignment = .right
        registerButton.addTarget(self, action: #selector(registerButtonClick), for: .touchUpInside)
        return registerButton
    }()
    
    @objc func registerButtonClick() {
        let vc = RegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func loginSMSButtonClick() {
        let vc = RegisterViewController()
        vc.isLogin = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PasswordLoginViewController: AuthInputViewDelegate {
    func textFieldValueChanged(text: String) {
        self.confirmButton.isEnabled = self.phoneView.textField.text?.count ?? 0 > 0 &&
            self.passwdView.textField.text?.count ?? 0 > 0
    }
    
    @objc
    private func confirmButtonClick() {
        var phone = self.phoneView.textField.text ?? ""
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        phone = phone.trimmingCharacters(in: whitespace)
        if !(SLUtil.checkPhone(phone: phone) || SLUtil.checkEmail(email: phone)) {
            self.phoneView.isShowError = true
            return
        }
        var passwd = self.passwdView.textField.text ?? ""
        passwd = passwd.trimmingCharacters(in: whitespace)
        if !SLUtil.checkPassword(passwd: passwd) {
            self.passwdView.isShowError = true
            return
        }
        
        self.confirmButton.startLoading()
        
        ApiManager.shared.request(request: UserApiRequest.login(account: phone, password: passwd), success: { (result) in
            debugPrint(result)
            self.confirmButton.endLoading()
//            DispatchQueue.global().async {
                let u = User(fromJson: JSON(result))
                let _ = u.save()
//            }
            Configuration.UserOption.clientID.set(value: u.id ?? "")
            self.clientInitializing(isReopen: true)
            let vc = MainTabBarController()
            let keyWidow = UIApplication.shared.keyWindow
            keyWidow?.rootViewController = vc
            
        }) { (error) in
            debugPrint(error)
            SLUtil.showTipView(tip: error)
            self.confirmButton.endLoading()
        }
    }
    
    
    func clientInitializing(isReopen: Bool) {
        do {
            
            let clientID: String = Configuration.UserOption.clientID.stringValue ?? ""
            let tag: String? = (Configuration.UserOption.isTagEnabled.boolValue ? "mobile" : nil)
            let options: IMClient.Options = Configuration.UserOption.isLocalStorageEnabled.boolValue
                ? .default
                : { var dOptions = IMClient.Options.default; dOptions.remove(.usingLocalStorage); return dOptions }()
            
            let client = try IMClient(
                ID: clientID,
                tag: tag,
                options: options,
                delegate: Client.delegator,
                eventQueue: Client.queue
            )
            
            if options.contains(.usingLocalStorage) {
                try client.prepareLocalStorage { (result) in
                    Client.specificAssertion
                    switch result {
                    case .success:
                        do {
                            try client.getAndLoadStoredConversations(completion: { (result) in
                                Client.specificAssertion
                                switch result {
                                case .success(value: let storedConversations):
                                    var conversations: [IMConversation] = []
                                    var serviceConversations: [IMServiceConversation] = []
                                    for item in storedConversations {
                                        if type(of: item) == IMConversation.self {
                                            conversations.append(item)
                                        } else if let serviceItem = item as? IMServiceConversation {
                                            serviceConversations.append(serviceItem)
                                        }
                                    }
                                    self.open(
                                        client: client,
                                        isReopen: isReopen,
                                        storedConversations: (conversations.isEmpty ? nil : conversations),
                                        storedServiceConversations: (serviceConversations.isEmpty ? nil : serviceConversations)
                                    )
                                case .failure(error: let error):
                                    break
                                }
                            })
                        } catch {
                            
                        }
                    case .failure(error: let error):
                        break
                    }
                }
            } else {
                self.open(client: client, isReopen: isReopen)
            }
        } catch {
        }
    }
    
    func open(
        client: IMClient,
        isReopen: Bool,
        storedConversations: [IMConversation]? = nil,
        storedServiceConversations: [IMServiceConversation]? = nil)
    {
        let options: IMClient.SessionOpenOptions
        if let _ = client.tag {
            options = Configuration.UserOption.isAutoOpenEnabled.boolValue ? [] : [.forced]
        } else {
            options = .default
        }
        client.open(options: options, completion: { (result) in
            Client.specificAssertion
            
            switch result {
            case .success:
                mainQueueExecuting {
                    Client.current = client
                    Client.storedConversations = storedConversations
                    Client.storedServiceConversations = storedServiceConversations
                }
                break
            case .failure(error: let error):
                if error.code == 4111 {
                    Client.delegator.client(client, event: .sessionDidClose(error: error))
                }
            }
        })
        
    }
}

//
//  LkPwdLoginViewController.swift
//  Like
//
//  Created by szhd on 2021/12/25.
//  Copyright © 2021 likeeee. All rights reserved.
//

import UIKit

class LkPwdLoginViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
        phoneView.startInput()
    }
    deinit {
        print("LkSmsLoginViewController deinit")
    }
    
    func setupViews() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: navBackImage(), style: .plain, target: self, action: #selector(closeAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "验证码登录", style: .plain, target: self, action: #selector(closeAction))
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(
            [.font: UIFont.lkFont(ofSize: 14), .foregroundColor: UIColor.c121212.cgColor],
            for: .normal)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(
            [.font: UIFont.lkFont(ofSize: 14), .foregroundColor: UIColor.c121212.cgColor],
            for: .highlighted)
        
        view.addSubview(titleLabel)
        view.addSubview(phoneView)
        view.addSubview(passwordView)
        view.addSubview(protocolView)
        view.addSubview(confirmBtn)
        
        let lr = calc(30)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(calc(20))
            make.left.equalToSuperview().offset(lr)
        }
        phoneView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(lr)
            make.right.equalToSuperview().inset(lr)
            make.top.equalTo(titleLabel.snp.bottom).offset(calc(10))
            make.height.equalTo(calc(40))
        }
        passwordView.snp.makeConstraints { make in
            make.left.right.height.equalTo(phoneView)
            make.top.equalTo(phoneView.snp.bottom).offset(calc(10))
        }
        protocolView.snp.makeConstraints { make in
            make.left.equalTo(phoneView)
            make.top.equalTo(passwordView.snp.bottom).offset(calc(12))
        }
        confirmBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(lr)
            make.right.equalToSuperview().inset(lr)
            make.top.equalTo(protocolView.snp.bottom).offset(calc(30))
            make.height.equalTo(calc(40))
        }
        
        phoneView.valueChange = {[weak self] in
            guard let `self` = self else { return }
            self.updateConfirmButton()
        }
    }
    
    func updateConfirmButton() {
        confirmBtn.isEnabled = phoneView.isValid
    }
    
    @objc
    func closeAction() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc
    func confirmBtnAction() {
        confirmBtn.start()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            self.confirmBtn.end()
        }
    }

    let phoneView = LkLoginMobileInputView()
    let passwordView = LkLoginPwdInputView()
    let protocolView = LkLoginProtocolView()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .lkFont(ofSize: 16, weight: .medium)
        label.textColor = .c121212
        label.text = "手机号密码登录"
        return label
    }()
    lazy var confirmBtn: LkComfirmButton = {
        let btn = LkComfirmButton(title: "登录")
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(confirmBtnAction), for: .touchUpInside)
        return btn
    }()
}

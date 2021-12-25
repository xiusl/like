//
//  LkSmsLoginViewController.swift
//  Like
//
//  Created by szhd on 2021/12/25.
//  Copyright © 2021 likeeee. All rights reserved.
//

import UIKit

class LkSmsLoginViewController: BaseViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        phoneView.startInput()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
        
    }
    deinit {
        print("LkSmsLoginViewController deinit")
    }
    
    func setupViews() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: navCloseImage(), style: .plain, target: self, action: #selector(closeAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "密码登录", style: .plain, target: self, action: #selector(pwdLoginAction))
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(
            [.font: UIFont.lkFont(ofSize: 14), .foregroundColor: UIColor.c121212.cgColor],
            for: .normal)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(
            [.font: UIFont.lkFont(ofSize: 14), .foregroundColor: UIColor.c121212.cgColor],
            for: .highlighted)
        
        view.addSubview(titleLabel)
        view.addSubview(phoneView)
        view.addSubview(protocolView)
        view.addSubview(confirmBtn)
        view.addSubview(descLabel)
        
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
        protocolView.snp.makeConstraints { make in
            make.left.equalTo(phoneView)
            make.top.equalTo(phoneView.snp.bottom).offset(calc(12))
        }
        confirmBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(lr)
            make.right.equalToSuperview().inset(lr)
            make.top.equalTo(protocolView.snp.bottom).offset(calc(30))
            make.height.equalTo(calc(40))
        }
        descLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(lr)
            make.top.equalTo(confirmBtn.snp.bottom).offset(calc(10))
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
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    @objc
    func pwdLoginAction() {
        self.navigationController?.pushViewController(LkPwdLoginViewController(), animated: true)
    }
    @objc
    func confirmBtnAction() {
        confirmBtn.start()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            self.confirmBtn.end()
        }
    }

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .lkFont(ofSize: 16, weight: .medium)
        label.textColor = .c121212
        label.text = "登录探索更多..."
        return label
    }()
    lazy var phoneView: LkLoginMobileInputView = {
       return LkLoginMobileInputView()
    }()
    lazy var protocolView: LkLoginProtocolView = {
        return LkLoginProtocolView()
    }()
    lazy var confirmBtn: LkComfirmButton = {
        let btn = LkComfirmButton(title: "验证并登录")
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(confirmBtnAction), for: .touchUpInside)
        return btn
    }()
    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.font = .lkFont(ofSize: 12)
        label.textColor = .cBDBDBD
        label.text = "未注册手机号验证通过将自动注册"
        return label
    }()
}

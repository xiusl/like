//
//  FeedbackPostViewController.swift
//  Like
//
//  Created by tmt on 2020/4/24.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit

class FeedbackPostViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "意见反馈".localized
        self.setupViews()
        self.setupNavItems()
   }
    
    func setupViews() {
        self.view.backgroundColor = .cF2F4F8
        self.view.addSubview(self.textView)
        self.view.addSubview(self.placeholderLabel)
        self.view.addSubview(self.userTextField)
        self.view.addSubview(self.submitButton)
        
        textView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(12)
            make.height.equalTo(122)
        }
        placeholderLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(20)
        }
        userTextField.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(textView.snp.bottom).offset(12)
            make.height.equalTo(44)
        }
        submitButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(28)
            make.right.equalToSuperview().offset(-28)
            make.top.equalTo(userTextField.snp.bottom).offset(20)
            make.height.equalTo(42)
        }
    }
    
    func setupNavItems() {
        let item = self.barButtonItem("记录", target: self, action: #selector(recordAction))
        navigationItem.rightBarButtonItem = item
    }
    
    @objc func recordAction () {
        let vc = FeedbackListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    lazy var textView: UITextView = {
        let view = UITextView()
        view.font = .systemFont(ofSize: 16)
        view.textColor = .blackText
        view.backgroundColor = .white
        view.textContainerInset = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        view.tintColor = .theme
        view.delegate = self
        return view
    }()
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .c999999
        label.text = "你想说点啥？".localized
        return label
    }()
    
    lazy var userTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 16)
        textField.textColor = .blackText
        textField.tintColor = .theme
        textField.backgroundColor = .white
        let placeholderAttr = NSMutableAttributedString(string: "联系方式（选填）".localized,
            attributes: [.foregroundColor:UIColor.c999999, .font: UIFont.systemFont(ofSize: 16)])
        
        textField.attributedPlaceholder = placeholderAttr
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: 14, height: 44)
        textField.leftView = v
        textField.leftViewMode = .always
        textField.keyboardType = .emailAddress
        return textField
    }()

    let submitButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitle("提交".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .theme
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(submitButtonAction), for: .touchUpInside)
        return button
    }()
}

extension FeedbackPostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.text.count > 0
    }
    
    @objc func submitButtonAction() {
        let content = textView.text ?? ""
        let contact = userTextField.text ?? ""
        
        if content.count <= 0 {
            SLUtil.showMessage("你得说点啥才行~".localized)
            return
        }
        
        let req = AppApiRequest.createFeedback(conetnt: content, contact: contact)
        
        SLUtil.showLoading(to: view)
        ApiManager.shared.request(request: req, success: { (data) in
            self.clearText()
            SLUtil.showMessage("哩嗑已经收到了(╰_╯)".localized)
            SLUtil.hideLoading(from: self.view)
        }) { (error) in
            SLUtil.hideLoading(from: self.view)
            SLUtil.showMessage(error)
        }
    }
    
    private func clearText() {
        textView.text = ""
        userTextField.text = ""
        placeholderLabel.isHidden = textView.text.count > 0
    }
}

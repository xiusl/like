//
//  AuthPhoneInputView.swift
//  XiaoQinTong
//
//  Created by xiusl on 2019/9/16.
//  Copyright © 2019 yueyilan. All rights reserved.
//

import UIKit
import SnapKit

protocol AuthInputViewDelegate {
    func textFieldValueChanged(text: String)
}

public enum AuthInputViewType : Int {
    
    case phone
    case phoneEmail
    case password
    case verifyCode
}

class AuthInputView: UIView {
    var delegate: AuthInputViewDelegate?
    
    var type: AuthInputViewType = .phone {
        didSet {
            self.reLayoutWithType()
        }
    }
    
    var isShowError: Bool? {
        
        didSet {
            if isShowError ?? false {
                self.textField.textColor = UIColor(hex: 0xFA6400)
                self.lineView.backgroundColor = UIColor(hex: 0xFA6400)
                self.errorLabel.isHidden = false
            } else {
                self.textField.textColor = UIColor(hex: 0x333333)
                self.lineView.backgroundColor = UIColor(hex: 0xF3F3F3)
                self.errorLabel.isHidden = true
            }
        }
    }
    
    var errorMessage: String? {
        didSet {
            self.errorLabel.text = errorMessage ?? ""
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, type: AuthInputViewType) {
        super.init(frame: frame)
        self.setupViews()
        self.type = type
        self.reLayoutWithType()
    }
    
    func setupViews() {
        self.addSubview(self.textField)
        self.addSubview(self.eyeButton)
        self.addSubview(self.errorLabel)
        self.addSubview(self.lineView)
        
        self.textField.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(24)
            make.right.equalTo(self).offset(-24)
            make.height.equalTo(46)
        }
        
        self.lineView.snp.makeConstraints { (make) in
            make.top.equalTo(self.textField.snp.bottom)
            make.height.equalTo(1)
            make.left.right.equalTo(self.textField)
        }
        
        self.eyeButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.centerY.equalTo(self.textField)
            make.right.equalTo(self.textField)
        }
        
        self.errorLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.textField)
            make.top.equalTo(self.lineView.snp.bottom).offset(6)
            make.height.equalTo(20)
        }
        
    }
    
    func reLayoutWithType() {
        switch self.type {
        case .phone:
            textField.leftViewMode = .always
            textField.textAlignment = .left
            eyeButton.isHidden = true
            textField.isSecureTextEntry = false
            textField.keyboardType = .phonePad
        case .phoneEmail:
            textField.leftViewMode = .never
            textField.textAlignment = .left
            eyeButton.isHidden = true
            textField.isSecureTextEntry = false
            textField.keyboardType = .emailAddress
        case .password:
            textField.leftViewMode = .never
            textField.textAlignment = .left
            eyeButton.isHidden = false
            textField.isSecureTextEntry = true
            textField.keyboardType = .default
        case .verifyCode:
            textField.leftViewMode = .never
            textField.textAlignment = .left
            eyeButton.isHidden = true
            textField.isSecureTextEntry = false
            textField.keyboardType = .numberPad
//        default:
//            textField.leftViewMode = .never
        }
    }
    
    @objc func eyeButtonClick() {
        self.eyeButton.isSelected = !self.eyeButton.isSelected
        self.textField.isSecureTextEntry = !self.eyeButton.isSelected
    }
    
    @objc func textFieldValueChange() {
        self.delegate?.textFieldValueChanged(text: self.textField.text ?? "")
        
        if self.isShowError ?? false {
            self.isShowError = false
        }
    }
    
    public func setupPlaceHolder(text: String?) {
        let aStr = NSMutableAttributedString(string: text ?? "")
        aStr.addAttribute(.font, value: UIFont.systemFont(ofSize: 15), range: NSRange(location: 0, length: aStr.length))
        aStr.addAttribute(.foregroundColor, value: UIColor(hex: 0x999999), range: NSRange(location: 0, length: aStr.length))
        self.textField.attributedPlaceholder = aStr
    }
    
    lazy var textField: UITextField = {
        let textField: UITextField = UITextField()
        textField.textAlignment = .right
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.textColor = .blackText

        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        label.text = "+86"
        label.textColor = .blackText
        label.font = UIFont.systemFontMedium(ofSize: 18)
        
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        view.addSubview(label)
        textField.leftView = view
        
        textField.addTarget(self, action: #selector(textFieldValueChange), for: .editingChanged)
        return textField
    }()
    
    lazy var lineView: UIImageView = {
        let lineView: UIImageView = UIImageView()
        lineView.backgroundColor = UIColor(hex: 0xF3F3F3)
        return lineView
    }()
    
    lazy var eyeButton: UIButton = {
        let eyeButton: UIButton = UIButton()
        eyeButton.setImage(UIImage(named: "pwd_eye_n"), for: .normal)
        eyeButton.setImage(UIImage(named: ""), for: .highlighted)
        eyeButton.setImage(UIImage(named: "pwd_eye_s"), for: .selected)
        eyeButton.addTarget(self, action: #selector(eyeButtonClick), for: .touchUpInside)
        return eyeButton
    }()
    
    lazy var errorLabel: UILabel = {
        let errorLabel: UILabel = UILabel()
        errorLabel.font = UIFont.systemFontMedium(ofSize: 15)
        errorLabel.textColor = UIColor(hex: 0xFA6400)
        errorLabel.isHidden = true
        return errorLabel
    }()
    
}

class AuthPhoneInputView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    

}

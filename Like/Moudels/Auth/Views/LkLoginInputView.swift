//
//  LkLoginInputView.swift
//  Like
//
//  Created by szhd on 2021/12/25.
//  Copyright © 2021 likeeee. All rights reserved.
//

import UIKit

class LkLoginInputView: UIView {


}

class LkLoginMobileInputView: UIView, UITextFieldDelegate {
    
    private var previousTextFieldContent: String = ""
    private var previousSelection : UITextRange?
    
    public var value = ""
    public var valueChange: (() -> ())?
    public var isValid = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func startInput() {
        textField.becomeFirstResponder()
    }
    
    func setupViews() {
        backgroundColor = .cF2F4F8
        layer.cornerRadius = calc(4)
        
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        previousTextFieldContent = textField.text!
        previousSelection = textField.selectedTextRange
        return true
    }

    @objc
    func textFieldEditing(_ textfield: UITextField) {
        var targetCursorPosition = textfield.offset(from: textfield.beginningOfDocument, to: textfield.selectedTextRange!.start)
        let nStr = textfield.text!.replacingOccurrences(of: " ", with: "")
        let nStrLen = nStr.count
        
        value = nStr
        isValid = (nStrLen >= 11)
        valueChange?()
        if (nStrLen > 11) {
            textField.text = previousTextFieldContent
            textField.selectedTextRange = previousSelection
            
            return
        }
        // 处理空格
        targetCursorPosition -= (textfield.text!.count - nStr.count)
        
        var mStr = ""
        for i in 0 ..< nStrLen {
            if i==3 || i == 7 {
                mStr.append(" ")
                if i < targetCursorPosition {
                    targetCursorPosition += 1
                }
            }
            mStr.append(nStr[i])
        }
        
        textField.text = mStr
        let targetPostion = textField.position(from: textField.beginningOfDocument,
                                                       offset: targetCursorPosition)!
        textField.selectedTextRange = textField.textRange(from: targetPostion,
                                                                  to: targetPostion)
    }
    
    lazy var textField: UITextField = {
        let field = UITextField()
        field.font = .lkFont(ofSize: 14)
        field.tintColor = .c2196F3
        
        let attributes: [NSAttributedString.Key : Any] = [
            .font: field.font!,
            .foregroundColor: UIColor.cBDBDBD.cgColor]
        let attr = NSAttributedString(string: "请输入手机号",attributes: attributes)
        field.attributedPlaceholder = attr
        
        let tView = UIView()
        tView.bounds = CGRect(x: 0, y: 0, width: calc(12), height: calc(12))
        field.leftView = tView
        field.leftViewMode = .always
        
        field.clearButtonMode = .whileEditing
        field.keyboardType = .phonePad
        
        field.delegate = self
        field.addTarget(self, action: #selector(textFieldEditing(_:)), for: .editingChanged)
        
        return field
    }()
}

class LkLoginPwdInputView: UIView, UITextViewDelegate {
    public var value = ""
    public var valueChange: (() -> ())?
    public var isValid = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func startInput() {
        textField.becomeFirstResponder()
    }
    
    func setupViews() {
        backgroundColor = .cF2F4F8
        layer.cornerRadius = calc(4)
        
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    lazy var textField: UITextField = {
        let field = UITextField()
        field.font = .lkFont(ofSize: 14)
        field.tintColor = .c2196F3
        
        let attributes: [NSAttributedString.Key : Any] = [
            .font: field.font!,
            .foregroundColor: UIColor.cBDBDBD.cgColor]
        let attr = NSAttributedString(string: "请输入密码",attributes: attributes)
        field.attributedPlaceholder = attr
        
        let tView = UIView()
        tView.bounds = CGRect(x: 0, y: 0, width: calc(12), height: calc(12))
        field.leftView = tView
        field.leftViewMode = .always
        
        field.clearButtonMode = .whileEditing
        field.keyboardType = .default
        field.isSecureTextEntry = true
        
//        field.delegate = self
//        field.addTarget(self, action: #selector(textFieldEditing(_:)), for: .editingChanged)
        
        return field
    }()
}

class LkLoginProtocolView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let label = UILabel()
    let icon = UIImageView()
    var agree = false
    
    func setupViews() {
        addSubview(label)
        addSubview(icon)
        
        icon.image = UIImage(named: "agreement_n")
        
        
        let font = UIFont.lkFont(ofSize: 12)
        let color1 = UIColor.cBDBDBD.cgColor
        let color2 = UIColor.c2196F3.cgColor
        
        let attributes1: [NSAttributedString.Key : Any] = [.font: font,
                                                          .foregroundColor: color1]
        let attributes2: [NSAttributedString.Key : Any] = [.font: font,
                                                          .foregroundColor: color2]

        let attr = NSMutableAttributedString(string: "已阅读并同意 ", attributes: attributes1)
        let attr1 = NSAttributedString(string: "用户协议", attributes: attributes2)
        let attr2 = NSAttributedString(string: " 和 ", attributes: attributes1)
        let attr3 = NSAttributedString(string: "隐私政策", attributes: attributes2)
        attr.append(attr1)
        attr.append(attr2)
        attr.append(attr3)
        
        label.attributedText = attr
        
        label.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.left.equalTo(icon.snp.right).offset(calc(2))
        }
        icon.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(calc(12))
        }
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(labelTapAction(_:)))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGest)
        
        let tapGest2 = UITapGestureRecognizer(target: self, action: #selector(labelTapAction(_:)))
        icon.isUserInteractionEnabled = true
        icon.addGestureRecognizer(tapGest2)
    }
    
    func updateIcon() {
        let name = agree ? "agreement_s" : "agreement_n"
        icon.image = UIImage(named: name)
    }
    
    @objc
    func labelTapAction(_ tap: UITapGestureRecognizer) {
        if tap.didTapOnLabel(label, inRange: NSRange(location: 7, length: 4)) {
            print("点击了 用户协议")
        } else if tap.didTapOnLabel(label, inRange: NSRange(location: 14, length: 4)) {
            print("点击了 隐私政策")
        } else {
            agree = !agree
            updateIcon()
        }
    }
}

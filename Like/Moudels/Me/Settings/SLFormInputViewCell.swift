//
//  SLFormInputViewCell.swift
//  Like
//
//  Created by tmt on 2020/5/14.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit

class SLFormInputViewCell: UITableViewCell {
    
    var valueChanged: ((String) -> ())?

    class func create(tableView: UITableView) -> SLFormInputViewCell {
        let idf = NSStringFromClass(self)
        var cell: SLFormInputViewCell? = tableView.dequeueReusableCell(withIdentifier: idf) as? SLFormInputViewCell
        if cell == nil {
            cell = SLFormInputViewCell.init(style: .default, reuseIdentifier: idf)
        }
        return cell!
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupTitle(_ title: String) {
        titleLabel.text = title
    }
    func setupPlaceholder(_ placeholder: String) {
        textField.placeholder = placeholder
    }
    func setupIsSecureTextEntry(_ isSecureTextEntry: Bool) {
        textField.isSecureTextEntry = isSecureTextEntry
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(textField)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel.snp.right).offset(20)
            make.right.equalToSuperview().offset(-16)
            make.top.bottom.equalToSuperview()
        }
        
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .blackText
        return label
    }()
    
    private lazy var textField: UITextField = {
        let field = UITextField()
        field.font = .systemFont(ofSize: 14)
        field.textColor = .blackText;
        field.textAlignment = .right
        field.addTarget(self, action: #selector(textValueChange), for: .editingChanged)
        return field
    }()
    
    @objc
    private func textValueChange() {
        self.valueChanged?(textField.text ?? "")
    }
}

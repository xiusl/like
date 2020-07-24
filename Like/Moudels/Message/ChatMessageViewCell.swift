//
//  ChatMessageViewCell.swift
//  Like
//
//  Created by tmt on 2020/7/23.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit

class ChatMessageViewCell: UITableViewCell {

    class func create(tableView: UITableView) -> ChatMessageViewCell {
        let idf = NSStringFromClass(self)
        var cell: ChatMessageViewCell? = tableView.dequeueReusableCell(withIdentifier: idf) as? ChatMessageViewCell
        if cell == nil {
            cell = ChatMessageViewCell.init(style: .default, reuseIdentifier: idf)
        }
        return cell!
    }
    
    class func cellHeight() -> CGFloat {
        return 50.0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    private func setupViews() {
        contentView.addSubview(userNameLabel)
        contentView.addSubview(messageLabel)
        
        userNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(14)
            make.right.equalTo(self.contentView).offset(-14)
            make.top.equalTo(self.contentView).offset(8)
        }
        
        messageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(32)
            make.right.equalTo(self.contentView).offset(-80)
            make.top.equalTo(self.userNameLabel.snp.bottom).offset(10)
            make.bottom.equalTo(self.contentView).offset(-12)
        }
    }
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .theme
        return label
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
}

extension ChatMessageViewCell {
    public func setupUserName(_ name: String) {
        userNameLabel.text = name
    }
    public func setupMessageText(_ text: String, fromMe: Bool) {
        messageLabel.text = text
        messageLabel.textAlignment = fromMe ? .right : .left
        userNameLabel.textAlignment = fromMe ? .right : .left
    
        if (fromMe) {
            messageLabel.snp.updateConstraints { (make) in
                make.left.equalTo(self.contentView).offset(80)
                make.right.equalTo(self.contentView).offset(-32)
                make.top.equalTo(self.userNameLabel.snp.bottom).offset(10)
                make.bottom.equalTo(self.contentView).offset(-12)
            }
        } else {
            messageLabel.snp.updateConstraints { (make) in
                make.left.equalTo(self.contentView).offset(32)
                make.right.equalTo(self.contentView).offset(-80)
            }
        }
    }
    
}

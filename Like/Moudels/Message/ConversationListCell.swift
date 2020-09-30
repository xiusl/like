//
//  ConversationListCell.swift
//  Like
//
//  Created by xiu on 2020/7/23.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit

class ConversationListCell: UITableViewCell {

    class func create(tableView: UITableView) -> ConversationListCell {
        let idf = NSStringFromClass(self)
        var cell: ConversationListCell? = tableView.dequeueReusableCell(withIdentifier: idf) as? ConversationListCell
        if cell == nil {
            cell = ConversationListCell.init(style: .default, reuseIdentifier: idf)
        }
        return cell!
    }
    
    class func cellHeight() -> CGFloat {
        return 42.0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupViews()
        contentView.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    private func setupViews() {
        contentView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(12)
            make.right.equalTo(self.contentView).offset(-12)
            make.top.equalTo(self.contentView).offset(6)
            make.bottom.equalTo(self.contentView).offset(-6)
        }
        
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(messageLabel)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
    
    public func setupText(_ text: String) {
        messageLabel.text = text
    }
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()

    lazy var lineView: UIImageView = {
        let lineView = UIImageView()
        lineView.backgroundColor = .cF2F4F8
        return lineView
    }()
}

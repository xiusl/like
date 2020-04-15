//
//  MeTabTableViewCell.swift
//  Like
//
//  Created by xiusl on 2019/10/14.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit
import SnapKit

class MeTabTableViewCell: UITableViewCell {

    func setup(title: String, icon: String) {
        self.titleLabel.text = title
        self.iconView.image = UIImage(named: icon)
    }
    
    class func create(tableView: UITableView) -> MeTabTableViewCell {
        let idf = NSStringFromClass(self)
        var cell: MeTabTableViewCell? = tableView.dequeueReusableCell(withIdentifier: idf) as? MeTabTableViewCell
        if cell == nil {
            cell = MeTabTableViewCell.init(style: .default, reuseIdentifier: idf)
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
    
    func setupViews() {
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.iconView)
        self.contentView.addSubview(self.arrowView)
        self.contentView.addSubview(self.lineView)
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(16)
            make.centerY.equalTo(self.contentView)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(52)
            make.centerY.equalTo(self.contentView)
        }
        
        arrowView.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-16)
            make.size.equalTo(CGSize(width: 7, height: 13))
            make.centerY.equalTo(self.contentView)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(16)
            make.right.equalTo(self.contentView).offset(-16)
            make.bottom.equalTo(self.contentView)
            make.height.equalTo(1)
        }
    }
    
    lazy var titleLabel: UILabel = {
        let titleLabel: UILabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor(hex: 0x333333)
        return titleLabel
    }()
    
    lazy var iconView: UIImageView = {
        let iconView: UIImageView = UIImageView()
        return iconView
    }()
    
    lazy var arrowView: UIImageView = {
        let arrowView: UIImageView = UIImageView()
        arrowView.image = UIImage(named: "arrow")
        return arrowView
    }()
    
    lazy var lineView: UIImageView = {
        let lineView: UIImageView = UIImageView()
        lineView.backgroundColor = UIColor(hex: 0xF3F3F3)
        return lineView
    }()
}


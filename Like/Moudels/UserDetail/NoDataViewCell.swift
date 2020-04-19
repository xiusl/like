//
//  NoDataViewCell.swift
//  Like
//
//  Created by xiu on 2020/4/19.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit

class NoDataViewCell: UITableViewCell {

    class func create(tableView: UITableView) -> NoDataViewCell {
        let idf = NSStringFromClass(self)
        var cell: NoDataViewCell? = tableView.dequeueReusableCell(withIdentifier: idf) as? NoDataViewCell
        if cell == nil {
            cell = NoDataViewCell.init(style: .default, reuseIdentifier: idf)
        }
        return cell!
    }
    
    class func cellHeight() -> CGFloat {
        return 100.0
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
//        self.contentView.addSubview(self.iconView)
//
//        iconView.snp.makeConstraints { (make) in
//            make.left.equalTo(self.contentView).offset(16)
//            make.centerY.equalTo(self.contentView)
//            make.size.equalTo(CGSize(width: 20, height: 20))
//        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(60)
            make.centerX.equalTo(self.contentView)
        }
        
    }
    
    lazy var titleLabel: UILabel = {
        let titleLabel: UILabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor(hex: 0x333333)
        titleLabel.text = "没有数据"
        return titleLabel
    }()
    
    lazy var iconView: UIImageView = {
        let iconView: UIImageView = UIImageView()
        return iconView
    }()
    
}

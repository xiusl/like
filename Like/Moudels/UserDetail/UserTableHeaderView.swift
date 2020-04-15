//
//  UserTableHeaderView.swift
//  Like
//
//  Created by xiusl on 2019/10/14.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit
import Kingfisher
class UserTableHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(avatarView)
        self.addSubview(nameLabel)
        
        let v = UIImageView()
        v.backgroundColor = UIColor(hex: 0xF8F8F8)
        self.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(10)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open func setupAvatar(_ url: String) {
        self.avatarView.kf.setImage(with: URL(string: url)!)
    }
    open func setupName(_ name: String) {
        self.nameLabel.text = name
    }
    open func setupAvatarAlpha(_ alpha: CGFloat) {
        self.avatarView.alpha = alpha
    }
    
    private lazy var avatarView: UIImageView = {
        let avatarView = UIImageView()
        avatarView.frame = CGRect(x: 16, y: -24, width: 64, height: 64)
        avatarView.layer.cornerRadius = 32
        avatarView.clipsToBounds = true
        return avatarView
    }()

    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.frame = CGRect(x: 16, y: 48, width: ScreenWidth, height: 20)
        nameLabel.font = UIFont.systemFontMedium(ofSize: 16)
        nameLabel.textColor = .blackText
        return nameLabel
    }()
}

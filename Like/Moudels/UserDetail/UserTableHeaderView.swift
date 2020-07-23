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
    
    var followActionHandle: (() -> ())?
    var messgaeActionHandle: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(avatarView)
        addSubview(nameLabel)
        addSubview(descLabel)
        addSubview(followButton)
        addSubview(messageButton)
        
        let v = UIImageView()
        v.backgroundColor = UIColor(hex: 0xF8F8F8)
        self.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(10)
        }
        
        self.followButton.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-16)
            make.centerY.equalTo(self.nameLabel)
        }
        messageButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.followButton.snp.left).offset(-8)
            make.centerY.equalTo(self.nameLabel)
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
    open func setupDesc(_ desc: String) {
        self.descLabel.text = desc
        descLabel.sizeToFit()
        descLabel.frame = CGRect(x: 16, y: 48, width: ScreenWidth-32, height: descLabel.bounds.size.height)
    }
//    open func setupFollowed(_ followed: Bool) {
//        self.followButton.isSelected = followed
//    }
    open func setupFollowed(_ followed: Bool, isCurrUser: Bool = false) {
        if isCurrUser {
            self.followButton.setTitle("编辑", for: .normal)
        } else {
            self.followButton.isSelected = followed
        }
        self.messageButton.isHidden = isCurrUser
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
        nameLabel.frame = CGRect(x: 16+64+8, y: 10, width: ScreenWidth, height: 20)
        nameLabel.font = UIFont.systemFontMedium(ofSize: 16)
        nameLabel.textColor = .blackText
        return nameLabel
    }()
    
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .c999999
        label.numberOfLines = 2
        label.frame = CGRect(x: 16, y: 42, width: ScreenWidth-32, height: 0)
        return label
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitle("关注", for: .normal)
        button.setTitle("已关注", for: .selected)
        button.setTitleColor(.theme, for: .normal)
        button.addTarget(self, action: #selector(followButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var messageButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitle("私信", for: .normal)
        button.setTitleColor(.theme, for: .normal)
        button.addTarget(self, action: #selector(messageButtonAction), for: .touchUpInside)
        return button
    }()
    
    @objc
    private func followButtonAction() {
        self.followActionHandle?()
    }
    
    @objc
    private func messageButtonAction() {
        self.messgaeActionHandle?()
    }
}

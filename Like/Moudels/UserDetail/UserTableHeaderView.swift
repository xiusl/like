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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(avatarView)
        self.addSubview(nameLabel)
        self.addSubview(self.followButton)
        
        let v = UIImageView()
        v.backgroundColor = UIColor(hex: 0xF8F8F8)
        self.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(10)
        }
        
        self.followButton.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-16)
            make.top.equalTo(self).offset(10)
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
//    open func setupFollowed(_ followed: Bool) {
//        self.followButton.isSelected = followed
//    }
    open func setupFollowed(_ followed: Bool, isCurrUser: Bool = false) {
        if isCurrUser {
            self.followButton.setTitle("编辑", for: .normal)
        } else {
            self.followButton.isSelected = followed
        }
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
    
    private lazy var followButton: UIButton = {
        let button = UIButton()
        button.setTitle("关注", for: .normal)
        button.setTitle("已关注", for: .selected)
        button.setTitleColor(.theme, for: .normal)
        button.addTarget(self, action: #selector(followButtonAction), for: .touchUpInside)
        return button
    }()
    
    @objc private func followButtonAction() {
        self.followActionHandle?()
    }
}

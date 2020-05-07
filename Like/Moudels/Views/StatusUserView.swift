//
//  StatusUserView.swift
//  Like
//
//  Created by xiu on 2020/4/14.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit

protocol StatusUserViewData {
    func setupAvatar(_ avatar: String)
    func setupName(_ name: String)
}
class StatusUserView : UIView {
    
    public var userActionHandle: (() -> ())?
    public var moreActionHandle: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
        self.setupAction()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    lazy var avatarView: UIImageView = {
        let avatarView = UIImageView()
        avatarView.clipsToBounds = true
        return avatarView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        nameLabel.textColor = .blackText
        return nameLabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = .cF2F4F8
        return descLabel
    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "more"), for: .normal)
        return button
    }()
}
extension StatusUserView: StatusUserViewData {
    func setupAvatar(_ avatar: String) {
        self.avatarView.kf.setImage(with: URL(string: avatar))
    }
    func setupName(_ name: String) {
        self.nameLabel.text = name
    }
}
extension StatusUserView {
    func setupViews() {
        self.addSubview(self.avatarView)
        self.addSubview(self.nameLabel)
        self.addSubview(self.descLabel)
        self.addSubview(self.moreButton)
        
        
        self.avatarView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(16)
            make.size.equalTo(CGSize(width: 32, height: 32))
            make.top.equalTo(self).offset(6)
        }
        self.avatarView.layer.cornerRadius = 16
        
        self.nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.avatarView.snp.right).offset(8)
            make.centerY.equalTo(self.avatarView)
        }
        
        self.descLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameLabel)
            make.bottom.equalTo(self.avatarView)
        }
        self.moreButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-6)
            make.width.equalTo(36)
            make.height.equalTo(36)
            make.centerY.equalTo(self.nameLabel)
        }
    }
    
    func setupAction() {
        let tapG = UITapGestureRecognizer(target: self, action: #selector(userTapAction))
        self.avatarView.isUserInteractionEnabled = true
        self.avatarView.addGestureRecognizer(tapG)
        
        let tapG2 = UITapGestureRecognizer(target: self, action: #selector(userTapAction))
        self.nameLabel.isUserInteractionEnabled = true
        self.nameLabel.addGestureRecognizer(tapG2)
        
        self.moreButton.addTarget(self, action: #selector(moreButtonAction), for: .touchUpInside)
    }
    
    @objc func userTapAction() {
        self.userActionHandle?()
    }
    
    @objc func moreButtonAction() {
        self.moreActionHandle?()
    }
}


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
    func setupDesc(_ desc: String)
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
        nameLabel.font = .systemFont(ofSize: 12,
                                     weight: .medium)
        nameLabel.textColor = .blackText
        return nameLabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = .systemFont(ofSize: 10)
        descLabel.textColor = .c999999
        return descLabel
    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_more"),
                        for: .normal)
        return button
    }()
}
extension StatusUserView: StatusUserViewData {
    func setupAvatar(_ avatar: String) {
        avatarView.kf.setImage(with: URL(string: avatar))
    }
    func setupName(_ name: String) {
        nameLabel.text = name
    }
    func setupDesc(_ desc: String) {
        descLabel.text = desc
    }
}
extension StatusUserView {
    func setupViews() {
        self.addSubview(self.avatarView)
        self.addSubview(self.nameLabel)
        self.addSubview(self.descLabel)
        self.addSubview(self.moreButton)
        
        
        self.avatarView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.size.equalTo(CGSize(width: 28, height: 28))
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-6)
        }
        self.avatarView.layer.cornerRadius = 14
        
        self.nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.avatarView.snp.right).offset(8)
            make.top.equalTo(self.avatarView)
            make.height.equalTo(16)
        }
        self.descLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameLabel)
            make.height.equalTo(12)
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


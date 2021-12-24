//
//  PostBottomView.swift
//  Like
//
//  Created by szhd on 2021/12/23.
//  Copyright © 2021 likeeee. All rights reserved.
//

import UIKit
// func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int

@objc
protocol PostBottomViewDelegate : NSObjectProtocol {
    @objc optional func postBottomView(_ bottomView: PostBottomView, emojiOnClick button: UIButton)
    @objc optional func postBottomView(_ bottomView: PostBottomView, locationOnClick button: UIButton?)
}

class PostBottomView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var delegate: PostBottomViewDelegate?

    private func setupViews() {
        addSubview(self.locationView)
        addSubview(self.line)
        addSubview(self.photoBtn)
        addSubview(emojiBtn)
        addSubview(atBtn)
        addSubview(topicBtn)
        
        locationView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(30)
            make.top.equalToSuperview().offset(2)
        }
        line.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.centerY.equalToSuperview()
        }
        photoBtn.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview()
        }
        emojiBtn.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.left.equalTo(photoBtn.snp.right)
            make.centerY.equalTo(photoBtn)
        }
        atBtn.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.left.equalTo(emojiBtn.snp.right)
            make.centerY.equalTo(photoBtn)
        }
        topicBtn.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.left.equalTo(atBtn.snp.right)
            make.centerY.equalTo(photoBtn)
        }
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(locationTapAction))
        locationView.addGestureRecognizer(tapGest)
    }
    public func resetEmojiBtn() {
        emojiBtn.isSelected = false
    }
    public func setupLocation(_ location: String?) {
        if let `location` = location {
            locationView.setupName(location)
        } else {
            locationView.setupName("所在位置")
        }
    }
    
    private lazy var locationView: PostLocationView = {
        let view = PostLocationView()
        return view
    }()
    private lazy var line: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .cF2F4F8
        return view
    }()
    private lazy var photoBtn: UIButton = {
        let photoBtn = UIButton()
        photoBtn.setImage(UIImage(named: "post_add_photo"), for: .normal)
        return photoBtn
    }()
    private lazy var emojiBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "post_add_emoji"), for: .normal)
        btn.setImage(UIImage(named: "post_add_keyboard"), for: .selected)
        btn.addTarget(self, action: #selector(emojiBtnAction), for: .touchUpInside)
        return btn
    }()
    private lazy var atBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "post_add_at"), for: .normal)
        return btn
    }()
    private lazy var topicBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "post_add_jing"), for: .normal)
        return btn
    }()
}

extension PostBottomView {
    
    @objc
    private func emojiBtnAction() {
        emojiBtn.isSelected = !emojiBtn.isSelected
        delegate?.postBottomView?(self, emojiOnClick: emojiBtn)
    }
    
    @objc
    private func locationTapAction() {
        delegate?.postBottomView?(self, locationOnClick: nil)
    }
}

class PostLocationView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setupName(_ name: String){
        label.text = name
    }

    private func setupViews() {
        backgroundColor = .cF8F8F8
        layer.cornerRadius = 15
        clipsToBounds = true
        
        addSubview(icon)
        addSubview(label)
        icon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(8)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(10)
        }
    }
    
    private lazy var icon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "post_location")
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .c999999
        label.text = "所在位置"
        label.font = .systemFont(ofSize: 12)
        return label
    }()
}

//
//  PostPhotoSelectView.swift
//  Like
//
//  Created by tmt on 2020/4/27.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit

class PostPhotoView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var deleteButtonHandle: (() -> ())?
    
    func setupImage(_ image: UIImage) {
        self.imageView.image = image
    }
    func startUpload() {
        deleteButton.isHidden = true
        maskBgView.isHidden = false
        self.loading.startAnimating()
        UIView.animateKeyframes(withDuration: 0.15, delay: 0, options: .calculationModeLinear, animations: {
            self.maskBgView.alpha = 1
        }) { (finished) in
        }
    }
    func finshedUpload() {
        deleteButton.isHidden = false
        
        self.loading.stopAnimating()
        UIView.animateKeyframes(withDuration: 0.15, delay: 0, options: .calculationModeLinear, animations: {
            self.maskBgView.alpha = 0
        }) { (finished) in
            self.maskBgView.isHidden = true
        }
    }
    
    @objc private func deleteButtonAction() {
        self.deleteButtonHandle?()
    }
    
    private func setupViews() {
        self.addSubview(self.imageView)
        self.addSubview(self.maskBgView)
        self.addSubview(self.loading)
        self.addSubview(self.deleteButton)
        
        imageView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.top.equalToSuperview()
        }
        
        maskBgView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.top.equalToSuperview()
        }
        
        loading.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 32, height: 32))
            make.right.equalToSuperview().offset(2)
            make.top.equalToSuperview().offset(-2)
        }
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .cF2F4F8
        return imageView
    }()
    
    private lazy var loading: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.color = .white
        return view
    }()
    
    private lazy var maskBgView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .init(white: 0, alpha: 0.3)
        view.alpha = 0
        return view
    }()

    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "photo_delete"),
                        for: .normal)
        button.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
}

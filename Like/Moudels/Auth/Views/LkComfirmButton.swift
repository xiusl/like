//
//  LkComfirmButton.swift
//  Like
//
//  Created by szhd on 2021/12/25.
//  Copyright © 2021 likeeee. All rights reserved.
//

import UIKit

class LkComfirmButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
        setTitle(title, for: .normal)
    }
    
    public func start() {
        if (loadingView.superview == nil) {
            addSubview(loadingView)
            loadingView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalTo(titleLabel!.snp.left).offset(-6)
            }
        }
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = 2
        animation.repeatCount = Float(Int.max)
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        loadingView.layer.add(animation, forKey: "loading")
    }
    public func end() {
        loadingView.layer.removeAllAnimations()
        loadingView.animationRemove()
    }

    private func setupViews() {
        let image = UIImage(color: .c2196F3)
        let imageDisable = UIImage(color: .cBBDEFB)
        setBackgroundImage(image, for: .normal)
        setBackgroundImage(imageDisable, for: .disabled)
        
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .lkFont(ofSize: 14, weight: .medium)
        
        layer.cornerRadius = 4
        clipsToBounds = true
    }
    
    private lazy var loadingView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "btn_loading")
        return view
    }()
}

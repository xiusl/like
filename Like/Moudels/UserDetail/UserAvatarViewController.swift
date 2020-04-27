//
//  UserAvatarViewController.swift
//  Like
//
//  Created by xiu on 2020/4/21.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit

class UserAvatarViewController: BaseViewController {

    var url: String?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: .clear), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .black
    
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.text = "个人头像"
        label.textColor = .white
        self.navigationItem.titleView = label
        
        self.view.addSubview(self.imageView)
        
        self.imageView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.centerY.equalTo(self.view)
            make.height.equalTo(self.imageView.snp.width)
        }
        
        guard let url = self.url else {
            return
        }
        self.imageView.kf.setImage(with: URL(string: url))
        
        
        self.navigationItem.rightBarButtonItem = self.barButtonItem("更换", target: self, action: #selector(changeAction))
    }
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    @objc func changeAction() {
       let vc = LKPhotoPickerViewController(originalPhoto: true, needCrop: true)
       vc.modalPresentationStyle = .fullScreen
//       vc.lk_delegate = self
       self.present(vc, animated: true, completion: nil)
    }
}

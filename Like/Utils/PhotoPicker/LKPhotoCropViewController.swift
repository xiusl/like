//
//  LKPhotoCropViewController.swift
//  Like
//
//  Created by xiu on 2020/4/27.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit
import Photos

class LKPhotoCropViewController: UIViewController {

    var asster: LKAsset?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .black
        
        self.view.addSubview(self.cancelButton)
        self.view.addSubview(self.imageView)
        
        
        guard let assert = self.asster?.asset else { return }
        
        PHImageManager.default().requestImage(for: assert, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil) { (image, _) in
            self.imageView.image = image
            
            let s = image!.size
            
            let w = self.view.bounds.size.width - 32
            let h = w * s.height / s.width;
            
            self.imageView.bounds = CGRect(x: 0, y: 0, width: w, height: h)
            self.imageView.center = self.view.center
            
        }
    }
    

    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitle("取消", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 12, y: 200, width: 64, height: 40)
        button.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    
    @objc func cancelButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

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
        self.view.addSubview(self.cropView)
        
        
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
    
    lazy var cropView: PhotoCropView = {
        let w = self.view.bounds.size.width
        let h = self.view.bounds.size.height
        let frame = CGRect(x: 0, y: 0, width: w, height: h)
        let view = PhotoCropView(frame: frame)
        return view
    }()
    
    @objc func cancelButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

class PhotoCropView: UIView {
    private var topLeft: CGPoint = .zero
    private var topRight: CGPoint = .zero
    private var bottomLeft: CGPoint = .zero
    private var bottomRight: CGPoint = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let viewH = frame.size.height
        let viewW = frame.size.width
        
        self.backgroundColor = UIColor(hex: 0x000000, alpha: 0.3)
        
        let cropWH = viewW - 32
        let cropT = (viewH - cropWH) * 0.5
        
        topLeft = CGPoint(x: 16, y: cropT)
        topRight = CGPoint(x: viewW - 16, y: cropT)
        bottomLeft = CGPoint(x: 16, y: cropT + cropWH)
        bottomRight = CGPoint(x: viewW - 16, y: cropT + cropWH)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
//        let w = rect.size.width
//        let h = rect.size.height
        
        let x = self.topLeft.x
        let y = self.topLeft.y
        let wh = self.topRight.x - self.topLeft.x
        
        let f = CGRect(x: x, y: y, width: wh, height: wh)
        let path = UIBezierPath(rect: f)
        UIColor.white.set()
        path.lineWidth = 1
        path.stroke()
        
        UIColor.clear.set()
        path.fill(with: .clear, alpha: 0)
        
        let path2 = UIBezierPath()
        UIColor.white.set()
        path2.lineWidth = 2
        
        path2.move(to: CGPoint(x: self.topLeft.x+20, y: self.topLeft.y))
        path2.addLine(to: self.topLeft)
        path2.addLine(to: CGPoint(x: self.topLeft.x, y: self.topLeft.y+20))
        
        path2.move(to: CGPoint(x: self.topRight.x-20, y: self.topRight.y))
        path2.addLine(to: self.topRight)
        path2.addLine(to: CGPoint(x: self.topRight.x, y: self.topRight.y+20))
        
        path2.move(to: CGPoint(x: self.bottomLeft.x+20, y: self.bottomLeft.y))
        path2.addLine(to: self.bottomLeft)
        path2.addLine(to: CGPoint(x: self.bottomLeft.x, y: self.bottomLeft.y-20))

        path2.move(to: CGPoint(x: self.bottomRight.x, y: self.bottomRight.y-20))
        path2.addLine(to: self.bottomRight)
        path2.addLine(to: CGPoint(x: self.bottomRight.x-20, y: self.bottomRight.y))
        
        path2.stroke()
        
        let path3 = UIBezierPath()
        UIColor.white.set()
        path3.lineWidth = 1
    }
}

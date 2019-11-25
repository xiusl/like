//
//  PostStatusViewController.swift
//  Like
//
//  Created by xiusl on 2019/10/15.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit

class PostStatusViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "发布动态"
        self.view.addSubview(self.textView)
        self.view.addSubview(self.okButton)
        self.view.addSubview(self.photosView)
        self.view.addSubview(self.uploadButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    
        self.textView.becomeFirstResponder()
    }
    
    @objc func keyboardFrameChange(_ noti: Notification) {
        let userInfo = noti.userInfo as! Dictionary<String, Any>
        let keybordRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let endY = keybordRect.cgRectValue.origin.y
        if endY == ScreenHeight {
//            self.okButton.transform = CGAffineTransform.identity
        } else {
//            self.okButton.transform = CGAffineTransform.init(translationX: 0, y: -40)
        }
    }
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.frame = CGRect(x: 16, y: TopSafeHeight+16, width: ScreenWidth-32, height: 120)
//        textView.layer.cornerRadius = 2
//        textView.layer.borderColor = UIColor.cF2F4F8.cgColor
//        textView.layer.borderWidth = 1
//        textView.clipsToBounds = true
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .blackText
        return textView
    }()
    
    lazy var okButton: UIButton = {
        let okButton = UIButton()
        okButton.frame = CGRect(x: (ScreenWidth-200)/2.0, y: TopSafeHeight+150, width: 200, height: 32)
        okButton.setTitle("发布", for: .normal)
        okButton.setTitleColor(.white, for: .normal)
        okButton.titleLabel?.font = UIFont.systemFontMedium(ofSize: 16)
        okButton.layer.cornerRadius = 4
        okButton.clipsToBounds = true
        okButton.backgroundColor = .theme
        okButton.addTarget(self, action: #selector(okButtonClick), for: .touchUpInside)
        return okButton
    }()
    
    @objc func okButtonClick() {
        let request = StatusApiRequest.postStatus(content: self.textView.text)
        ApiManager.shared.request(request: request, success: { (result) in
            debugPrint(result)
            SLUtil.showMessage("发布成功")
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            debugPrint(error)
        }
    }
    
    lazy var uploadButton: UIButton = {
        let uploadButton = UIButton()
        uploadButton.frame = CGRect(x: 16, y: TopSafeHeight+136+20, width: 64, height: 64)
        uploadButton.setBackgroundImage(UIImage(named: "photo_upload"), for: .normal)
        uploadButton.addTarget(self, action: #selector(uploadButtonClick), for: .touchUpInside)
        return uploadButton
    }()
    
    @objc func uploadButtonClick() {
        let vc = LKPhotoPickerViewController(originalPhoto: true)
        vc.modalPresentationStyle = .fullScreen
        vc.lk_delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    lazy var photosView: UIView = {
       let photosView = UIView()
        photosView.frame = CGRect(x: 16, y: TopSafeHeight+136+20, width: ScreenWidth-32, height: 64)
        return photosView
    }()
}
extension PostStatusViewController: LKPhotoPickerViewControllerDelegate {
    func photoPickerViewController(controller: LKPhotoPickerViewController, selectPhotos: Array<LKAsset>) {
        
    }
    func photoPickerViewController(controller: LKPhotoPickerViewController, selectAssets: Array<LKAsset>, selectPhotos: Array<UIImage>) {
        print(selectPhotos)
        self.setupPhotos(photos: selectPhotos)
    }
    
    func setupPhotos(photos: Array<UIImage>) {
        
        if self.photosView.subviews.count > 0 {
            self.photosView.subviews.forEach({$0.removeFromSuperview()})
        }
        
        let w: CGFloat = (ScreenWidth-32-30) / 4.0
        let m: CGFloat = 10
        var l: CGFloat = 0
        var t: CGFloat = 0
        var i: CGFloat = 0
        for image in photos {
            let v = UIImageView()
            l = i * (w + m)
            if (l+w) > ScreenWidth-32 {
                l = 0
                t += (w+10)
                i = 0
            }
            v.frame = CGRect(x: l, y: t, width: w, height: w)
            v.image = image
            self.photosView.addSubview(v)
            i += 1
        }
        l = i * (w + m)
        if l > ScreenWidth-32 {
            l = 0
            t += (w+10)
        }
        self.uploadButton.frame = CGRect(x: l+16, y: TopSafeHeight+136+20+t, width: w, height: w)
        
    }
}

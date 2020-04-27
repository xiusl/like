//
//  PostStatusViewController.swift
//  Like
//
//  Created by xiusl on 2019/10/15.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
class PostStatusViewController: BaseViewController {

    var token: String = ""
    var imagesParam: Array<[String: Any]> = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "发布动态"
        self.setupViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    
        self.textView.becomeFirstResponder()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(okButtonClick))
        
        self.loadUploadToken()
    }
    
    
    private func setupViews() {
        self.view.addSubview(self.textView)
        self.view.addSubview(self.photosView)
        self.view.addSubview(self.uploadButton)
        //textView.frame = CGRect(x: 16, y: TopSafeHeight+16, width: ScreenWidth-32, height: 120)
        self.textView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(16)
            make.right.equalTo(self.view).offset(-16)
            make.height.equalTo(120)
            make.top.equalTo(self.view).offset(16)
        }
        
        // uploadButton.frame = CGRect(x: 16, y: TopSafeHeight+136+20, width: 64, height: 64)
        self.uploadButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.textView)
            make.top.equalTo(self.textView.snp.bottom).offset(20)
            make.size.equalTo((ScreenWidth-32-30) / 4.0)
        }
        // photosView.frame = CGRect(x: 16, y: TopSafeHeight+136+20, width: ScreenWidth-32, height: 64)
        self.photosView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(16)
            make.top.equalTo(self.textView.snp.bottom).offset(20)
            make.right.equalTo(self.view).offset(-16)
            make.height.equalTo((ScreenWidth-32-30) / 4.0)
        }
    }
    
    private func loadUploadToken() {
        DispatchQueue.global().async {
            ApiManager.shared.request(request: SettingApiRequest.qiniuToken(()), success: { (response) in
                let token = JSON(response).stringValue
                self.token = token
                debugPrint(token)
            }) { (error) in
                
            }
        }
    }
    @objc func keyboardFrameChange(_ noti: Notification) {
        let userInfo = noti.userInfo as! Dictionary<String, Any>
        let keybordRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let endY = keybordRect.cgRectValue.origin.y
        if endY == ScreenHeight {
        } else {
        }
    }
    
    lazy var textView: UITextView = {
        let textView = UITextView()
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
        let request = StatusApiRequest.postStatus(content: self.textView.text, images: self.imagesParam)
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
        uploadButton.setBackgroundImage(UIImage(named: "photo_upload"), for: .normal)
        uploadButton.addTarget(self, action: #selector(uploadButtonClick), for: .touchUpInside)
        return uploadButton
    }()
    
    @objc func uploadButtonClick() {
        let vc = LKPhotoPickerViewController(originalPhoto: true, maxCount: 1)
        vc.modalPresentationStyle = .fullScreen
        vc.lk_delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    lazy var photosView: UIView = {
       let photosView = UIView()
        
        return photosView
    }()
    
    var selectPhotos: Array<UIImage> = []
}
extension PostStatusViewController: LKPhotoPickerViewControllerDelegate {
    func photoPickerViewController(controller: LKPhotoPickerViewController, selectPhotos: Array<LKAsset>) {
        
    }
    func photoPickerViewController(controller: LKPhotoPickerViewController, selectAssets: Array<LKAsset>, selectPhotos: Array<UIImage>) {
        print(selectPhotos)
        self.setupPhotos(photos: selectPhotos)
        self.selectPhotos = selectPhotos
        
        var imgs: Array<[String: Any]> = []
        for _ in 0..<selectPhotos.count {
            imgs.append(["a":0])
        }
        
        for i in 0..<selectPhotos.count {
            let image = selectPhotos[i]
            let imv = self.photosView.subviews[i] as! PostPhotoView
            imv.startUpload()
            ApiManager.shared.uploadImage(image: image, token: self.token, success: { (resp) in
                let j = JSON(resp)
                let d = [
                    "width": j["w"].intValue,
                    "height": j["h"].intValue,
                    "url": j["key"].stringValue] as [String : Any]
                debugPrint(d)
                imgs[i] = d
                self.imagesParam = imgs
                imv.finshedUpload()
            }) { (error) in
//                SLUtil.showMessage(error)
                imv.finshedUpload()
            }
        }
        
    }
    
    func setupPhotos(photos: Array<UIImage>) {
        
        if self.photosView.subviews.count > 0 {
            self.photosView.subviews.forEach({$0.removeFromSuperview()})
        }
        
        let w: CGFloat = (ScreenWidth-32-30) / 4.0
        let m: CGFloat = 10
        var l: CGFloat = 0
        var t: CGFloat = 0
        var i: Int = 0
        for image in photos {
            let v = PostPhotoView()
            l = CGFloat(i) * (w + m)
            if (l+w) > ScreenWidth-32 {
                l = 0
                t += (w+10)
                i = 0
            }
            v.frame = CGRect(x: l, y: t, width: w, height: w)
            v.setupImage(image)
            self.photosView.addSubview(v)
            
            let idx = i
            v.deleteButtonHandle = { [weak self] in
                guard let `self` = self else { return }
                self.deletePhoto(idx)
            }
            i += 1
        }
        l = CGFloat(i) * (w + m)
        if l > ScreenWidth-32 {
            l = 0
            t += (w+10)
        }
        self.uploadButton.isHidden = photos.count > 0
//        self.uploadButton.frame = CGRect(x: l+16, y: TopSafeHeight+136+20+t, width: w, height: w)
        
    }
    private func deletePhoto(_ index: Int) {
        self.selectPhotos.remove(at: index)
        if self.imagesParam.count > index {
            self.imagesParam.remove(at: index)
        }
        self.setupPhotos(photos: self.selectPhotos)
        
    }
}

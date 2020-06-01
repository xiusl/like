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
import Photos


class PostStatusViewController: BaseViewController {
    var token: String = ""
    var imagesParam: Array<[String: Any]> = []
    var selectPhotos: Array<UIImage> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = "发布动态"
        view.backgroundColor = .cF2F4F8
        setupViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        self.textView.becomeFirstResponder()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(okButtonClick))
        
        loadUploadToken()
    }
    
    private func setupViews() {
        view.addSubview(contentView)
        contentView.addSubview(textView)
        contentView.addSubview(imagesView)
        imagesView.addSubview(uploadButton)
        view.addSubview(toolView)
    }
    
    lazy var contentView: UIScrollView = {
        let contentView = UIScrollView()
        let h = ScreenHeight - TopSafeHeight - 32
        contentView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: h)
        contentView.contentSize = contentView.bounds.size
        contentView.showsVerticalScrollIndicator = false
        if #available(iOS 11.0, *) {
            contentView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        contentView.alwaysBounceVertical = true
        return contentView
    }()
    
    lazy var textView: LKTextView = {
        let textView = LKTextView()
        textView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 148)
        textView.delegate = self
        textView.isScrollEnabled = false
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        let dict: Dictionary<NSAttributedString.Key, Any> = [
            .font: UIFont.systemFont(ofSize: 16),
            .paragraphStyle: style,
            .foregroundColor: UIColor.darkText
        ]
        textView.typingAttributes = dict
        textView.tintColor = .theme
        textView.textContainerInset = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        return textView
    }()
    
    lazy var imagesView: UIImageView = {
        let view = UIImageView()
        view.frame = CGRect(x: 12, y: 160, width: 88, height: 88)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    var keyboardHeight: CGFloat = 0
    
    lazy var toolView: UIView = {
        let toolView = UIView()
        toolView.frame = CGRect(x: 0, y: ScreenHeight-TopSafeHeight, width: ScreenWidth, height: 32)
        toolView.backgroundColor = .clear
        
        let btn = UIButton()
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.frame = CGRect(x: ScreenWidth-64, y: 0, width: 64, height: 32)
        btn.setTitle("完成", for: .normal)
        btn.setTitleColor(.theme, for: .normal)
        btn.addTarget(self, action: #selector(toolViewTap), for: .touchUpInside)
        toolView.addSubview(btn)
        
        
        return toolView
    }()
    
    lazy var uploadButton: UIButton = {
        let uploadButton = UIButton()
        uploadButton.setBackgroundImage(UIImage(named: "photo_upload"), for: .normal)
        uploadButton.addTarget(self, action: #selector(uploadButtonClick), for: .touchUpInside)
        uploadButton.frame = CGRect(x: 0, y: 0, width: 88, height: 88)
        return uploadButton
    }()
    
    
}
// MARK: - Evenet
extension PostStatusViewController {
    @objc
    private func okButtonClick() {
        let request = StatusApiRequest.postStatus(content: self.textView.text, images: self.imagesParam)
        ApiManager.shared.request(request: request, success: { (result) in
            debugPrint(result)
            SLUtil.showMessage("发布成功")
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            SLUtil.showTipView(tip: error)
        }
    }
    @objc
    func uploadButtonClick() {
        let vc = LKPhotoPickerViewController(originalPhoto: true, maxCount: 1)
        vc.modalPresentationStyle = .fullScreen
        vc.lk_delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc
    func toolViewTap() {
        self.view.endEditing(false)
        contentView.contentInset = .zero
    }
    
    @objc
    func keyboardFrameChange(_ noti: Notification) {
        let userInfo = noti.userInfo as! Dictionary<String, Any>
        let keybordRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let endY = keybordRect.cgRectValue.origin.y
        keyboardHeight = keybordRect.cgRectValue.size.height+32
        
        var f = toolView.frame
        f.origin.y = endY - 32 - TopSafeHeight
        toolView.frame = f
        toolView.isHidden = endY >= ScreenHeight
        
        
        let blankH = ScreenHeight - keyboardHeight - TopSafeHeight
        let h = textView.bounds.size.height + 100
        if h > blankH {
            let inset = min(keyboardHeight-32, h - blankH)
            contentView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: inset, right: 0)
            
            contentView.setContentOffset(CGPoint(x: 0, y:h - blankH), animated: false)
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
}

// MARK: - TextViewDelegate
extension PostStatusViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let calcSize = textView.sizeThatFits(CGSize(width: ScreenWidth, height: CGFloat(MAXFLOAT)))
        
        
        var h = max(calcSize.height, 148)
        
        var frame = textView.frame
        frame.size.height = h
        textView.frame = frame
        
        var imageFrame = imagesView.frame
        imageFrame.origin.y = h + 12
        imagesView.frame = imageFrame
        
        h += 100
        
        if h > contentView.bounds.size.height {
            contentView.contentSize = CGSize(width: ScreenWidth, height: h)
        }
        
        let blankH = ScreenHeight - keyboardHeight - TopSafeHeight
        if h > blankH {
            let inset = min(keyboardHeight-32, h - blankH)
            contentView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: inset, right: 0)
            
            contentView.setContentOffset(CGPoint(x: 0, y:h - blankH), animated: false)
        }
        
    }
}

// MARK: - PhotoPicker
extension PostStatusViewController: LKPhotoPickerViewControllerDelegate {
    func photoPickerViewController(controller: LKPhotoPickerViewController, selectPhotos: Array<LKAsset>) {
        
    }
    
    func photoPickerViewController(controller: LKPhotoPickerViewController, selectAssets: Array<LKAsset>, selectPhotos: Array<UIImage>) {
        self.setupPhotos(photos: selectPhotos)
        self.selectPhotos = selectPhotos
        
        var imgs: Array<[String: Any]> = []
        for _ in 0..<selectPhotos.count {
            imgs.append(["a":0])
        }
        
        for i in 0..<selectPhotos.count {
            let imv = imagesView.subviews[i] as! PostPhotoView
            
            let image = selectPhotos[i]
            imv.startUpload()
            // 上传文件的原始数据，不要压缩~~ 有点蠢！！
//            asset.requestContentEditingInput(with: nil) { (input, info) in
//                let url = input?.fullSizeImageURL
//                let d = try? Data(contentsOf: url!)
            let d = image.pngData()
                ApiManager.shared.uploadFile(d!, token: self.token, success: { (resp) in
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
                    imv.finshedUpload()
                }
//            }
        }
    }
    
    func photoPickerViewController(controller: LKPhotoPickerViewController, cropImage: UIImage) {
        
    }
    
    private func setupPhotos(photos: Array<UIImage>) {
        
        if imagesView.subviews.count > 0 {
            imagesView.subviews.forEach({$0.removeFromSuperview()})
        }
        
        let w: CGFloat = 88
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
            imagesView.addSubview(v)
            
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
        imagesView.addSubview(uploadButton)
    }
    
    private func deletePhoto(_ index: Int) {
        self.selectPhotos.remove(at: index)
        if self.imagesParam.count > index {
            self.imagesParam.remove(at: index)
        }
        self.setupPhotos(photos: self.selectPhotos)
        
    }
}

// MARK: - Custom TextView
class LKTextView: UITextView {
    override func caretRect(for position: UITextPosition) -> CGRect {
        var originalRect = super.caretRect(for: position)
        originalRect.origin.y += 1
        originalRect.size.height = self.font?.lineHeight ?? 16 + 2
        originalRect.size.width = 2;
        return originalRect
    }
}

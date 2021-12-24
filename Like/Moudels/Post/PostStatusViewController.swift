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
    var emojiState: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = "发布动态"
        view.backgroundColor = .white
        setupViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.textView.becomeFirstResponder()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(okButtonClick))
        let closeImage = UIImage(named: "nav_close")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(closeVc))
        loadUploadToken()
    }

    @objc
    func closeVc() {
        //todo: 询问是否保存草稿
        dismiss(animated: true)
    }
    
    private func setupViews() {
        view.addSubview(contentView)
        contentView.addSubview(textView)
        contentView.addSubview(imagesView)
        imagesView.addSubview(uploadButton)
        view.addSubview(bottomView)
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
        contentView.keyboardDismissMode = .onDrag
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
            .foregroundColor: UIColor.blackText
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
        
    lazy var uploadButton: UIButton = {
        let uploadButton = UIButton()
        uploadButton.setBackgroundImage(UIImage(named: "photo_upload"), for: .normal)
        uploadButton.addTarget(self, action: #selector(uploadButtonClick), for: .touchUpInside)
        uploadButton.frame = CGRect(x: 0, y: 0, width: 88, height: 88)
        return uploadButton
    }()
    lazy var bottomView: PostBottomView = {
        let view = PostBottomView()
        view.frame = CGRect(x: 0, y: ScreenHeight-NavbarHeight-80-bottomSafeHeight(), width: ScreenWidth, height: 88)
        view.delegate = self
        return view
    }()
    lazy var emojiView: EmojiInputView = {
        let view = EmojiInputView()
        view.bounds = CGRect(x: 0, y: 0, width: ScreenWidth, height: 320)
        view.didSelectedEmoji = { [weak self] emoji in
            guard let `self` = self else { return }
            var txt = String(self.textView.text)
            txt.append(emoji)
            self.textView.text = txt
        }
        view.didDeletedEmoji = { [weak self] in
            guard let `self` = self else { return }
            var txt = String(self.textView.text)
            if txt.count <= 0 { return }
            let sub = txt.prefix(txt.count-1)
            self.textView.text = String(sub)
        }
        return view
    }()
}
// MARK: - Event
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
        
        let blankH = ScreenHeight - keyboardHeight - TopSafeHeight
        let h = textView.bounds.size.height + 100
        if h > blankH {
            let inset = min(keyboardHeight-32, h - blankH)
            contentView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: inset, right: 0)
            contentView.setContentOffset(CGPoint(x: 0, y:h - blankH), animated: false)
        }
        
        var bottomFrame = bottomView.frame
        bottomFrame.origin.y = endY - NavbarHeight - 88
        if endY == ScreenHeight {
            bottomFrame.origin.y -= bottomSafeHeight()
        }
        bottomView.frame = bottomFrame
    }
    
    @objc
    func keyboardwillHide() {
        emojiState = false
        bottomView.resetEmojiBtn()
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

extension PostStatusViewController: PostBottomViewDelegate {
    func postBottomView(_ bottomView: PostBottomView, emojiOnClick button: UIButton) {
        emojiState = !emojiState
        if emojiState {
            textView.inputView = emojiView
            if !textView.isFirstResponder {
                textView.becomeFirstResponder()
            }
            textView.reloadInputViews()
        } else {
            textView.inputView = nil
            if !textView.isFirstResponder {
                textView.becomeFirstResponder()
            }
            textView.reloadInputViews()

        }
    }
    
    func postBottomView(_ bottomView: PostBottomView, locationOnClick button: UIButton?) {
        let vc = PostLoctionViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
        vc.didSelectedLocation = {[weak self] location in
            guard let `self` = self else {return}
            self.updateLocation(location)
        }
    }
    func updateLocation(_ location: LocationInfo?) {
        if let `location` = location {
            bottomView.setupLocation(location.name)
        } else {
            bottomView.setupLocation(nil)
        }
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

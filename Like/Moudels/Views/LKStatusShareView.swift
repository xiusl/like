//
//  LKStatusShareView.swift
//  Like
//
//  Created by tmt on 2020/5/25.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit

class LKStatusShareView: UIView {
    
    var status: Status
    
    override init(frame: CGRect) {
        status = Status()
        super.init(frame: frame)
        
    }
    required init?(coder: NSCoder) {
        status = Status()
        super.init(coder: coder)
    }
    
    convenience init(status: Status) {
        self.init(frame: CGRect.zero)
        
        self.status = status
        
        setupViews()
    }
    
    open func show() {
        if self.superview == nil {
            UIApplication.shared.keyWindow?.addSubview(self)
        }
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
            self.actionsView.transform = CGAffineTransform(translationX: 0, y: -64)
        }
    }
    
    @objc
    open func dissmiss() {
        UIView.animate(withDuration: 0.12, animations: {
            self.alpha = 0.00001
            self.actionsView.transform = .identity
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    func setupStatus(status: Status) {
        
    }
    
    private func setupViews() {
        self.frame = UIScreen.main.bounds
        self.alpha = 0.00001
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(dissmiss))
        tapGest.delegate = self
        self.addGestureRecognizer(tapGest)
        
        
        let label = UILabel()
        label.numberOfLines = 0
        contentView.addSubview(label)
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        style.alignment = .justified
        
        let attrDict: Dictionary<NSAttributedString.Key, Any> =
            [.font: UIFont.systemFont(ofSize: 16),
             .paragraphStyle: style,
             .foregroundColor: UIColor.blackText]
        let attr = NSMutableAttributedString(string: status.content,
                                             attributes: attrDict)
        label.attributedText = attr
        
        let s = label.sizeThatFits(CGSize(width: ScreenWidth-48*2, height: CGFloat(MAXFLOAT)))
        
        label.frame = CGRect(x: 22, y: 22,
                             width: s.width, height: s.height)
        
        var t = 22 + s.height
        
        if status.images.count > 0 {
            let image = status.images.first
            
            
            let scale = UIScreen.main.scale
            var w = CGFloat(image!.width)
            var h = CGFloat(image!.height)
            let photo_scale = h / w
            let maxW: CGFloat = (ScreenWidth-52)*0.68 * scale
            if w > maxW {
                w = maxW
                h = maxW * photo_scale
            }
            
            let imageView = UIImageView()
            imageView.kf.setImage(with: URL(string: image?.url ?? ""))
            imageView.frame = CGRect(x: 22, y: t+10, width: w/scale, height: h/scale)
            
            contentView.addSubview(imageView)
            
            t = t + 10 + h / scale
        }
        
        
        
        
        let avatarView = UIImageView()
        avatarView.layer.cornerRadius = 4
        avatarView.clipsToBounds = true
        contentView.addSubview(avatarView)
        
        avatarView.frame = CGRect(x: ScreenWidth-52-32-22, y: t+20, width: 32, height: 32)

        let user = status.user
        
        avatarView.kf.setImage(with: URL(string: user?.avatar ?? ""))
        
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        nameLabel.textColor = .blackText
        nameLabel.textAlignment = .right
        nameLabel.text = user?.name
        contentView.addSubview(nameLabel)
        
        nameLabel.frame = CGRect(x: ScreenWidth-52-32-22-200-4, y: t+20, width: 200, height: 20)
        
        
        let timeLabel = UILabel()
        timeLabel.font = .systemFont(ofSize: 12)
        timeLabel.textColor = .c999999
        timeLabel.textAlignment = .right
        timeLabel.text = status.dateTextForShare()
        contentView.addSubview(timeLabel)
        
        timeLabel.frame = CGRect(x: ScreenWidth-52-32-22-200-4, y: t+20+20, width: 200, height: 12)
        
        t += 62
        
        let appLabel = UILabel()
        appLabel.font = .systemFont(ofSize: 10)
        appLabel.textColor = .cC9C9C9
        appLabel.textAlignment = .right
        appLabel.text = "来自哩嗑 App".localized
        contentView.addSubview(appLabel)
        appLabel.frame = CGRect(x: ScreenWidth-52-200-8, y: t, width: 200, height: 12)
        
        contentView.frame = CGRect(x: 0, y: 0, width: ScreenWidth-52, height: t+20)
        
        
        let maxH = ScreenHeight * 0.8
        
        let h = min(maxH, t + 20)
        var scrollT = StatusBarHeight + 20
        if t+20 < maxH {
            scrollT = (ScreenHeight - h) * 0.5
        }
        
        
        scrollView.frame = CGRect(x: 26, y: scrollT, width: ScreenWidth-52, height: h)
        scrollView.contentSize = contentView.frame.size
        addSubview(scrollView)
        
        
        scrollView.addSubview(contentView)
        
        
        
        
        
        addSubview(actionsView)
    }
    
    lazy var actionsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.frame = CGRect(x: 26, y: ScreenHeight, width: (ScreenWidth - 52), height: 44)
        
        
        let btns = ["保存","微信","朋友圈","取消"]
        var btnL: CGFloat = 0
        let btnW = (ScreenWidth - 52) / CGFloat(btns.count)
        var btnT: CGFloat = 0
        
        if StatusBarHeight > 20 {
            btnT -= 20
        }
        for btnTitle in btns {
            let button = UIButton()
            button.setTitle(btnTitle, for: .normal)
            button.setTitleColor(.theme, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14)
            button.frame = CGRect(x: btnL, y: btnT, width: btnW, height: 44)
            btnL += btnW
            view.addSubview(button)
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        }
        
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        return view
    }()
    
    @objc
    private func buttonAction(_ button: UIButton) {
        let title = button.currentTitle ?? ""
        if title == "取消" {
            dissmiss()
        } else if title == "保存" {
            UIImageWriteToSavedPhotosAlbum(captureView(contentView), self, #selector(saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
        } else if title == "微信" {
            let image = captureView(contentView)
            guard let imageData = image.pngData() else { return }
            let imageObj = WXImageObject()
            imageObj.imageData = imageData
            
            let message = WXMediaMessage()
            message.title = "哩嗑"
            message.description = "自娱&自乐"
            message.mediaObject = imageObj
            shareMessage(message,
                         scene: Int(WXSceneSession.rawValue))
            
        }  else if title == "朋友圈" {
            let image = captureView(contentView)
            guard let imageData = image.pngData() else { return }
            let imageObj = WXImageObject()
            imageObj.imageData = imageData
            
            let message = WXMediaMessage()
            message.title = "哩嗑"
            message.description = "自娱&自乐"
            message.mediaObject = imageObj
            shareMessage(message,
                         scene: Int(WXSceneTimeline.rawValue))
            
        }
    }
    
    private func shareMessage(_ message: WXMediaMessage, scene: Int) {
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(scene)
        WXApi.send(req, completion: nil)
        dissmiss()
    }
    
    private var captureImage: UIImage?
    private func captureView(_ view: UIView) -> UIImage {
        if captureImage == nil {
            let s = view.bounds.size
            UIGraphicsBeginImageContextWithOptions(s, false, UIScreen.main.scale)
            view.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            captureImage = image
        }
        return captureImage!
    }
    
    @objc
    private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        var msg = "保存成功"
        if error != nil {
           msg = "保存失败"
        } else {
            dissmiss()
        }
        SLUtil.showMessage(msg)
    }
}

extension LKStatusShareView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.contentView) ?? false {
            return false
        }
        if touch.view?.isDescendant(of: self.scrollView) ?? false {
            return false
        }
        if touch.view?.isDescendant(of: self.actionsView) ?? false {
            return false
        }
        return true
    }
}

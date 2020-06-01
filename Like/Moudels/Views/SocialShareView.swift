//
//  SocialShareView.swift
//  Like
//
//  Created by xiusl on 2019/10/28.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit
import Kingfisher

class SocialShareView: UIView {
    private var url: String?
    private var title: String?
    private var image: String?
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(url: String, title: String) {
        self.init(frame: CGRect.zero)
        self.url = url
        self.title = title
    }
    
    convenience init(url: String, title: String, image: String) {
        self.init(frame: CGRect.zero)
        self.url = url
        self.title = title
        self.image = image
    }
    
    private func setupView() {
        self.alpha = 0
        self.backgroundColor = UIColor(white: 0, alpha: 0.3)
        self.frame = CGRect(x: 0, y: 0,
                            width: UIScreen.main.bounds.size.width,
                            height: UIScreen.main.bounds.size.height)

        self.isHidden = true
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        tapGest.delegate = self
        self.addGestureRecognizer(tapGest)
        
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.timelineButton)
        self.contentView.addSubview(self.sessionButton)
    }
    @objc private func backgroundTap() {
        self.dismiss()
    }
    
    open func show() {
        if self.superview == nil {
            UIApplication.shared.keyWindow?.addSubview(self)
        }
        self.isHidden = false
        UIView.animate(withDuration: 0.25, animations: {
            self.contentView.transform = .identity
            self.alpha = 1.0
        }, completion: nil)
    }
    
    open func dismiss(remove: Bool = true) {
        UIView.animate(withDuration: 0.2, animations: {
            self.contentView.transform = .identity
            self.alpha = 0.0001
        }) { (finished) in
            self.isHidden = true
            if remove {
                self.removeFromSuperview()
            }
        }
    }

    private lazy var contentView: UIView = {
        let contentView = UIView()
        let screenH = self.bounds.size.height
        let height: CGFloat = 200
        let width = self.bounds.size.width
        contentView.frame = CGRect(x: 0, y: screenH-height, width: width, height: height)
        contentView.backgroundColor = .white
        contentView.transform = CGAffineTransform(translationX: 0, y: height)
        return contentView
    }()
    
    private lazy var timelineButton: UIButton = {
        let timelineButton = UIButton()
        timelineButton.frame = CGRect(x: 16+64+20, y: 20, width: 64, height: 64)
        timelineButton.setTitle("朋友圈", for: .normal)
        timelineButton.setTitleColor(.theme, for: .normal)
        timelineButton.addTarget(self, action: #selector(timelineButtonClick), for: .touchUpInside)
        return timelineButton
    }()
    
    private lazy var sessionButton: UIButton = {
        let sessionButton = UIButton()
        sessionButton.frame = CGRect(x: 16, y: 20, width: 64, height: 64)
        sessionButton.setTitle("微信", for: .normal)
        sessionButton.setTitleColor(.theme, for: .normal)
        sessionButton.addTarget(self, action: #selector(sessionButtonClick), for: .touchUpInside)
        return sessionButton
    }()
    
    @objc private func timelineButtonClick() {
        let webpageObject = WXWebpageObject()
        webpageObject.webpageUrl = self.url!
        let message = WXMediaMessage()
        message.title = self.title!
        message.description = "哩嗑 - 自娱&自乐"
        message.mediaObject = webpageObject
        
        if self.image != nil {
            let img = self.image!
            let result = ImageCache.default.isCached(forKey: img)
            if result {
                ImageCache.default.retrieveImage(forKey: img, options: nil, callbackQueue: .mainAsync) { (result) in
                    switch result {
                    case .success(let value):
                        message.setThumbImage(value.image ?? UIImage())
                        self.shareMessage2(message: message)
                        break
                    case .failure(let error):
                        debugPrint(error)
                        break
                    }
                }
            } else {
                KingfisherManager.shared.retrieveImage(with: ImageResource(downloadURL: URL(string: img)!)) { (result) in
                    switch result {
                    case .success(let value):
                        message.setThumbImage(value.image)
                        self.shareMessage2(message: message)
                        break
                    case .failure(_):
                        break
                    }
                }
            }
        } else {
            
            message.setThumbImage(UIImage(named: "logo")!)
            self.shareMessage2(message: message)
        }
        
        
        self.dismiss()
    }
    
    private func shareMessage2(message: WXMediaMessage) {
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(WXSceneTimeline.rawValue)
        WXApi.send(req, completion: nil)
    }
    
    
    @objc private func sessionButtonClick() {
        let webpageObject = WXWebpageObject()
        webpageObject.webpageUrl = self.url!
        let message = WXMediaMessage()
        message.title = self.title!
        message.description = "哩嗑 - 自娱&自乐"
        message.mediaObject = webpageObject
        
        if self.image != nil {
            let img = self.image!
            let result = ImageCache.default.isCached(forKey: img)
            if result {
                ImageCache.default.retrieveImage(forKey: img, options: nil, callbackQueue: .mainAsync) { (result) in
                    switch result {
                    case .success(let value):
                        message.setThumbImage(value.image ?? UIImage())
                        self.shareMessage(message: message)
                        break
                    case .failure(let error):
                        debugPrint(error)
                        break
                    }
                }
            } else {
                KingfisherManager.shared.retrieveImage(with: ImageResource(downloadURL: URL(string: img)!)) { (result) in
                    switch result {
                    case .success(let value):
                        message.setThumbImage(value.image)
                        self.shareMessage(message: message)
                        break
                    case .failure(_):
                        break
                    }
                }
            }
        } else {
            
            message.setThumbImage(UIImage(named: "logo")!)
            self.shareMessage(message: message)
        }
        self.dismiss()
    }
    
    private func shareMessage(message: WXMediaMessage) {
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(WXSceneSession.rawValue)
        WXApi.send(req, completion: nil)
    }
}

extension SocialShareView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.contentView) ?? false {
            return false
        }
        return true
    }
}

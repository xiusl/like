//
//  ChatBottomBarView.swift
//  Like
//
//  Created by tmt on 2020/7/24.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit

class ChatBottomBarView: UIView {
    let ViewHeight: CGFloat = 50
    
    var sendButtonHandle: ((_ text: String) -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        self.backgroundColor = .cF2F4F8
        
        addSubview(textView)
//        addSubview(voiceButton)
        addSubview(sendButton)
    
    }
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.frame = CGRect(x: 12, y: 8, width: ScreenWidth-12-60, height: 50-16)
        textView.backgroundColor = .white
        return textView
    }()
    
    lazy var voiceButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: ScreenWidth-60, y: 8, width: 60, height: 50-16)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(.theme, for: .normal)
        button.setTitle("发送", for: .normal)
        button.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        return button
    }()
}

extension ChatBottomBarView {
    @objc
    private func sendButtonAction() {
        self.sendButtonHandle?(textView.text)
    }
}

extension ChatBottomBarView {
    public func clearTextView() {
        textView.text = ""
    }
}

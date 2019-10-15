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
    }
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.frame = CGRect(x: 20, y: TopSafeHeight+10, width: ScreenWidth-40, height: 120)
        textView.layer.cornerRadius = 2
        textView.layer.borderColor = UIColor.cF2F4F8.cgColor
        textView.layer.borderWidth = 1
        textView.clipsToBounds = true
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
}

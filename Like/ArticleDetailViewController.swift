//
//  ArticleDetailViewController.swift
//  Like
//
//  Created by xiusl on 2019/9/29.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit
import WebKit
class ArticleDetailViewController: UIViewController {
    
    public var id: String = ""
    var urlStr: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(self.webView)
        self.webView.load(URLRequest(url: URL(string: urlStr)!))
    }
    

    lazy var webView: WKWebView = {
        let config: WKWebViewConfiguration = WKWebViewConfiguration()
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-0)
         let webView: WKWebView = WKWebView.init(frame: frame, configuration: config)
        return webView
    }()

}

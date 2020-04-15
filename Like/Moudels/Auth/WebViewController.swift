//
//  WebViewController.swift
//  Like
//
//  Created by xiu on 2020/4/14.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit
import WebKit


class WebViewController: BaseViewController {
    public var url: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.webView)
        
        let req = URLRequest(url: URL(string: self.url)!)
        self.webView.load(req)
    }
    
    public func setupUrl(_ url: String) {
        let req = URLRequest(url: URL(string: url)!)
        self.webView.load(req)
    }

    lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let frame = CGRect(x: 0, y: TopSafeHeight, width: ScreenWidth, height: ScreenHeight-TopSafeHeight)
        let webView = WKWebView(frame: frame, configuration: config)
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
        return webView
    }()
}

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
    public var urlStr: String = ""
    public var articleTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "文章详情"
        self.view.addSubview(self.webView)
        self.webView.load(URLRequest(url: URL(string: urlStr)!))
    }
    

    lazy var webView: WKWebView = {
        let config: WKWebViewConfiguration = WKWebViewConfiguration()
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-0)
         let webView: WKWebView = WKWebView.init(frame: frame, configuration: config)
        webView.scrollView.delegate = self;
        return webView
    }()

}

extension ArticleDetailViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        self.title = y > 20 ? self.articleTitle : "文章详情"
    }
}

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
        
        view.addSubview(self.progressView)
    }
    

    lazy var webView: WKWebView = {
        let config: WKWebViewConfiguration = WKWebViewConfiguration()
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: ScreenHeight-TopSafeHeight)
         let webView: WKWebView = WKWebView.init(frame: frame, configuration: config)
        webView.scrollView.delegate = self;
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: [.new], context: nil)
        return webView
    }()
    
    lazy private var progressView: UIProgressView = {
        let progressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1))
        progressView.tintColor = .theme
        progressView.trackTintColor = .white
        return progressView
    }()

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.alpha = 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            
            if webView.estimatedProgress >= 1 {
                UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseOut, animations: {
                    self.progressView.alpha = 0
                }) { (finish) in
                    self.progressView.setProgress(0.0, animated: false)
                }
            }
        }
    }
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}

extension ArticleDetailViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        self.title = y > 20 ? self.articleTitle : "文章详情"
    }
}

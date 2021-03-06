//
//  HomeTabViewController.swift
//  Like
//
//  Created by xiusl on 2019/10/11.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MJRefresh

class HomeTabViewController: BaseViewController {
    
    var data: Array<Article> = Array()
    var page: Int = 1
    let count: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tableView)
        self.tableView.estimatedRowHeight = 110
        self.tableView.estimatedSectionHeaderHeight = 0
        self.tableView.estimatedSectionFooterHeight = 0
        
        self.loadData()
        self.setupRefreshContorl()
    }
    private func setupRefreshContorl() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadData))
        self.tableView.mj_header = header
        
        let footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreData))
        self.tableView.mj_footer = footer
    }
    @objc func loadData() {
        self.page = 1
        let req = ArticleApiRequest.getArticles(page: self.page, count: 10)
        
        SLUtil.showLoading(to: view)
        ApiManager.shared.request(request: req, success: { (result) in
            let data = JSON(result)
            self.data = Array()
            for json in data["articles"].arrayValue {
                self.data.append(Article(fromJson: json))
            }
            self.tableView.reloadData()
            self.tableView.mj_header?.endRefreshing()
            SLUtil.hideLoading(from: self.view)
        }) { (error) in
            debugPrint(error)
            self.tableView.mj_header?.endRefreshing()
            SLUtil.hideLoading(from: self.view)
        }
    }
    @objc func loadMoreData() {
        self.page += 1
        let req = ArticleApiRequest.getArticles(page: self.page, count: 10)
        ApiManager.shared.request(request: req, success: { (result) in
            let data = JSON(result)
            for json in data["articles"].arrayValue {
                self.data.append(Article(fromJson: json))
            }
            self.tableView.reloadData()
            self.tableView.mj_footer?.endRefreshing()
        }) { (error) in
            debugPrint(error)
            self.tableView.mj_footer?.endRefreshing()
        }
    }
    @objc func addcount(_ refresh: UIRefreshControl) {
        self.loadData()
    }
    
    
    lazy var tableView: UITableView = {
        var height = ScreenHeight-TopSafeHeight-TabbarHeight
        if StatusBarHeight > 20 {
            height -= BottomSafeHeight
        }
        let frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: height)
        let tableView = UITableView(frame: frame, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
}

extension HomeTabViewController: UITableViewDataSource, UITableViewDelegate, ArticleViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let art = data[indexPath.row]
        let cell = ArticleViewCell.create(tableView: tableView)
        cell.setupTitle(art.title)
        cell.setImages(art.images)
        cell.index = indexPath.row
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let d = data[indexPath.row]
        let vc = ArticleDetailViewController()
        vc.urlStr = d.url
        vc.articleTitle = d.title
        self.navigationController?.pushViewController(vc, animated: true)
//        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func articleViewCellLikeButtonClick(_ button: UIButton) {
    
    }
    
    func articleViewCell(cell: ArticleViewCell, shareIndex: Int) {
         let art = self.data[shareIndex]
        guard let imgs = art.images else {return }
        if imgs.count > 0 {
            let shareView = SocialShareView(url: art.url, title: art.title, image: imgs.first!)
            shareView.show()
        } else {
            let shareView = SocialShareView(url: art.url, title: art.title)
            shareView.show()
        }

    }
    
    func articleViewCell(cell: ArticleViewCell, reportIndex: Int) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        
        reportArticle(at: indexPath)
    }
    
    private func reportArticle(at indexPath: IndexPath) {
        let reportView = LKReportView()
        reportView.show()
        
        reportView.clickHandle = { [weak self] content in
            guard let `self` = self else { return }
            self.reportArticle(at: indexPath, content: content)
        }
    }

    
    private func reportArticle(at indexPath: IndexPath, content: String) {
        
        let article = self.data[indexPath.row]
        let req = AppApiRequest.report(conetnt: content, ref_id: article.id, type: "article")
        
        SLUtil.showLoading(to: view)
        ApiManager.shared.request(request: req, success: { (data) in
            self.data.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .none)
            SLUtil.hideLoading(from: self.view)
        }) { (error) in
            SLUtil.hideLoading(from: self.view)
            SLUtil.showMessage(error)
        }
    }
}


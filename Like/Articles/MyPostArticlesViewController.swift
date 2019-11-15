//
//  MyPostArticlesViewController.swift
//  Like
//
//  Created by xiusl on 2019/11/15.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyPostArticlesViewController: BaseViewController {
        
        var data: Array<JSON> = Array()
        var page: Int = 1
        let count: Int = 10
        
        weak var refresh: UIRefreshControl?
        override func viewDidLoad() {
            super.viewDidLoad()
            self.title = "我的发布"
            self.view.addSubview(self.tableView)
            self.tableView.estimatedRowHeight = 0
            self.tableView.estimatedSectionHeaderHeight = 0
            self.tableView.estimatedSectionFooterHeight = 0
            
    //        let refresh = UIRefreshControl()
    //        refresh.addTarget(self, action: #selector(addcount(_ :)), for: .valueChanged)
    //        self.tableView.refreshControl = refresh
    //        self.refresh = refresh
            
            let refFooter = RefreshBackNormalFooter.footer(withRefreshingTarget: self, refreshingAction: #selector(loadMoreData))
            self.tableView.mjFooter = refFooter
            self.loadData()
            
            let refHeader = RefreshNormalHeader.header(withRefreshingTarget: self, refreshingAction: #selector(loadData))
            self.tableView.mjHeader = refHeader
        }
        @objc func loadData() {
            self.page = 1
            let url = URL(string: "http://ins-api.sleen.top/articles?spider=0")!
            AF.request(url).validate().responseJSON { [weak self] response in
                //            debugPrint("Response: \(response)")
                guard let `self` = self else { return }
                 self.tableView.mjHeader?.endRefreshing()
                if response.result.isSuccess {
                    let v = response.result.value
                    let j = JSON(v as Any)
                    self.data = j["data"]["articles"].array!
                    self.tableView.reloadData()
                    self.refresh?.endRefreshing()
                } else {
                    
                }
            }
            
        }
        @objc func loadMoreData() {
            self.page += 1
            let url = URL(string: "https://ins-api.sleen.top/articles?spider=0&count="+String(self.count)+"&page="+String(self.page))!
            AF.request(url).validate().responseJSON { response in
                
    //            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3) {

                    let v = response.result.value
                    let j = JSON(v as Any)
                    let adata = j["data"]["articles"].array!
                    self.data.append(contentsOf: adata)
                    self.tableView.reloadData()
                    self.tableView.mjFooter?.endRefreshing()
                    
                    if adata.count < self.count {
                        self.tableView.mjFooter?.setState(.noMoreData)
                    }
    //            }
            }
        }
        @objc func addcount(_ refresh: UIRefreshControl) {
            self.loadData()
        }
        
        
        lazy var tableView: UITableView = {
            var height = ScreenHeight-TopSafeHeight
            let frame = CGRect(x: 0, y: TopSafeHeight, width: ScreenWidth, height: height)
            let tableView = UITableView(frame: frame, style: .plain)
            tableView.delegate = self
            tableView.dataSource = self
    //        tableView.separatorStyle = .none
            return tableView
        }()
    }

    extension MyPostArticlesViewController: UITableViewDataSource, UITableViewDelegate, ArticleViewCellDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.data.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let j = data[indexPath.row]
            let cell = ArticleViewCell.create(tableView: tableView)
            cell.contentLabel.text = j["title"].stringValue
            cell.delegate = self
            cell.index = indexPath.row
            return cell
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let d = data[indexPath.row]
            let vc = ArticleDetailViewController()
            vc.urlStr = d["url"].stringValue
            self.present(vc, animated: true, completion: nil)
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
        
        func articleViewCellLikeButtonClick(_ button: UIButton) {
        
        }
        
        func articleViewCell(cell: ArticleViewCell, shareIndex: Int) {
            let d = data[shareIndex]
            let shareView = SocialShareView(url: d["url"].stringValue, title: d["title"].stringValue)
            shareView.show()
        }
    }

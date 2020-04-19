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

class UserStatusesViewController: BaseViewController {
    open var userId: String?
    var data: Array<Status> = Array()
    var page: Int = 1
    let count: Int = 10
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的发布"
        self.view.addSubview(self.tableView)
        
       let refFooter = RefreshBackNormalFooter.footer(withRefreshingTarget: self, refreshingAction: #selector(loadMoreData))
        self.tableView.mjFooter = refFooter
        self.loadData()
        
        let refHeader = RefreshNormalHeader.header(withRefreshingTarget: self, refreshingAction: #selector(loadData))
        self.tableView.mjHeader = refHeader
    }
    @objc func loadData() {
        guard let id = self.userId else {
            return
        }
        self.page = 1
        
        let req = ArticleApiRequest.getUserArticles(id: id, page: self.page, count: self.count)
        ApiManager.shared.request(request: req, success: { (data) in
            self.tableView.mjHeader?.endRefreshing()
            let data = JSON(data)
            self.data = Array()
            for json in data.arrayValue {
                self.data.append(Status(fromJson: json))
            }
            self.tableView.reloadData()
        }) { (error) in
            self.tableView.mjHeader?.endRefreshing()
        }
        
        
    }
    @objc func loadMoreData() {
        self.page += 1
        let url = URL(string: "https://ins-api.sleen.top/articles?spider=0&count="+String(self.count)+"&page="+String(self.page))!
        AF.request(url).validate().responseJSON { response in
            
        }
    }
    
    
    
    lazy var tableView: UITableView = {
        var height = ScreenHeight-TopSafeHeight
        let frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: height)
        let tableView = UITableView(frame: frame, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
}
extension UserStatusesViewController: UITableViewDataSource, UITableViewDelegate, StatusViewCellDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let status = self.data[indexPath.row]
        let user = status.user!
        
        let cell = StatusViewCell.create(tableView: tableView)
        
        cell.setupUserName(user.name)
        cell.setupUserAvatar(user.avatar)
        cell.setupContent(status.content)
        cell.setupLike(status.isLiked)
        cell.setupImages(status.images)
        
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func okButtonClick(_ button: UIButton) {
        let id = button.title(for: .disabled) ?? ""
        let request = button.isSelected ? StatusApiRequest.unlikeStatus(id: id) : StatusApiRequest.likeStatus(id: id)
        ApiManager.shared.request(request: request, success: { (result) in
            button.isSelected = !button.isSelected
        }) { (error) in
            debugPrint(error)
        }
    }
    func statusViewCellLikeButtonClick(_ cell: StatusViewCell) {
        guard let index = self.tableView.indexPath(for: cell) else {return}
        
        //        guard let data = self.data[index.row] else { return }
        let data: Status = self.data[index.row]
        let liked = data.isLiked!
        guard let id = data.id else { return }
        let request = StatusApiRequest.likeAction(id: id, like: !liked)
        ApiManager.shared.request(request: request, success: { (result) in
            cell.likeButton.isSelected = !liked
            data.isLiked = !liked
        }) { (error) in
            debugPrint(error)
        }
    }
    func statusCell(_ cell: StatusViewCell, likeClick: Any?) {
        
    }
    func statusCell(_ cell: StatusViewCell, userClick: Any?) {
        guard let index = self.tableView.indexPath(for: cell) else {return}
        let s = self.data[index.row]
        guard let u = s.user else { return }
        let vc = UserDetailViewController()
        vc.userId = u.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


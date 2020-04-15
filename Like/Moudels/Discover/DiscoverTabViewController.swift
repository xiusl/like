//
//  DiscoverTabViewController.swift
//  Like
//
//  Created by xiusl on 2019/10/11.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit
import SwiftyJSON

class DiscoverTabViewController: BaseViewController {
    
    var data: Array<Status> = Array()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.addSubview(self.tableView)
        self.loadData()
        let refHeader = RefreshNormalHeader.header(withRefreshingTarget: self, refreshingAction: #selector(loadData))
        self.tableView.mjHeader = refHeader
    }
    
    @objc func loadData() {
        let request = StatusApiRequest.getStatuses(page: 1, count: 10)
        ApiManager.shared.request(request: request, success: { (result) in
            let data = JSON(result)
            self.data = Array()
            for json in data["statuses"].arrayValue {
                self.data.append(Status(fromJson: json))
            }
            self.tableView.reloadData()
            self.tableView.mjHeader?.endRefreshing()
        }) { (error) in
            debugPrint(error)
            self.tableView.mjHeader?.endRefreshing()
        }
    }
    
    lazy var tableView: UITableView = {
        var height = ScreenHeight-TopSafeHeight-TabbarHeight
        if StatusBarHeight > 20 {
            height -= BottomSafeHeight
        }
        let frame = CGRect(x: 0, y: TopSafeHeight, width: ScreenWidth, height: height)
        let tableView = UITableView(frame: frame, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
}

extension DiscoverTabViewController: UITableViewDataSource, UITableViewDelegate, StatusViewCellDelegate {
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
    @objc func okButtonClick(_ button: UIButton) {
        let id = button.title(for: .disabled) ?? ""
        let request = button.isSelected ? StatusApiRequest.unlikeStatus(id: id) : StatusApiRequest.likeStatus(id: id)
        ApiManager.shared.request(request: request, success: { (result) in
            button.isSelected = !button.isSelected
        }) { (error) in
            debugPrint(error)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //        let d = data[indexPath.row]
        //        let vc = ArticleDetailViewController()
        //        vc.urlStr = d["url"].stringValue
        //        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //    func statusViewCellLikeButtonClick(_ button: UIButton) {
    //        let id = button.title(for: .disabled) ?? ""
    //        let request = button.isSelected ? StatusApiRequest.unlikeStatus(id: id) : StatusApiRequest.likeStatus(id: id)
    //        ApiManager.shared.request(request: request, success: { (result) in
    //            button.isSelected = !button.isSelected
    //        }) { (error) in
    //            debugPrint(error)
    //        }
    //    }
    
    func statusViewCellLikeButtonClick(_ cell: StatusViewCell) {
        guard let index = self.tableView.indexPath(for: cell) else {return}
        
        //        guard let data = self.data[index.row] else { return }
        let data: Status = self.data[index.row]
        let liked = data.isLiked ?? false
        guard let id = data.id else { return }
        let request = StatusApiRequest.likeAction(id: id, like: liked)
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
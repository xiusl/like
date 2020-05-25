//
//  MyPostArticlesViewController.swift
//  Like
//
//  Created by xiusl on 2019/11/15.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit
import Alamofire
import MJRefresh
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
        guard let id = self.userId else {
            return
        }
        self.page = 1
        
        let req = StatusApiRequest.getUserStatuses(id: id, page: self.page, count: self.count)
        ApiManager.shared.request(request: req, success: { (data) in
            let data = JSON(data)
            self.data = Array()
            for json in data.arrayValue {
                self.data.append(Status(fromJson: json))
            }
            self.tableView.reloadData()
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.state = .idle
        }) { (error) in
            self.tableView.mj_header?.endRefreshing()
        }
        
        
    }
    @objc func loadMoreData() {
        
        guard let id = self.userId else {
            return
        }
        self.page += 1
        let req = StatusApiRequest.getUserStatuses(id: id, page: self.page, count: self.count)
        ApiManager.shared.request(request: req, success: { (result) in
            let data = JSON(result)
            let count = self.data.count
            var indexPaths = Array<IndexPath>()
            for (i, json) in data.arrayValue.enumerated() {
                self.data.append(Status(fromJson: json))
                let indexPath = IndexPath(row: i+count, section: 0)
                indexPaths.append(indexPath)
            }
            
            self.tableView.insertRows(at: indexPaths, with: .none)
            if indexPaths.count == 0 {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self.tableView.mj_footer?.endRefreshing()
            }
        }) { (error) in
            self.tableView.mj_header?.endRefreshing()
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
    
    lazy var moreActionView: StatusMoreView = {
        let view = StatusMoreView()
        view.delegate = self
        return view
    }()
}
extension UserStatusesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let status = self.data[indexPath.row]
        let user = status.user!
        
        let cell = StatusViewCell.create(tableView: tableView)
        
        cell.setupName(user.name)
        cell.setupAvatar(user.avatar)
        cell.setupContent(status.content)
        cell.setupLike(status.isLiked, count: status.likeCount)
        cell.setupImages(status.images)
        cell.setupDesc(status.displayDateText())
        
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension UserStatusesViewController: StatusViewCellDelegate {
    func statusCell(_ cell: StatusViewCell, likeClick: Any?) {
        guard let index = self.tableView.indexPath(for: cell) else {return}
        let data: Status = self.data[index.row]
        let liked = data.isLiked!
        var count = data.likeCount ?? 0
        guard let id = data.id else { return }
        let request = StatusApiRequest.likeAction(id: id, like: !liked)
        ApiManager.shared.request(request: request, success: { (result) in
            data.isLiked = !liked
            count = count - (liked ? 1 : -1)
            data.likeCount = count
            cell.setupLike(!liked, count: count)
        }) { (error) in
            debugPrint(error)
        }
    }
    func statusCell(_ cell: StatusViewCell, userClick: Any?) {
        guard let index = self.tableView.indexPath(for: cell) else {return}
        let s = self.data[index.row]
        guard let u = s.user else { return }
        let vc = UserDetailViewController()
        vc.userId = u.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func statusCell(_ cell: StatusViewCell, moreClick: Any?) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        self.moreActionView.indexPath = indexPath
        self.moreActionView.show()
    }
    func statusCell(_ cell: StatusViewCell, shareClick: Any?) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        let s = self.data[indexPath.row]
        
        let shareView = LKStatusShareView(status: s)
        shareView.show()
    }
}
extension UserStatusesViewController: StatusMoreViewDelegate {
    func statusMoreAction(shield: Int, indexPath: IndexPath?) {
        guard let `indexPath` = indexPath else { return }
        shieldStatus(at: indexPath)
    }
    
    func statusMoreAction(report: Int, indexPath: IndexPath?) {
        guard let `indexPath` = indexPath else { return }
        reportStatus(at: indexPath)
    }
    
    func statusMoreAction(delete: Int, indexPath: IndexPath?) {
        guard let `indexPath` = indexPath else { return }
        removeStatus(at: indexPath)
    }
    
    private func removeStatus(at indexPath: IndexPath) {
        let status = self.data[indexPath.row]
        let req = StatusApiRequest.deleteStatus(id: status.id)
        SLUtil.showLoading(to: self.view)
        ApiManager.shared.request(request: req, success: { (data) in
            SLUtil.hideLoading(from: self.view)
            SLUtil.showMessage("删除成功".localized)
            self.data.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .none)
            self.moreActionView.dismiss()
        }) { (error) in
            SLUtil.hideLoading(from: self.view)
            SLUtil.showMessage(error)
        }
    }
    
    private func shieldStatus(at indexPath: IndexPath) {
        let status = self.data[indexPath.row]
        let req = StatusApiRequest.shield(id: status.id, shield: true)
        SLUtil.showLoading(to: self.view)
        ApiManager.shared.request(request: req, success: { (data) in
            SLUtil.hideLoading(from: self.view)
            SLUtil.showMessage("屏蔽成功".localized)
            self.data.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .none)
            self.moreActionView.dismiss()
        }) { (error) in
            SLUtil.hideLoading(from: self.view)
            SLUtil.showMessage(error)
        }
    }
    
    private func reportStatus(at indexPath: IndexPath) {
        self.moreActionView.dismiss()
        let reportView = LKReportView()
        reportView.show()
        
        reportView.clickHandle = { [weak self] content in
            guard let `self` = self else { return }
            self.reportStatus(at: indexPath, content: content)
        }
    }
    
    private func reportStatus(at indexPath: IndexPath, content: String) {
        
        let status = self.data[indexPath.row]
        let req = AppApiRequest.report(conetnt: content, ref_id: status.id, type: "status")
        
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

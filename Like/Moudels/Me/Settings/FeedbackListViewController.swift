//
//  FeedbackListViewController.swift
//  Like
//
//  Created by tmt on 2020/4/24.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class FeedbackListViewController: BaseViewController {
    
    var page = 1
    var count = 10
    var data = Array<Feedback>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = "反馈记录".localized
        view.addSubview(self.tableView)
        loadData()
        self.setupRefresh()
    }
    
    private func setupRefresh() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadData))
        self.tableView.mj_header = header
        
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreData))
        self.tableView.mj_footer = footer
    }
    
    @objc private func loadData() {
        guard let user = User.current else {
            return
        }
        page = 1
        let req = AppApiRequest.getFeedbacks(userId: user.id, page: page, count: count)
        
        ApiManager.shared.request(request: req, success: { (data) in
            let arr = JSON(data)["data"].arrayValue
            self.data = Array<Feedback>()
            for d in arr {
                let feedback = Feedback(fromJson: d)
                //                feedback.replay = "Re: 这是回复"
                self.data.append(feedback)
            }
            self.tableView.reloadData()
            
            self.tableView.mj_header?.endRefreshing()
            
            if arr.count < self.count {
                self.tableView.mj_footer?.state = .noMoreData
            }
        }) { (error) in
            self.tableView.mj_header?.endRefreshing()
        }
    }
    
    @objc private func loadMoreData() {
        guard let user = User.current else {
            return
        }
        page += 1
        let req = AppApiRequest.getFeedbacks(userId: user.id, page: page, count: count)
        
        ApiManager.shared.request(request: req, success: { (data) in
            let arr = JSON(data)["data"].arrayValue
            for d in arr {
                let feedback = Feedback(fromJson: d)
                self.data.append(feedback)
            }
            self.tableView.reloadData()
            if arr.count < self.count {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self.tableView.mj_footer?.endRefreshing()
            }
        }) { (error) in
            self.tableView.mj_footer?.endRefreshing()
        }
    }
    
    
    lazy var tableView: UITableView = {
        let frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        let tableView = UITableView(frame: frame, style: .plain)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .cF2F4F8
        return tableView
    }()
    
}

extension FeedbackListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView.mj_footer?.isHidden = (data.count == 0)
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FeedbackViewCell.create(tableView: tableView)
        
        let feedback = self.data[indexPath.row]
        
        
        cell.setupContent(feedback.content)
        cell.setupReplay(feedback.replay)
        cell.setupTime(feedback.displayTime)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}

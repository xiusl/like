//
//  AdminFeedbackListViewController.swift
//  Like
//
//  Created by tmt on 2020/4/24.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit
import SwiftyJSON

class AdminFeedbackListViewController: BaseViewController {
    
    var page = 1
    var count = 10
    var data = Array<Feedback>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = "反馈处理".localized
        view.addSubview(self.tableView)
        loadData()
    }
    
    private func loadData() {
        let req = AppApiRequest.getAllFeedbacks(page: page, count: count)
        
        ApiManager.shared.request(request: req, success: { (data) in
            let d = JSON(data)
            for d in d["data"].arrayValue {
                let feedback = Feedback(fromJson: d)
                //                feedback.replay = "Re: 这是回复"
                self.data.append(feedback)
            }
            self.tableView.reloadData()
            
        }) { (error) in
            
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

extension AdminFeedbackListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FeedbackViewCell.create(tableView: tableView)
        
        let feedback = self.data[indexPath.row]
        let user = feedback.user!
        
        cell.setupContent(feedback.content)
        cell.setupReplay(feedback.replay)
        cell.setupTime(feedback.displayTime)
        cell.setupIsAdmin(true)
        cell.setupUserName(user.name)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}

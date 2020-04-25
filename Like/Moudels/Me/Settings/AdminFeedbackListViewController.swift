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
    var id: String?
    var replayTextView: UITextView?
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
    
    lazy var replayView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 20, y: 100, width: ScreenWidth-40, height: 200)
        view.backgroundColor = .cF2F4F8
        view.isHidden = true
        
        
        let btn = UIButton(type: .custom)
        btn.setTitle("关闭".localized, for: .normal)
        btn.setTitleColor(.c999999, for: .normal)
        btn.frame = CGRect(x: ScreenWidth-80, y: 0, width: 40, height: 40)
        btn.addTarget(self, action: #selector(closeReplayAction), for: .touchUpInside)
        view.addSubview(btn)
        
        let textView = UITextView()
        textView.frame = CGRect(x: 12, y: 36, width: ScreenWidth-40-24, height: 120)
        textView.layer.borderWidth = 1
        textView.tintColor = .theme
        textView.font = .systemFont(ofSize: 14)
        textView.layer.borderColor = UIColor.cF2F4F8.cgColor
        view.addSubview(textView)
        self.replayTextView = textView
        
        let confirmButton = UIButton()
        confirmButton.frame = CGRect(x: 12, y: 165, width: ScreenWidth-40-24, height: 32)
        confirmButton.backgroundColor = .theme
        confirmButton.layer.cornerRadius = 4
        confirmButton.clipsToBounds = true
        confirmButton.setTitle("确认".localized, for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.addTarget(self, action: #selector(replayConfirmAction), for: .touchUpInside)
        view.addSubview(confirmButton)
        
        return view
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
        
        let id = feedback.id
        
        cell.handleFeedback = { [weak self] in
            guard let `self` = self else {
                return
            }
            self.handleFeedback(id)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
    func handleFeedback(_ id: String?) {
        if self.replayView.superview == nil {
            self.view.addSubview(self.replayView)
        }
        self.id = id
        self.replayView.isHidden = false
        guard let textView = self.replayTextView else {
            return
        }
        textView.becomeFirstResponder()
    }
    @objc func closeReplayAction() {
        self.replayView.isHidden = true
        self.view.endEditing(true)
    }
    @objc func replayConfirmAction() {
        
        guard let id = self.id else {
            return
        }
        guard let textView = self.replayTextView else {
            return
        }
        let replay = textView.text ?? ""
        if replay.count <= 0 {
            SLUtil.showMessage("你也没写啊？？".localized)
            return
        }
        let req = AppApiRequest.replayFeedback(feedbackId: id, replay: replay)
        SLUtil.showLoading(to: view)
        ApiManager.shared.request(request: req, success: { (data) in
            self.view.endEditing(true)
            self.replayView.isHidden = true
            textView.text = ""
            SLUtil.hideLoading(from: self.view)
        }) { (error) in
            SLUtil.showMessage(error)
            SLUtil.hideLoading(from: self.view)
        }
    }
}

//
//  ViewController.swift
//  Like
//
//  Created by xiusl on 2019/9/29.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    var data: Array<JSON> = Array()
    var page: Int = 1
    let count: Int = 10
    
    weak var refresh: UIRefreshControl?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "123"
        self.view.addSubview(self.tableView)
        self.tableView.estimatedRowHeight = 0
        self.tableView.estimatedSectionHeaderHeight = 0
        self.tableView.estimatedSectionFooterHeight = 0
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(addcount(_ :)), for: .valueChanged)
        self.tableView.refreshControl = refresh
        self.refresh = refresh
        
        let refFooter = RefreshAutoNormalFooter()
        self.tableView.refFooter = refFooter
        
//        refFooter.refreshingBlock = { [weak self] in
//            guard let `self` = self else { return }
//            self.loadMoreData()
//        }
        refFooter.addRefreshingTarget(self, selector: #selector(loadMoreData))
        self.loadData()
    }
    func loadData() {
        self.page = 1
        let url = URL(string: "http://api.ins.com/articles")!
        AF.request(url).validate().responseJSON { response in
//            debugPrint("Response: \(response)")
            if response.result.isSuccess {
                let v = response.result.value
                let j = JSON(v as Any)
                self.data = j["data"]["articles"].array!
                self.tableView.reloadData()
                self.refresh?.endRefreshing()
            } else {
                
            }
        }
        
        
        ApiManager.shared.request(request: ArtApiRequest.getArticles(()), success: { (result) in
            
        }) { (error) in
            
        }
    }
    @objc func loadMoreData() {
        self.page += 1
        let url = URL(string: "https://ins-api.sleen.top/articles?count="+String(self.count)+"&page="+String(self.page))!
        AF.request(url).validate().responseJSON { response in
            let v = response.result.value
            let j = JSON(v as Any)
            let adata = j["data"]["articles"].array!
            self.data.append(contentsOf: adata)
            self.tableView.reloadData()
            self.tableView.refFooter?.endRefreshing()
        }
    }
    @objc func addcount(_ refresh: UIRefreshControl) {
        self.loadData()
    }

    
    lazy var tableView: UITableView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        let tableView = UITableView(frame: frame, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellIdf")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "UITableViewCellIdf")
        }
        let j = data[indexPath.row]
        
        cell!.textLabel?.text = j["title"].stringValue
        
        return cell!
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
}

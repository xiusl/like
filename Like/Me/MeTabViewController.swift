//
//  MeTabViewController.swift
//  Like
//
//  Created by xiusl on 2019/10/11.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit
import Kingfisher

class MeTabViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    var user: User?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(userChange), name: .UserLoginNoti, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.user = User.current
        
        self.view.addSubview(self.tableView)
        self.tableView.tableHeaderView = self.headerView
        self.headerView.descLabel.text = self.user?.desc
        self.headerView.nameLabel.text = self.user?.name
        self.headerView.avatarView.kf.setImage(with: URL(string: self.user?.avatar ?? "")!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(userChange), name: .UserLogoutNoti, object: nil)
        
        let gest = UITapGestureRecognizer(target: self, action: #selector(bac))
        self.headerView.addGestureRecognizer(gest)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "投稿", style: .plain, target: self, action: #selector(post))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "发动态", style: .plain, target: self, action: #selector(postStatus))
    }
    
    @objc func postStatus() {
        let vc = PostStatusViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func post() {
        let view = PostLinkView()
        view.show()
        view.confirmClickHandle = { (url) in
            print(url)
            let request = ArtApiRequest.spiderArticle(url: url)
            ApiManager.shared.request(request: request, success: { (result) in
                print(result)
            }) { (error) in
                print(error)
            }
        }
    }
    
    @objc func bac() {
        let vc = UserDetailViewController()
        vc.userId = self.user!.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func userChange() {
        self.user = User.current
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableConfig.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = self.tableConfig[section]
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let arr = self.tableConfig[indexPath.section]
        let dic = arr[indexPath.row]
        
        let cell = MeTabTableViewCell.create(tableView: tableView)
        
        let icon = dic["icon"]
        
        cell.titleLabel.text = dic["title"]
        cell.iconView.image = UIImage(named: icon ?? "")
        
        cell.lineView.isHidden = (indexPath.section == 0 && indexPath.row+1==arr.count)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MeTabTableViewCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let arr = self.tableConfig[indexPath.section]
        let dic = arr[indexPath.row]
        let title = dic["title"]
        if title == "退出" {

            
            let view = ConfirmSheetView.showInWindow(actions: ["退出"], title: "确定要退出吗？")
            view.callback = { [weak self] (action) in
                if action == "退出" {
                    guard let `self` = self else { return }
                    self.logout()
                }
            }
        } else if title == "设置" {
            ConfirmSheetView.showInWindow()
        } else if title == "我的发布" {
            let vc = MyPostArticlesViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func logout() {
        User.delete()
        let vc = PasswordLoginViewController()
        vc.isPrefersHidden = true
        let nav = MainNavigationController(rootViewController: vc)
        
        let keyWidow = UIApplication.shared.keyWindow
        keyWidow?.rootViewController = nav
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 10
        }
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 10))
            view.backgroundColor = UIColor(hex: 0xF2F4F8)
            return view
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    lazy var tableView: BaseTableView = {
        let height = ScreenHeight - TabbarHeight - TopSafeHeight;
        let frame = CGRect(x: 0, y: TopSafeHeight, width: ScreenWidth, height: height)
        let tableView: BaseTableView = BaseTableView.init(frame: frame, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .cF2F4F8
        tableView.separatorStyle = .none
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.navigationController?.automaticallyAdjustsScrollViewInsets = false
        }
        return tableView
    }()
    
    lazy var headerView: MeTableHeaderView = {
        let headerView = Bundle.main.loadNibNamed("MeTableHeaderView", owner: nil, options: nil)?.first as! MeTableHeaderView
        headerView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 92)
        return headerView
    }()
        
    lazy var tableConfig: Array = { () -> [[[String : String]]] in
        let arr: Array = [
            [
                ["title": "我的发布", "icon": "me_wallet", "action": ""],
                ["title": "我的点赞", "icon": "me_arcode", "action": ""],
            ],
            [
                ["title": "设置", "icon": "me_setting", "action": ""],
                ["title": "退出", "icon": "me_service", "action": ""],
            ]
        ]
        return arr
    }()
}

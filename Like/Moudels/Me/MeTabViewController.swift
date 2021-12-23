//
//  MeTabViewController.swift
//  Like
//
//  Created by xiusl on 2019/10/11.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON

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
        self.setupViewDisplay()
        
        NotificationCenter.default.addObserver(self, selector: #selector(userChange), name: .UserLogoutNoti, object: nil)
        
        let gest = UITapGestureRecognizer(target: self, action: #selector(bac))
        self.headerView.addGestureRecognizer(gest)
        
        
        
        
        self.navigationItem.rightBarButtonItem = self.barButtonItem("发嗑".localized, target: self, action: #selector(postStatus))

    
        NotificationCenter.default.addObserver(self, selector: #selector(loadUserData), name: NSNotification.Name("UserInfoEdited_noti"), object: nil)
    }
    func setupViewDisplay() {
        guard let user = self.user else {
            return
        }
        
        self.headerView.descLabel.text = user.desc
        self.headerView.nameLabel.text = user.name
        self.headerView.avatarView.kf.setImage(with: URL(string: user.avatar)!)
        
        if user.type == 9 {
            self.navigationItem.leftBarButtonItem = self.barButtonItem("投稿".localized, target: self, action: #selector(post))
        }
    }
    @objc func loadUserData() {
        let req = UserApiRequest.getCurrentUser(())
        ApiManager.shared.request(request: req, success: { (data) in
            let u = User(fromJson: JSON(data))
            let _ = u.save()
            self.user = u
            self.setupViewDisplay()
        }) { (error) in
            
        }
        
    }
    @objc func postStatus() {
        let vc = PostStatusViewController()
        let nav = MainNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
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
        
        cell.setup(title: dic["title"]!, icon: dic["icon"]!)
        
        cell.lineView.isHidden = (indexPath.row+1==arr.count)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MeTabTableViewCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let arr = self.tableConfig[indexPath.section]
        let dic = arr[indexPath.row]
        let title = dic["title"]
        if title == "设置" {
            let vc = SettingsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if title == "我的发布" {
            let vc = UserStatusesViewController()
            vc.userId = self.user?.id
            self.navigationController?.pushViewController(vc, animated: true)
        } else if title == "我的点赞" {
            let vc = StatusListViewController()
            vc.userId = self.user?.id
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
        let frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: height)
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
                ["title": "我的发布", "icon": "me_post", "action": ""],
                ["title": "我的点赞", "icon": "me_like", "action": ""],
            ],
            [
                ["title": "设置", "icon": "me_setting", "action": ""],
            ]
        ]
        return arr
    }()
}

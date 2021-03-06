//
//  SettingsViewController.swift
//  Like
//
//  Created by tmt on 2020/4/15.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController,UITableViewDataSource, UITableViewDelegate {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
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
        self.title = "设置"
        self.view.addSubview(self.tableView)
        
        let footerV = UIView()
        footerV.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 64);
        footerV.addSubview(self.logoutButton)
        self.tableView.tableFooterView = footerV
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
        if title == "关于" {
            let vc = AppAboutViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if title == "隐私政策" {
            let vc = WebViewController()
            vc.url = "https://ins.sleen.top/privacy"
            vc.title = "哩嗑隐私政策"
            self.navigationController?.pushViewController(vc, animated: true)
        } else if title == "反馈" {
            let vc = FeedbackPostViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if title == "反馈处理" {
            let vc = AdminFeedbackListViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if title == "修改密码" {
            let vc = PasswordChangeViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if title == "使用协议" {
            let vc = WebViewController()
            vc.url = "https://ins.sleen.top/usage"
            vc.title = "哩嗑使用协议"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func logout() {
        User.delete()
        
        do {
            Client.current.close { (res) in
                
            }
        } catch {
            UIAlertController.show(error: error, controller: self)
        }
        
        let vc = PasswordLoginViewController()
        vc.isPrefersHidden = true
        let nav = MainNavigationController(rootViewController: vc)
        
        let keyWidow = UIApplication.shared.keyWindow
        keyWidow?.rootViewController = nav
    }
    
    @objc func logoutButtonAction() {
        let view = ConfirmSheetView.showInWindow(actions: ["退出"], title: "确定要退出账号吗？")
        view.callback = { [weak self] (action) in
            if action == "退出" {
                guard let `self` = self else { return }
                self.logout()
            }
        }

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 10))
        view.backgroundColor = UIColor(hex: 0xF2F4F8)
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    lazy var tableView: BaseTableView = {
        let height = ScreenHeight - TopSafeHeight;
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
        
    lazy var tableConfig: Array = { () -> [[[String : String]]] in
        var arr: Array = [
            [
                ["title": "关于", "icon": "setting_about", "action": ""],
                ["title": "修改密码", "icon": "change_pwd", "action": ""],
                ["title": "反馈", "icon": "setting_feedback", "action": ""],
            ],
            [
                ["title": "隐私政策", "icon": "setting_privacy", "action": ""],
                ["title": "使用协议", "icon": "setting_usage", "action": ""],
            ]
        ]
        if User.current?.type == 9 {
            arr.append([
                ["title": "反馈处理", "icon": "setting_feedback", "action": ""],
            ])
        }
        
        return arr
    }()
    
    lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 24, y: 10,
                              width: ScreenWidth-48,
                              height: 44);
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
        button.setTitle("退出账号", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16,
                                                    weight: .regular)
        button.addTarget(self, action: #selector(logoutButtonAction), for: .touchUpInside)
        return button
    }()
}

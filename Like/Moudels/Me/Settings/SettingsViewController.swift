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
        if title == "关于" {
        } else if title == "隐私政策" {
            let vc = WebViewController()
            vc.url = "https://ins.sleen.top/privacy"
            vc.title = "隐私政策"
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
        let arr: Array = [
            [
                ["title": "关于", "icon": "setting_about", "action": ""],
                ["title": "隐私政策", "icon": "setting_privacy", "action": ""],
            ]
        ]
        return arr
    }()
    
    lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 24, y: 10, width: ScreenWidth-48, height: 44);
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
        button.setTitle("退出账号", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.addTarget(self, action: #selector(logoutButtonAction), for: .touchUpInside)
        return button
    }()
}

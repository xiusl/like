//
//  UserInfoViewController.swift
//  Like
//
//  Created by tmt on 2020/4/21.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit

class UserInfoViewController: BaseViewController {

    var user: User?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: .cF2F4F8), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage(color: .cF2F4F8)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "个人信息"
        self.initData()
        self.view.addSubview(self.tableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name("UserInfoEdited_noti"), object: nil)
    }
    
    @objc func reloadData() {
        self.initData()
        self.tableView.reloadData()
    }
    private func initData() {
        guard let u = User.current else {
            return
        }
        self.configs = Array<FormModel>()
        let avatarForm = FormModel(title: "头像", key: "avatar",
                                   value: u.avatar, placeHolder: "",
                                   rowHeight: 64)
        let nameForm = FormModel(title: "名字", key: "name",
                                 value: u.name, placeHolder: "",
                                 rowHeight: 45)
        let descForm = FormModel(title: "简介", key: "desc",
                                 value: u.desc, placeHolder: "",
                                 rowHeight: 0)
        
        self.configs.append(avatarForm)
        self.configs.append(nameForm)
        self.configs.append(descForm)
    }

    
    lazy var tableView: UITableView = {
        let frame = CGRect(x: 0, y: 0,
                           width: ScreenWidth,
                           height: ScreenHeight-TopSafeHeight)
        let tableView = UITableView(frame: frame)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .cF2F4F8
        return tableView
    }()

    lazy var configs = Array<FormModel>()
}


extension UserInfoViewController: UITableViewDataSource,
UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.configs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FormInputCell.create(tableView: tableView)
        
        let form = self.configs[indexPath.row]
        cell.setupTitle(form.title)
        cell.setupValue(form.value)
        cell.setupLineHide(indexPath.row+1 == self.configs.count)
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let form = self.configs[indexPath.row]
        let rowH = CGFloat(form.rowHeight)
        
        return rowH == 0 ? UITableView.automaticDimension : rowH;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let form = self.configs[indexPath.row]
        let key = form.key
        if key == "avatar" {
            let vc = UserAvatarViewController()
            guard let u = User.current else {
                return
            }
            vc.id = u.id
            vc.url = form.value
            self.navigationController?.pushViewController(vc, animated: true)
        } else if key == "name" {
            let vc = UserNameViewController()
            let nav = MainNavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
}

struct FormModel {
    var title: String
    var key: String
    var value: String
    var placeHolder: String
    var rowHeight: Int
}

class FormInputCell: UITableViewCell {
    
    class func create(tableView: UITableView) -> FormInputCell {
        let idf = NSStringFromClass(self)
        var cell: FormInputCell? = tableView.dequeueReusableCell(withIdentifier: idf) as? FormInputCell
        if cell == nil {
            cell = FormInputCell(style: .default, reuseIdentifier: idf)
        }
        return cell!
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.selectionStyle = .none
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupTitle(_ title: String) {
        self.titleLabel.text = title
    }
    open func setupLineHide(_ hidden: Bool) {
        self.lineView.isHidden = hidden
    }
    open func setupValue(_ value: String) {
        let isImage = value.starts(with: "http")
        self.valueLabel.isHidden = isImage
        self.valueView.isHidden = !isImage
        if isImage {
            self.valueView.kf.setImage(with: URL(string: value))
        } else {
            self.valueLabel.text = value
        }
    }
    
    func setupViews() {
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.valueView)
        self.contentView.addSubview(self.valueLabel)
        self.contentView.addSubview(self.lineView)
        self.contentView.addSubview(self.arrowView)
        
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(16)
            make.centerY.equalTo(self.contentView)
        }
        self.valueLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-32)
            make.centerY.equalTo(self.contentView)
            make.top.equalTo(self.contentView).offset(6)
            make.bottom.equalTo(self.contentView).offset(-6)
            make.height.greaterThanOrEqualTo(33)
        }
        self.valueView.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-32)
            make.centerY.equalTo(self.contentView)
            make.size.equalTo(CGSize(width: 48, height: 48))
        }
        self.arrowView.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-16)
            make.centerY.equalTo(self.contentView)
        }
        self.lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.contentView)
            make.height.equalTo(0.5)
        }
    }
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    lazy var valueView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(hex: 0x000000, alpha: 0.8)
        return label
    }()
    lazy var arrowView: UIImageView = {
        let arrowView: UIImageView = UIImageView()
        arrowView.image = UIImage(named: "arrow")
        return arrowView
    }()
    lazy var lineView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor(hex: 0x000000, alpha: 0.12)
        return view
    }()
}

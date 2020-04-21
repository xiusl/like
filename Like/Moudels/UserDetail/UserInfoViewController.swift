//
//  UserInfoViewController.swift
//  Like
//
//  Created by tmt on 2020/4/21.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit

class UserInfoViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "我的信息"
        
        let avatarForm = FormModel(title: "头像", key: "avatar", value: "", placeHolder: "")
        let nameForm = FormModel(title: "名字", key: "name", value: "", placeHolder: "")
        let descForm = FormModel(title: "简介", key: "desc", value: "", placeHolder: "")
        
        self.configs.append(avatarForm)
        self.configs.append(nameForm)
        self.configs.append(nameForm)
        
        self.view.addSubview(self.tableView)
    }
    

    
    lazy var tableView: UITableView = {
        let frame = CGRect(x: 0, y: 0,
                           width: ScreenWidth,
                           height: ScreenHeight-TopSafeHeight)
        let tableView = UITableView(frame: frame)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
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
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
}

struct FormModel {
    var title: String
    var key: String
    var value: String
    var placeHolder: String
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
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupTitle(_ title: String) {
        self.titleLabel.text = title
    }
    
    func setupViews() {
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(16)
            make.centerY.equalTo(self.contentView)
        }
    }
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
}

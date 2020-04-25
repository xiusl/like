//
//  FeedbackViewCell.swift
//  Like
//
//  Created by tmt on 2020/4/24.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit

class FeedbackViewCell: UITableViewCell {

    var handleFeedback: (() -> ())?
    
    class func create(tableView: UITableView) -> FeedbackViewCell {
        let idf = NSStringFromClass(self)
        var cell: FeedbackViewCell? = tableView.dequeueReusableCell(withIdentifier: idf) as? FeedbackViewCell
        if cell == nil {
            cell = FeedbackViewCell.init(style: .default, reuseIdentifier: idf)
        }
        return cell!
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupContent(_ content: String) {
        contentLabel.text = content
    }
    
    func setupReplay(_ replay: String) {
        replayLabel.text = "Re:\(replay)"
    
        replayLabel.isHidden = replay.count <= 0
        let top = replay.count > 0 ? 8 : 0;
        replayLabel.snp.updateConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(top)
        }
    }
    
    func setupTime(_ time: String) {
        timeLabel.text = time
    }
    
    func setupUserName(_ name: String) {
        self.userButton.setTitle(name, for: .normal)
    }
    func setupIsAdmin(_ isAdmin: Bool) {
        self.userButton.isHidden = !isAdmin
        self.handleButton.isHidden = !isAdmin
    }
    
    private func setupViews() {
        contentView.addSubview(self.timeLabel)
        contentView.addSubview(self.contentLabel)
        contentView.addSubview(self.replayLabel)
        contentView.addSubview(self.lineView)
        contentView.addSubview(self.userButton)
        contentView.addSubview(self.handleButton)
        
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        replayLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-10)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        userButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(timeLabel)
        }
        handleButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(userButton.snp.bottom).offset(-2)
        }
    }
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .justified
        return label
    }()
    
    lazy var replayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .c999999
        return label
    }()
    
    lazy var lineView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .cF2F4F8
        return view
    }()
    
    lazy var userButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(.theme, for: .normal)
        button.isHidden = true
        return button
    }()
    
    lazy var handleButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(.theme, for: .normal)
        button.setTitle("回复", for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(handleButtonAction), for: .touchUpInside)
        return button
    }()
    
    @objc func handleButtonAction() {
        self.handleFeedback?()
    }
}

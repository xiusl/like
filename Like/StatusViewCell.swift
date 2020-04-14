//
//  StatusViewCell.swift
//  Like
//
//  Created by xiusl on 2019/10/15.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

protocol StatusViewCellDelegate {
    //    func statusViewCellLikeButtonClick(_ button: UIButton)
    func statusViewCellLikeButtonClick(_ cell: StatusViewCell)
}

protocol StatusViewCellData {
    func setupUserAvatar(_ avatar: String)
    func setupUserName(_ name: String)
    func setupContent(_ content: String)
    func setupImages(_ images: Array<Image>)
    func setupLike(_ liked: Bool)
}

extension StatusViewCell: StatusViewCellData {
    func setupUserAvatar(_ avatar: String) {
        self.userView.setupAvatar(avatar)
    }
    func setupUserName(_ name: String) {
        self.userView.setupName(name)
    }
    func setupContent(_ content: String) {
        self.contentLabel.text = content
    }
    func setupLike(_ liked: Bool) {
        self.likeButton.isSelected = liked
    }
    func setupImages(_ images: Array<Image>) {
        if images.count == 0 {
            self.photoView.snp.updateConstraints { (make) in
                make.height.equalTo(0)
                make.width.equalTo(0)
            }
            return
        }
        let image = images[0]
        
        
        let scale = UIScreen.main.scale
        var w = CGFloat(image.width)
        var h = CGFloat(image.height)
        let photo_scale = h / w
        let maxW: CGFloat = (ScreenWidth-32)*0.68 * scale
        if w > maxW {
            w = maxW
            h = maxW * photo_scale
        }
        let url = image.url + "?imageView2/1/w/\(Int(w))/h/\(Int(h))"
        
        self.photoView.kf.setImage(with: URL(string: url))
        self.photoView.snp.updateConstraints { (make) in
            make.width.equalTo(w/scale)
            make.height.equalTo(h/scale)
        }
    }
}

class StatusViewCell: UITableViewCell {
    
    var delegate: StatusViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    class func create(tableView: UITableView) -> StatusViewCell {
        let idf = NSStringFromClass(self)
        var cell: StatusViewCell? = tableView.dequeueReusableCell(withIdentifier: idf) as? StatusViewCell
        if cell == nil {
            cell = StatusViewCell.init(style: .default, reuseIdentifier: idf)
        }
        return cell!
    }
    
    class func cellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {
        self.contentView.addSubview(self.userView)
        self.contentView.addSubview(self.contentLabel)
        self.contentView.addSubview(self.photoView)
        self.contentView.addSubview(self.likeButton)
        self.contentView.addSubview(self.timeLabel)
        self.contentView.addSubview(self.lineView)
        
        self.userView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(58)
        }
        self.contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.userView.snp.bottom).offset(2)
            make.left.equalTo(self.contentView).offset(16)
            make.right.equalTo(self.contentView).offset(-16)
        }
        
        self.photoView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentLabel.snp.bottom).offset(10)
            make.left.equalTo(self.contentView).offset(16)
            make.height.equalTo(0)
            make.width.equalTo(0)
        }
        
        self.likeButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.photoView.snp.bottom).offset(8)
            make.bottom.equalTo(self.contentView).offset(-12)
            make.right.equalTo(self.contentLabel)
        }
        
        self.timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(16)
            make.centerY.equalTo(self.likeButton.snp.centerY)
        }
        
        self.lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
            make.height.equalTo(1)
        }
    }
    
    lazy var userView: StatusUserView = {
        let userView = StatusUserView()
        
        return userView
    }()
    
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        contentLabel.textColor = .blackText
        contentLabel.numberOfLines = 0
        return contentLabel
    }()
    
    lazy var photoView: UIImageView = {
        let photoView = UIImageView()
        return photoView
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = UIColor(hex: 0x9B9C9C)
        return timeLabel
    }()
    
    lazy var likeButton: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: ScreenWidth-60-20, y: 60, width: 60, height: 32)
        btn.setTitle("点赞", for: .normal)
        btn.setTitle("已点赞", for: .selected)
        btn.setTitleColor(.theme, for: .normal)
        btn.setTitleColor(.blackText, for: .selected)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(okButtonClick(_:)), for: .touchUpInside)
        btn.tag = 101
        return btn
    }()
    
    lazy var lineView: UIImageView = {
        let lineView = UIImageView()
        lineView.backgroundColor = UIColor(hex: 0xF8F8F8)
        return lineView
    }()
    
    @objc func okButtonClick(_ button: UIButton) {
        self.delegate?.statusViewCellLikeButtonClick(self)
    }
}

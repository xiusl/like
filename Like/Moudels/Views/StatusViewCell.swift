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
    func statusCell(_ cell: StatusViewCell, likeClick: Any?)
    func statusCell(_ cell: StatusViewCell, userClick: Any?)
    func statusCell(_ cell: StatusViewCell, moreClick: Any?)
    func statusCell(_ cell: StatusViewCell, shareClick: Any?)
}

protocol StatusViewCellData {
    func setupContent(_ content: String)
    func setupImages(_ images: Array<Image>)
    func setupLike(_ liked: Bool, count: Int)
}

extension StatusViewCell: StatusViewCellData, StatusUserViewData {
    func setupAvatar(_ avatar: String) {
        userView.setupAvatar(avatar)
    }
    func setupName(_ name: String) {
        userView.setupName(name)
    }
    func setupDesc(_ desc: String) {
        userView.setupDesc(desc)
    }
    func setupContent(_ content: String) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        
        let attrDict: Dictionary<NSAttributedString.Key, Any> =
            [.font: UIFont.systemFont(ofSize: 14),
             .paragraphStyle: style,
             .foregroundColor: UIColor.blackText]
        let attr = NSMutableAttributedString(string: content,
                                             attributes: attrDict)
        contentLabel.attributedText = attr
    }
    func setupLike(_ liked: Bool, count: Int) {
        likeButton.isSelected = liked
        
        let title = count > 0 ? "\(count)" : ""
        likeButton.setTitle(title, for: .normal)
    }
    func setupImages(_ images: Array<Image>) {
        if images.count == 0 {
            photoView.snp.updateConstraints { (make) in
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
        self.contentView.addSubview(self.shareButton)
        self.contentView.addSubview(self.likeButton)
        self.contentView.addSubview(self.lineView)
        
        self.userView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(44)
        }
        self.contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.userView.snp.bottom)
            make.left.equalTo(self.contentView).offset(16)
            make.right.equalTo(self.contentView).offset(-16)
        }
        self.photoView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentLabel.snp.bottom).offset(6);
            make.left.equalTo(self.contentView).offset(16)
            make.height.equalTo(0)
            make.width.equalTo(0)
        }
        
        self.likeButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.photoView.snp.bottom)
            make.left.equalTo(self.contentView.snp.right).offset(-88)
            make.bottom.equalTo(self.contentView).offset(-6)
            make.height.equalTo(30)
        }
        
        self.shareButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.centerY.equalTo(self.likeButton)
        }
        
        self.lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
            make.height.equalTo(1)
        }
        
        self.userView.userActionHandle = { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.statusCell(self, userClick: nil)
        }
        
        self.userView.moreActionHandle = { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.statusCell(self, moreClick: nil)
        }
    }
    
    lazy var userView: StatusUserView = {
        let userView = StatusUserView()
        
        return userView
    }()
    
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = .blackText
        contentLabel.numberOfLines = 0
        return contentLabel
    }()
    
    lazy var photoView: UIImageView = {
        let photoView = UIImageView()
        return photoView
    }()
    
    lazy var likeButton: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: ScreenWidth-60-20, y: 60,
                           width: 60, height: 32)
        btn.setImage(UIImage(named: "icon_digg"), for: .normal)
        btn.setImage(UIImage(named: "icon_diggs"), for: .selected)
        btn.setTitleColor(.cC9C9C9, for: .normal)
        btn.setTitleColor(.theme, for: .selected)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.addTarget(self, action: #selector(diggButtonAction), for: .touchUpInside)
        btn.contentHorizontalAlignment = .left
        btn.titleEdgeInsets = UIEdgeInsets(top: 3,
                                           left: 0,
                                           bottom: -3,
                                           right: 0)
        btn.tag = 101
        return btn
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_share"),
                        for: .normal)
        button.addTarget(self, action: #selector(shareButtonAction), for: .touchUpInside)
        return button;
    }()
    
    lazy var lineView: UIImageView = {
        let lineView = UIImageView()
        lineView.backgroundColor = UIColor(hex: 0xF8F8F8)
        return lineView
    }()
    
    @objc
    private func diggButtonAction() {
        self.delegate?.statusCell(self, likeClick: nil)
    }
    
    @objc
    private func shareButtonAction() {
        self.delegate?.statusCell(self, shareClick: nil)
    }
}

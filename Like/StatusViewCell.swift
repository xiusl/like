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
    func statusViewCellLikeButtonClick(_ button: UIButton)
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
    
    func setupImages(_ images: Array<JSON>) {
        if images.count > 0 {
            let img = images[0]
            
            
            let scale = UIScreen.main.scale
            var w = CGFloat(img["width"].intValue)
            var h = CGFloat(img["height"].intValue)
            let photo_scale = h / w
            let maxW: CGFloat = (ScreenWidth-32)*0.68 * scale
            if w > maxW {
                w = maxW
                h = maxW * photo_scale
            }
            var url = img["url"].stringValue
            url = url + "?imageView2/1/w/\(Int(w))/h/\(Int(h))"
            
            self.photoView.kf.setImage(with: URL(string: url))
            self.photoView.snp.updateConstraints { (make) in
                make.width.equalTo(w/scale)
                make.height.equalTo(h/scale)
            }
        } else {
            self.photoView.snp.updateConstraints { (make) in
                make.height.equalTo(0)
                make.width.equalTo(0)
            }
        }
    }
    
    func setupTime(_ time: String) {
        let format = DateFormatter()
        format.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        let date = format.date(from: time)

        guard let d = date else {
            self.timeLabel.text = ""
            return
        }
        let format2 = DateFormatter()
        format2.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.timeLabel.text = format2.string(from: d)
        
    }
    
    func setupViews() {
        self.contentView.addSubview(self.contentLabel)
        self.contentView.addSubview(self.photoView)
        self.contentView.addSubview(self.likeButton)
        self.contentView.addSubview(self.timeLabel)
        
        self.contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(12)
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
    }
    
    
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
    
    @objc func okButtonClick(_ button: UIButton) {
        self.delegate?.statusViewCellLikeButtonClick(button)
    }
}

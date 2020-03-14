//
//  ArticleViewCell.swift
//  Like
//
//  Created by xiusl on 2019/10/28.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ArticleViewCellDelegate {
    func articleViewCellLikeButtonClick(_ button: UIButton)
    func articleViewCell(cell: ArticleViewCell, shareIndex: Int)
}

class ArticleViewCell: UITableViewCell {

    
    var delegate: ArticleViewCellDelegate?
    open var index: Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    class func create(tableView: UITableView) -> ArticleViewCell {
        let idf = NSStringFromClass(self)
        var cell: ArticleViewCell? = tableView.dequeueReusableCell(withIdentifier: idf) as? ArticleViewCell
        if cell == nil {
            cell = ArticleViewCell.init(style: .default, reuseIdentifier: idf)
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
        self.contentView.addSubview(self.contentLabel)
        self.contentView.addSubview(self.imagesView)
        self.contentView.addSubview(self.likeButton)
        
        self.contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(12)
            make.left.equalTo(self.contentView).offset(16)
            make.right.equalTo(self.contentView).offset(-16)
        }
        
        let h = (ScreenWidth - 32.0 - 8) * 0.5 * 3 / 5.0
        self.imagesView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentLabel.snp.bottom).offset(8)
            make.left.right.equalTo(self.contentLabel)
            make.height.equalTo(h)
        }
        
        self.likeButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentLabel.snp.bottom).offset(h+16)
            make.bottom.equalTo(self.contentView).offset(-12)
            make.right.equalTo(self.contentLabel)
        }
    }
    
    public func setImages(_ images: Array<JSON>) {
        var h = (ScreenWidth - 32.0 - 8) * 0.5 * 3 / 5.0
        if images.count > 1 {
            self.imagesView.isHidden = false
            h += 16
        } else {
            self.imagesView.isHidden = true
            h = 8
        }
        self.likeButton.snp.updateConstraints { (make) in
            make.top.equalTo(self.contentLabel.snp.bottom).offset(h)
        }
        self.imagesView.setImages(images)
    }
    
    
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        contentLabel.textColor = .blackText
        contentLabel.numberOfLines = 0
        return contentLabel
    }()
    
    lazy var likeButton: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: ScreenWidth-60-20, y: 60, width: 60, height: 32)
        btn.setTitle("分享", for: .normal)
        btn.setTitle("已点赞", for: .selected)
        btn.setTitleColor(.theme, for: .normal)
        btn.setTitleColor(.blackText, for: .selected)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(okButtonClick(_:)), for: .touchUpInside)
        btn.tag = 101
        return btn
    }()
    
    lazy var imagesView: ArticleImagesView = {
        let imagesView: ArticleImagesView = ArticleImagesView()
        return imagesView
    }()
    
    @objc func okButtonClick(_ button: UIButton) {
        self.delegate?.articleViewCell(cell: self, shareIndex: self.index)
    }
}


class ArticleImagesView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var consLeft = self.snp.left
        var firstV: UIImageView!
        for i in 0..<2 {
            let imv = UIImageView()
            imv.contentMode = .scaleAspectFill
            imv.clipsToBounds = true
            self.addSubview(imv)
            
            if i == 0 {
                imv.snp.makeConstraints { (make) in
                    make.left.equalTo(consLeft)
                    make.top.bottom.equalTo(self)
                }
                consLeft = imv.snp.right
                firstV = imv
            } else {
                imv.snp.makeConstraints { (make) in
                    make.left.equalTo(consLeft).offset(10)
                    make.right.equalTo(self)
                    make.width.equalTo(firstV)
                    make.top.bottom.equalTo(self)
                }
            }
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setImages(_ images: Array<JSON>) {
        var i = 0
        for subv in self.subviews {
            if i >= images.count {
                subv.isHidden = true
                continue
            }
            subv.isHidden = false
            let v: UIImageView = subv as! UIImageView
            let url = images[i].stringValue
            print(url)
            v.kf.setImage(with: URL(string: url))
            i += 1
        }
    }
    
    
}

//
//  MeTableHeaderView.swift
//  Like
//
//  Created by xiusl on 2019/10/14.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit

class MeTableHeaderView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.avatarView.layer.cornerRadius = 24
        self.avatarView.clipsToBounds = true
    }
}

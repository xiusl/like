//
//  BaseTableView.swift
//  Like
//
//  Created by xiusl on 2019/10/11.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit

class BaseTableView: UITableView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }
    
}

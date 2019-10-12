//
//  util.swift
//  XiaoQinTong
//
//  Created by xiusl on 2019/7/30.
//  Copyright © 2019 yueyilan. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: UInt64) {
        let r = (hex & 0xff0000) >> 16
        let g = (hex & 0xff00) >> 8
        let b = hex & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
    
    convenience init(hex: UInt64, alpha: CGFloat) {
        let r = (hex & 0xff0000) >> 16
        let g = (hex & 0xff00) >> 8
        let b = hex & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: alpha
        )
    }
    
    open class var theme: UIColor {
        return UIColor(hex: 0x44C7FB)
    }
}

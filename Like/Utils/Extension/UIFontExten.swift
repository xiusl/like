//
//  UIFontExten.swift
//  XiaoQinTong
//
//  Created by xiusl on 2019/9/9.
//  Copyright © 2019 yueyilan. All rights reserved.
//

import UIKit

extension UIFont {
    class func systemFontBold(ofSize fontSize: CGFloat) -> UIFont {
        if #available(iOS 8.2, *) {
            return self.systemFont(ofSize: fontSize, weight: .bold)
        } else {
            return self.systemFont(ofSize: fontSize)
        }
    }
    
    class func systemFontMedium(ofSize fontSize: CGFloat) -> UIFont {
        if #available(iOS 8.2, *) {
            return self.systemFont(ofSize: fontSize, weight: .medium)
        } else {
            return self.systemFont(ofSize: fontSize)
        }
    }
}

extension UIImage {
    class func imageWith(color: UIColor) -> UIImage {
        let frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(frame.size)
        let ctx: CGContext = UIGraphicsGetCurrentContext()!
        ctx.setFillColor(color.cgColor)
        ctx.fill(frame)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

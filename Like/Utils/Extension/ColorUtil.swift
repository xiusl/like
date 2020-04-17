//
//  util.swift
//  XiaoQinTong
//
//  Created by xiusl on 2019/7/30.
//  Copyright © 2019 yueyilan. All rights reserved.
//

import UIKit

extension UIImage {
    public convenience init?(color: UIColor, w: CGFloat = 1, h: CGFloat = 1) {
            let size = CGSize(width: w, height: h)

            UIGraphicsBeginImageContext(size)
           defer {
               UIGraphicsEndImageContext()
           }
           let context = UIGraphicsGetCurrentContext()
           context?.setFillColor(color.cgColor)
           context?.fill(CGRect(origin: CGPoint.zero, size: size))
           context?.setShouldAntialias(true)
           let image = UIGraphicsGetImageFromCurrentImageContext()
           guard let cgImage = image?.cgImage else {
               self.init()
               return nil
           }
           self.init(cgImage: cgImage)
       }
}

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
    open class var blackText: UIColor {
        return UIColor(hex: 0x1A2C3F)
    }
    
    open class var cF2F4F8: UIColor {
        return UIColor(hex: 0xF2F4F8)
    }
    
}

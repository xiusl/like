//
//  ConstUtil.swift
//  XiaoQinTong
//
//  Created by xiusl on 2019/7/30.
//  Copyright © 2019 yueyilan. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height

let StatusBarHeight = UIApplication.shared.statusBarFrame.size.height

let TopSafeHeight = 44+StatusBarHeight
let BottomSafeHeight: CGFloat = 35.0

let TabbarHeight: CGFloat = 49.0



class SLUtil {
    class func checkPhone(phone: String) -> Bool {
        let phoneRe: String = "^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$"
        
        let regextestPhone: NSPredicate = NSPredicate(format:"SELF MATCHES %@", phoneRe)
        return regextestPhone.evaluate(with: phone)
    }
    
    class func checkIdCard(idCard: String) -> Bool {
        let idCardRe: String = "(^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$)|(^[1-9]\\d{5}\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{2}$)"
        
        let regextestIdCard: NSPredicate = NSPredicate(format:"SELF MATCHES %@", idCardRe)
        return regextestIdCard.evaluate(with: idCard)
    }
    
    class func checkPassword(passwd: String) -> Bool {
        return passwd.count > 5 && passwd.count < 13
    }
    
    class func md5(orgStr: String, solt: String?) -> String! {
        let soltStr = orgStr + (solt ?? "")
        let str = soltStr.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(soltStr.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return String(format: hash as String)
    }
    
    class func showMessage(_ msg: String) {
        let view = UIApplication.shared.keyWindow
        let hud = ProgressHUD.showHUD(toView: view!, animated: true)
        hud.backgroundView.color = UIColor(white: 0, alpha: 0.0)
        hud.bezelView.style = .solidColor
        hud.bezelView.color = UIColor.black
        hud.label.textColor = .white
        hud.label.font = UIFont.systemFontMedium(ofSize: 20)
        hud.label.text = msg
        hud.hide(animated: true, afterDelay: 1.2)
    }
}


extension Notification.Name {
    /// 用户退出
    static let UserLogoutNoti = Notification.Name(rawValue:"UserLogoutNoti")
    /// 用户登录
    static let UserLoginNoti = Notification.Name(rawValue:"UserLoginNoti")
    /// 用户认证
    static let UserVerifyNoti = Notification.Name(rawValue:"UserVerifyNoti")
}

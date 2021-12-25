//
//  LkRoute.swift
//  Like
//
//  Created by szhd on 2021/12/25.
//  Copyright © 2021 likeeee. All rights reserved.
//

import Foundation
import UIKit

class LkRoute {
    class func loginVc() -> UIViewController {
        let nav = MainNavigationController(rootViewController: LkSmsLoginViewController())
        nav.modalPresentationStyle = .fullScreen
        return nav
    }
}

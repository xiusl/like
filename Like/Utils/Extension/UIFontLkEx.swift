//
//  UIFontLkEx.swift
//  Like
//
//  Created by szhd on 2021/12/25.
//  Copyright © 2021 likeeee. All rights reserved.
//

import UIKit

extension UIFont {
    class func lkFont(ofSize size: CGFloat) -> UIFont {
        return .systemFont(ofSize: calc(size))
    }
    class func lkFont(ofSize size: CGFloat, weight: Weight) -> UIFont {
        return .systemFont(ofSize: calc(size), weight: weight)
    }
}

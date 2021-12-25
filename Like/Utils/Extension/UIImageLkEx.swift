//
//  UIImageLkEx.swift
//  Like
//
//  Created by szhd on 2021/12/25.
//  Copyright © 2021 likeeee. All rights reserved.
//

import UIKit

extension UIImage {
    open func original() -> UIImage {
        return self.withRenderingMode(.alwaysOriginal)
    }
}


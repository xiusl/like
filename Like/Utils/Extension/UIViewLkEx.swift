//
//  UIViewLkEx.swift
//  Like
//
//  Created by szhd on 2021/12/25.
//  Copyright © 2021 likeeee. All rights reserved.
//

import UIKit

extension UIView {
    func animationRemove() {
        UIView.animate(withDuration: 0.12) {
            self.alpha = 0.00001
        } completion: { flag in
            self.removeFromSuperview()
            self.alpha = 1
        }
    }
}

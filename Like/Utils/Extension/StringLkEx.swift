//
//  StringLkEx.swift
//  Like
//
//  Created by szhd on 2021/12/25.
//  Copyright © 2021 likeeee. All rights reserved.
//

import Foundation

extension String {
    subscript(index: Int) -> String {
        get {
            return String(self[self.index(self.startIndex, offsetBy: index)])
        }
        set {
            let tmp = self
            self = ""
            for (idx, str) in tmp.enumerated() {
                if idx == index {
                    self += "\(newValue)"
                } else {
                    self += "\(str)"
                }
                    
            }
        }
    }
}

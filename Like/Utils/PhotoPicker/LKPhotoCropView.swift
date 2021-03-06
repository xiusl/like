//
//  LKPhotoCropView.swift
//  Like
//
//  Created by tmt on 2020/5/9.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit

class LKPhotoCropView: UIView {

    let imageView = UIImageView()
    let cropArea = UIView()
    
    convenience init(image: UIImage, frame: CGRect) {
        self.init(frame: frame)
        addSubview(imageView)
        addSubview(cropArea)
        imageView.image = image
        setupLayout(with: image)
        applyStyle()
    }

    private func setupLayout(with image: UIImage) {
        
        let imageRatio: Double = Double(image.size.width / image.size.height)
        
        let w = self.frame.size.width - 32
        cropArea.bounds = CGRect(x: 0, y: 0, width: w, height: w)
        cropArea.center = self.center
        
        if imageRatio < 1 { // 长图
            let scaledDownRatio = w / image.size.width
            imageView.frame.size.width = image.size.width * scaledDownRatio
            
            imageView.frame.size.height = imageView.frame.size.width / CGFloat(imageRatio)
            
        } else if imageRatio > 1 { // 宽图
            imageView.frame.size.height = w
            imageView.frame.size.width = imageView.frame.size.height * CGFloat(imageRatio)
        } else {
            imageView.frame.size = cropArea.frame.size
        }
         imageView.center = self.center
    }
    
    private func applyStyle() {
        clipsToBounds = true
        
        imageView.isUserInteractionEnabled = true
        imageView.isMultipleTouchEnabled = true
        
        cropArea.backgroundColor = .clear
        cropArea.isUserInteractionEnabled = false
        cropArea.layer.borderWidth = 1
        cropArea.layer.borderColor = UIColor.red.cgColor
    }
}

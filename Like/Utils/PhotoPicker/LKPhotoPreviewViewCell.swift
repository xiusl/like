//
//  LKPhotoPreviewViewCell.swift
//  Like
//
//  Created by xiusl on 2019/11/25.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit
import Photos

class LKPhotoPreviewViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.scrollView)
        self.scrollView.addSubview(self.imageView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = self.bounds
        return imageView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = self.bounds
        scrollView.contentSize = self.bounds.size
        return scrollView
    }()
    
    func setup(asset: LKAsset) {
        guard let mod = asset.asset else { return }
        /*
         CGSize imageSize;
         if (photoWidth < TZScreenWidth && photoWidth < _photoPreviewMaxWidth) {
             imageSize = AssetGridThumbnailSize;
         } else {
             PHAsset *phAsset = (PHAsset *)asset;
             CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
             CGFloat pixelWidth = photoWidth * TZScreenScale;
             // 超宽图片
             if (aspectRatio > 1.8) {
                 pixelWidth = pixelWidth * aspectRatio;
             }
             // 超高图片
             if (aspectRatio < 0.2) {
                 pixelWidth = pixelWidth * 0.5;
             }
             CGFloat pixelHeight = pixelWidth / aspectRatio;
             imageSize = CGSizeMake(pixelWidth, pixelHeight);
         }
         */
        let photoWidth = self.imageView.frame.size.width
        var size = PHImageManagerMaximumSize
        
        let phAsset = mod
        let aspectRatio =  CGFloat(phAsset.pixelWidth) / CGFloat(phAsset.pixelHeight)
        var pixelWidth = photoWidth * 2
        if aspectRatio > 1.8 {
            pixelWidth = pixelWidth * aspectRatio
        }
        if aspectRatio < 0.2 {
            pixelWidth = pixelWidth * 0.5
        }
        let pixelHeight = pixelWidth / aspectRatio
        size = CGSize(width: pixelWidth, height: pixelHeight)
        
        let t = (self.frame.size.height - pixelHeight) / 2.0
        self.imageView.frame = CGRect(x: 0, y: t, width: photoWidth, height: pixelHeight)
        
        let opt: PHImageRequestOptions = PHImageRequestOptions()
        opt.resizeMode = .fast
        opt.isNetworkAccessAllowed = true
        let _ = PHImageManager.default().requestImage(for: mod, targetSize: size, contentMode: .default, options: opt) { (image, _) in
            self.imageView.image = image
        }
    }
    
}

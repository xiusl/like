//
//  LKPhotoViewCell.swift
//  Like
//
//  Created by xiusl on 2019/11/22.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit
import Photos

class LKPhotoViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.selectButton)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = self.bounds
        return imageView
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
        if photoWidth < 400 {
            size = CGSize(width: photoWidth*2, height: photoWidth*2)
        } else {
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
        }
        
        
        let opt: PHImageRequestOptions = PHImageRequestOptions()
        opt.resizeMode = .fast
        opt.isNetworkAccessAllowed = true
        let _ = PHImageManager.default().requestImage(for: mod, targetSize: size, contentMode: .default, options: opt) { (image, _) in
            self.imageView.image = image
        }
    }
    
    lazy var selectButton: UIButton = {
        let selectButton = UIButton()
        let w = self.contentView.frame.size.width
        selectButton.frame = CGRect(x: w-34, y: -10, width: 44, height: 44)
        selectButton.setImage(UIImage(named: "photo_picker_nor"), for: .normal)
        selectButton.setImage(UIImage(named: "photo_picker_sel"), for: .selected)
        selectButton.addTarget(self, action: #selector(selectButtonClick(_:)), for: .touchUpInside)
        return selectButton
    }()
    
    @objc func selectButtonClick(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
    }
}

//
//  PhotoZoomableView.swift
//  Like
//
//  Created by tmt on 2020/5/7.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit
import Photos

class PhotoZoomableView: UIScrollView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.config()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.config()
    }
    
    private func config() {
        backgroundColor = UIColor.white;
        frame.size = CGSize.zero
        clipsToBounds = true
        photoImageView.frame = CGRect(origin: CGPoint.zero, size: CGSize.zero)
        maximumZoomScale = 6.0
        minimumZoomScale = 1
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delegate = self
        alwaysBounceHorizontal = true
        alwaysBounceVertical = true
        isScrollEnabled = true
        contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    lazy var photoImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    fileprivate var currentAsset: PHAsset?
    
    public func setImage(_ photo: LKAsset) {
        guard currentAsset != photo.asset else {
            return
        }
        guard let currentAsset = photo.asset else {
            return
        }
        
        PHImageManager.default().requestImage(for: currentAsset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil) { [weak self] (image, _) in
            guard let `self` = self else { return }
            if self.photoImageView.isDescendant(of: self) == false {
                self.addSubview(self.photoImageView)
            
                self.photoImageView.contentMode = .scaleAspectFill
                self.photoImageView.clipsToBounds = true
            }
        
            self.photoImageView.image = image
            self.setAssetFrame(image: image)
        }
        
    }
    
    public var minWidth: CGFloat? = 400
    
    private func setAssetFrame(image: UIImage?) {
        guard let image = image else {
            return
        }
        self.minimumZoomScale = 1
        self.zoomScale = 1
        
        let screenWidth: CGFloat = UIScreen.main.bounds.width - 32
        let w = image.size.width
        let h = image.size.height
        
        var aspectRatio: CGFloat = 1
        var zoomScale: CGFloat = 1
        
        let view = self.photoImageView
        
        if w > h { // Landscape
            aspectRatio = h / w
            view.frame.size.width = screenWidth
            view.frame.size.height = screenWidth * aspectRatio
        } else if h > w { // Portrait
            aspectRatio = w / h
            view.frame.size.width = screenWidth * aspectRatio
            view.frame.size.height = screenWidth
            
            if let minWidth = minWidth {
                let k = minWidth / screenWidth
                zoomScale = (h / w) * k
            }
        } else { // Square
            view.frame.size.width = screenWidth
            view.frame.size.height = screenWidth
        }
        
        // Centering image view
        view.center = center
        centerAssetView()
        
        // Setting new scale
        minimumZoomScale = zoomScale
        self.zoomScale = zoomScale
    }
 
    func centerAssetView() {
        let assetView = self.photoImageView
        let scrollViewBoundsSize = self.bounds.size
        var assetFrame = assetView.frame
        let assetSize = assetView.frame.size
        
        assetFrame.origin.x = (assetSize.width < scrollViewBoundsSize.width) ?
            (scrollViewBoundsSize.width - 20 - assetSize.width) / 2.0 : 0
        assetFrame.origin.y = (assetSize.height < scrollViewBoundsSize.height) ?
            (scrollViewBoundsSize.height - assetSize.height) / 2.0 : 0.0
        
        assetView.frame = assetFrame
        
        let h = assetSize.height
        var m = (h - (scrollViewBoundsSize.width-32)) * 0.5
        m = (scrollViewBoundsSize.height - (scrollViewBoundsSize.width-32))*0.5
        if m > 0 {
            self.contentInset = UIEdgeInsets(top: m, left: 16, bottom: m, right: 16)
        }
    }
}


extension PhotoZoomableView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        centerAssetView()
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
    }
}

//
//  LKPhotoBrowser.swift
//  Input
//
//  Created by xiusl on 2020/5/28.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit


class LKPhotoBrowserModel: NSObject {
    var url: String
    var srcView: UIView
    var srcImage: UIImage
    
    override init() {
        url = ""
        srcView = UIView()
        srcImage = UIImage()
        super.init()
    }
    
    convenience init(url: String, srcView: UIView, srcImage: UIImage) {
        self.init()
        self.url = url
        self.srcView = srcView
        self.srcImage = srcImage
    }
}

class LKPhotoBrowser: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = UIScreen.main.bounds
        backgroundColor = UIColor(white: 0, alpha: 1)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var photos: Array<LKPhotoBrowserModel> = []
    open func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        if photos.count >= 0 {
            showImage(atIndex: 0)
        }
    }
    
    func setup(_ photos: Array<LKPhotoBrowserModel>) {
        self.photos = photos
        
        
    }
    
    private func setupViews() {
        addSubview(photoView)
        
        photoView.singleTapCallback = { [weak self] in
            guard let `self` = self else {return}
            self.backgroundColor = .clear
            self.alpha = 0
        }
        
        photoView.photoViewDidEndZoom = { [weak self] in
            guard let `self` = self else {return}
            self.removeFromSuperview()
        }
    }
    
    private func showImage(atIndex index:Int) {
        /*
         CGRect bounds = _photoScrollView.bounds;
         CGRect photoViewFrame = bounds;
         photoViewFrame.size.width -= (2 * kPadding);
         photoViewFrame.origin.x = (bounds.size.width * index) + kPadding;
         photoView.tag = kPhotoViewTagOffset + index;
         
         MJPhoto *photo = _photos[index];
         photoView.frame = photoViewFrame;
         photoView.photo = photo;
         */
        let kPadding: CGFloat = 0
        let kPhotoViewTagOffset: Int = 10086
        
        let bounds = self.bounds
        var photoViewFrame = bounds
        photoViewFrame.size.width -= (2 * kPadding)
        photoViewFrame.origin.x = kPadding
        photoView.tag = kPhotoViewTagOffset + index
        
        let photo = photos[index]
        photoView.frame = photoViewFrame
        photoView.setup(photo)
        
    }
    
    lazy var photoView: LKPhotoBrowserView = {
        let view = LKPhotoBrowserView()
        return view
    }()

}



class LKPhotoBrowserView : UIScrollView {
    
    var singleTapCallback: (() -> ())?
    var photoViewDidEndZoom: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        
        self.delegate = self
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        singleTap.delaysTouchesBegan = true
        singleTap.numberOfTapsRequired = 1
        addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTap)
    }
    
    private var doubleTap: Bool = false
    
    @objc
    private func handleSingleTap(_ tap: UITapGestureRecognizer) {
        doubleTap = false
        self.perform(#selector(dismiss), with: self, afterDelay: 0.2)
    }

    @objc
    private func dismiss() {
        if doubleTap { return }
        guard let photo = lkPhoto else {
            return
        }
        
        contentOffset = .zero
        let duration = 0.35
        
        UIView.animate(withDuration: duration, animations: {
            self.imageView.frame = photo.srcView.convert(photo.srcView.bounds, to: nil)
            
            self.singleTapCallback?()
        }) { (finished) in
            self.photoViewDidEndZoom?()
        }
    }
    
    @objc
    private func handleDoubleTap(_ tap: UITapGestureRecognizer) {
        doubleTap = true
        let touchPoint =  tap.location(in: self)
        if zoomScale == maximumZoomScale {
            setZoomScale(minimumZoomScale, animated: true)
        } else {
            zoom(to: CGRect(x: touchPoint.x, y: touchPoint.y, width: 1, height: 1), animated: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private var lkPhoto: LKPhotoBrowserModel?
    func setup(_ photo: LKPhotoBrowserModel) {
        lkPhoto = photo
        
        showImage()
    }
    
    private func showImage() {
        guard let photo = lkPhoto else {return}
        
        imageView.kf.setImage(with: URL(string: photo.url), placeholder: nil, options: nil, progressBlock: { (progress, all) in
            
        }) { (result) in
            switch result {
            case .success(let res):
                self.adjustFrame()
                print(res)
            case .failure(let error):
                print(error)
            }
        }
    }
    private func adjustFrame() {
        guard let image = imageView.image else {
            return
        }
        guard let photo = lkPhoto else {
            return
        }
        
        let boundsSize = bounds.size
        let boundsWidth = boundsSize.width
        let boundsHeight = boundsSize.height
        
        let imageSize = image.size
        let imageWidth = imageSize.width
        let imageHeight = imageSize.height
        
        var minScale = boundsWidth / imageWidth
        if (minScale > 1) {
            minScale = 1
        }
        var maxScale: CGFloat = 2.0
        maxScale = maxScale / UIScreen.main.scale
        
        maximumZoomScale = maxScale
        minimumZoomScale = minScale
        zoomScale = minScale
        
        var imageFrame = CGRect(x: 0, y: 0, width: boundsWidth, height: imageHeight * boundsWidth / imageWidth)
        
        contentSize = CGSize(width: 0, height: imageFrame.size.height)
    
        if imageFrame.size.height < boundsHeight {
            imageFrame.origin.y = CGFloat(floorf(Float((boundsHeight-imageFrame.size.height) / 2)))
        } else {
            imageFrame.origin.y = 0
        }
        
        imageView.frame = photo.srcView.convert(photo.srcView.frame, to: nil)
        UIView.animate(withDuration: 0.35) {
            self.imageView.frame = imageFrame
        }
    }
}

extension LKPhotoBrowserView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let delta_x = scrollView.bounds.size.width > scrollView.contentSize.width ? (scrollView.bounds.size.width-scrollView.contentSize.width)/2 : 0
        
        let delta_y = scrollView.bounds.size.height > scrollView.contentSize.height ? (scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0;
        
        imageView.center = CGPoint(x: scrollView.contentSize.width/2 + delta_x, y: scrollView.contentSize.height/2 + delta_y)
    }
}

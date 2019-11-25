//
//  LKPhotoPickerViewController.swift
//  Like
//
//  Created by xiusl on 2019/11/22.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit
import PhotosUI
import Photos

protocol LKPhotoPickerViewControllerDelegate {
    func photoPickerViewController(controller: LKPhotoPickerViewController, selectPhotos: Array<LKAsset>)
    func photoPickerViewController(controller: LKPhotoPickerViewController, selectAssets: Array<LKAsset>, selectPhotos: Array<UIImage>)
}

class LKPhotoPickerViewController: UINavigationController {

    var lk_delegate: LKPhotoPickerViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    private override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    init(withOldImage: Array<PHAsset>) {
        let vc = LKPhotoPickerRootViewController()
        super.init(rootViewController: vc)
    }
    init(originalPhoto: Bool) {
        let vc = LKPhotoPickerRootViewController()
        super.init(rootViewController: vc)
    }

    
}
class LKPhotoPickerRootViewController: UIViewController {

    var currentAlbum: LKAlbum = LKAlbum()
    var albums: Array<LKAlbum> = []
    var selectAssets: Array<LKAsset> = []
    
    weak var navVc: LKPhotoPickerViewController?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navVc = self.navigationController as? LKPhotoPickerViewController
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        
        if PHPhotoLibrary.authorizationStatus() != .authorized {
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    debugPrint("access")
                } else {
                    debugPrint("not access")
                }
            }
        }
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.barView)
        self.barView.addSubview(self.finishButton)
//        self.barView.addSubview(self.previewButton)
        self.a()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(dismissClick))
        self.navigationItem.titleView = self.titleButton
    }
    @objc func dismissClick() {
        self.dismiss(animated: true, completion: nil)
    }
    func a() {
        let opt = PHFetchOptions()
        opt.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        opt.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let smartAlbums :PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        
        var arr: Array<LKAlbum> = []
        smartAlbums.enumerateObjects { (collection, idx, stop)  in
            if !collection.isKind(of: PHAssetCollection.self) { return }
            if collection.estimatedAssetCount <= 0 { return }
            debugPrint(collection.localizedTitle ?? "")
            debugPrint(collection.estimatedAssetCount)
            
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(in: collection, options: opt)
            
            print(fetchResult.count)
            if fetchResult.count <= 0 { return }
            
            let album = LKAlbum.create(withCollection: collection, assetResult: fetchResult)
            arr.append(album)
        }
        self.albums = arr
        self.currentAlbum = arr[0]
        self.collectionView.reloadData()
//        self.title = self.currentAlbum.name
        self.titleButton.setTitle(self.currentAlbum.name, for: .normal)
        self.tableView.reloadData()
    }
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let w = (self.view.frame.size.width - 6) / 4
        layout.itemSize = CGSize(width: w, height: w)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        
//        collectionView.register(UICollectionViewCell.Type, forCellWithReuseIdentifier: "abc123")
        collectionView.register(LKPhotoViewCell.self, forCellWithReuseIdentifier: "abc123")
        
        return collectionView
    }()

    
    lazy var tableView: UITableView = {
        let h = self.view.frame.size.height
        let frame = CGRect(x: 0, y: -h, width: self.view.frame.size.width, height: h)
        let tableView = UITableView(frame: frame)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    lazy var titleButton: UIButton = {
        let titleButton = UIButton()
        titleButton.setTitleColor(.black, for: .normal)
        titleButton.setTitleColor(.theme, for: .selected)
        titleButton.addTarget(self, action: #selector(titleButtonClick(_:)), for: .touchUpInside)
        return titleButton
    }()
    
    @objc func titleButtonClick(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        
        UIView.animate(withDuration: 0.2) {
            if btn.isSelected {
                let h = self.view.frame.size.height
                self.tableView.transform = CGAffineTransform(translationX: 0, y: h)
            } else {
                self.tableView.transform = CGAffineTransform.identity
            }
        }
    }
    
    lazy var barView: UIView = {
        let barView = UIView()
        var h: CGFloat = 48
        if UIApplication.shared.statusBarFrame.size.height > 20 {
            h += 30
        }
        let w = self.view.bounds.size.width
        let top = self.view.bounds.size.height - h
        barView.frame = CGRect(x: 0, y: top, width: w, height: h)
        barView.backgroundColor = .white
        
        let line = UIImageView()
        line.frame = CGRect(x: 0, y: 0, width: w, height: 1)
        line.backgroundColor = UIColor(hex: 0xDDE4E6)
        barView.addSubview(line)
        
        return barView
    }()
    
    lazy var finishButton: UIButton = {
        let finishButton = UIButton()
        let w = self.view.bounds.size.width
        finishButton.frame = CGRect(x: w-64-16, y: 6, width: 64, height: 36)
        finishButton.backgroundColor = .theme
        finishButton.setTitle("完成", for: .normal)
        finishButton.layer.cornerRadius = 4
        finishButton.clipsToBounds = true
        finishButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        finishButton.addTarget(self, action: #selector(finishButtonClick), for: .touchUpInside)
        return finishButton
    }()

    lazy var previewButton: UIButton = {
        let previewButton = UIButton()
        previewButton.frame = CGRect(x: 16, y: 6, width: 64, height: 36)
        previewButton.setTitle("预览", for: .normal)
        previewButton.setTitleColor(.blackText, for: .normal)
        previewButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return previewButton
    }()
    
    @objc func finishButtonClick() {
        let photos = self.fetchImages()
        self.navVc?.lk_delegate?.photoPickerViewController(controller: self.navVc!, selectAssets: self.selectAssets, selectPhotos: photos)
        self.navVc?.dismiss(animated: true, completion: nil)
    }
    
    func fetchImages() -> Array<UIImage> {
        var photos: Array<UIImage> = []
        for i in 0..<self.selectAssets.count {
            print("idx: %d", i)
            photos.append(UIImage())
        }
        
        for i in 0..<self.selectAssets.count {
            let asset = self.selectAssets[i]
            let photoWidth: CGFloat = 400
            var size = PHImageManagerMaximumSize
            if photoWidth < 400 {
                size = CGSize(width: photoWidth*2, height: photoWidth*2)
            } else {
                let phAsset = asset.asset!
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
            let _ = PHImageManager.default().requestImage(for: asset.asset!, targetSize: size, contentMode: .default, options: opt) { (image, _) in
                photos[i] = image ?? UIImage()
            }
        }
        return photos
    }
}
extension LKPhotoPickerRootViewController: UICollectionViewDataSource, UICollectionViewDelegate, LKPhotoViewCellDelegate, LKPhotoPickerPreviewViewControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currentAlbum.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "abc123", for: indexPath) as! LKPhotoViewCell
        
        cell.setup(asset: self.currentAlbum.models[indexPath.row])
        
        cell.delegate = self
        
        let mdo = self.currentAlbum.models[indexPath.row]
        if self.containAsset(asset: mdo) {
            let reIdx = self.indexAsset(asset: mdo)
            let t = String(format: "%d", reIdx+1)
            cell.selectButton.setTitle(t, for: .normal)
            cell.selectButton.isSelected = true
        } else {
            cell.selectButton.setTitle("", for: .normal)
            cell.selectButton.isSelected = false
        }
        
        return cell
    }
    
    func photoViewCell(cell: LKPhotoViewCell, selectButton: UIButton) {
        let idx = self.collectionView.indexPath(for: cell)!
        let mdo = self.currentAlbum.models[idx.row]
        
        if selectButton.isSelected {
//            if !self.selectAssets.contains(mdo) {
//
//            }
            if !self.containAsset(asset: mdo) {
                self.selectAssets.append(mdo)
            }
//            let t = String(format: "%d", self.selectAssets.count)
//            selectButton.setTitle(t, for: .normal)
            
            self.collectionView.reloadData()
        } else {
            
            if self.containAsset(asset: mdo) {
                let reIdx = self.indexAsset(asset: mdo)
                self.selectAssets.remove(at: reIdx)
            }
            
            self.collectionView.reloadData()
        }
        
        var title = "完成"
        if self.selectAssets.count > 0 {
            title = String(format: "完成(%d)", self.selectAssets.count)
        }
        self.finishButton.setTitle(title, for: .normal)
    }
        
    func containAsset(asset: LKAsset) -> Bool {
        for old_asset in self.selectAssets {
            if old_asset.asset?.localIdentifier == asset.asset?.localIdentifier {
                return true
            }
        }
        return false
    }
    func indexAsset(asset: LKAsset) -> Int {
        var i = 0
        for old_asset in self.selectAssets {
            if old_asset.asset?.localIdentifier == asset.asset?.localIdentifier {
                return i
            }
            i += 1
        }
        return i
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = LKPhotoPickerPreviewViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.assets = self.currentAlbum.models
        vc.selectAssets = self.selectAssets
        vc.currentIndex = indexPath.row
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func previewViewController(cancleClick selectAssets: Array<LKAsset>) {
        self.selectAssets = selectAssets
        self.collectionView.reloadData()
    }
    
    func previewViewController(finishClick selectAssets: Array<LKAsset>) {
        self.selectAssets = selectAssets
        let photos = self.fetchImages()
        self.navVc?.lk_delegate?.photoPickerViewController(controller: self.navVc!, selectAssets: self.selectAssets, selectPhotos: photos)
    }
}

extension LKPhotoPickerRootViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "UITableViewCell")
        }
        
        let album = self.albums[indexPath.row]
        
        cell?.textLabel?.text = album.name
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentAlbum = self.albums[indexPath.row]
        self.collectionView.reloadData()
        //        self.title = self.currentAlbum.name
        self.titleButton.setTitle(self.currentAlbum.name, for: .normal)
        self.titleButton.isSelected = false
        
        UIView.animate(withDuration: 0.2) {
            self.tableView.transform = CGAffineTransform.identity
        }
    }
}


protocol LKPhotoPickerPreviewViewControllerDelegate {
    func previewViewController(cancleClick selectAssets: Array<LKAsset>)
    func previewViewController(finishClick selectAssets: Array<LKAsset>)
}
class LKPhotoPickerPreviewViewController: UIViewController {
    var assets: Array<LKAsset> = []
    var selectAssets: Array<LKAsset> = []
    var currentIndex: Int = 0
    
    var delegate: LKPhotoPickerPreviewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.barView)
        self.barView.addSubview(self.finishButton)
        
        let t = UIApplication.shared.statusBarFrame.size.height
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect(x: 0, y: t+2, width: 64, height: 40)
        btn.setTitle("取消", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(dismissClick), for: .touchUpInside)
        self.view.addSubview(btn)
        self.view.addSubview(self.titleLabel)
        
        
        self.titleLabel.text = String(format: "%zd/%zd", self.currentIndex+1, self.assets.count)
        self.collectionView.scrollToItem(at: IndexPath(row: self.currentIndex, section: 0), at: .left, animated: false)
        
        self.view.addSubview(self.selectButton)
        
        
        let mod = self.assets[self.currentIndex]
        if self.containAsset(asset: mod) {
            self.selectButton.isSelected = true
            let idx = self.indexAsset(asset: mod)
            self.selectButton.setTitle(String(format: "%d", idx+1), for: .normal)
        } else {
            self.selectButton.isSelected = false
            self.selectButton.setTitle("", for: .normal)
        }
    }
    
    @objc func dismissClick() {
        self.delegate?.previewViewController(cancleClick: self.selectAssets)
        self.dismiss(animated: true, completion: nil)
    }
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        let w = self.view.frame.size.width
        let t = UIApplication.shared.statusBarFrame.size.height
        titleLabel.frame = CGRect(x: 100, y: t, width: w-200, height: 44)
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    lazy var selectButton: UIButton = {
        let selectButton = UIButton()
        let w = self.view.frame.size.width
        let t = UIApplication.shared.statusBarFrame.size.height
        selectButton.frame = CGRect(x: w-20-16, y: t+12, width: 20, height: 20)
        selectButton.setBackgroundImage(UIImage(named: "photo_picker_nor"), for: .normal)
        selectButton.setBackgroundImage(UIImage(named: "photo_picker_sel"), for: .selected)
        selectButton.addTarget(self, action: #selector(selectButtonClick(_:)), for: .touchUpInside)
        selectButton.titleLabel?.font = UIFont.systemFontMedium(ofSize: 12)
        return selectButton
    }()
    
    @objc func selectButtonClick(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        
        let mod = self.assets[self.currentIndex]
        if !self.containAsset(asset: mod) {
            self.selectAssets.append(mod)
            let idx = self.indexAsset(asset: mod)
            self.selectButton.setTitle(String(format: "%d", idx+1), for: .normal)
        } else {
            let idx = self.indexAsset(asset: mod)
            self.selectAssets.remove(at: idx)
            self.selectButton.isSelected = false
            self.selectButton.setTitle("", for: .normal)
        }
    }
    
    lazy var collectionView: UICollectionView = {
        
        
        let top = UIApplication.shared.statusBarFrame.size.height + 44
        var bottom: CGFloat = 48
        if UIApplication.shared.statusBarFrame.size.height > 20 {
            bottom += 10
        }
        let w = self.view.frame.size.width
        let h = self.view.frame.size.height
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: w, height: h-top-bottom)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let frame = CGRect(x: 0, y: top,
                           width: self.view.frame.size.width,
                           height: self.view.frame.size.height-top-bottom)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(LKPhotoPreviewViewCell.self, forCellWithReuseIdentifier: "abc123")
        return collectionView
    }()
    
    lazy var barView: UIView = {
        let barView = UIView()
        var h: CGFloat = 48
        if UIApplication.shared.statusBarFrame.size.height > 20 {
            h += 30
        }
        let w = self.view.bounds.size.width
        let top = self.view.bounds.size.height - h
        barView.frame = CGRect(x: 0, y: top, width: w, height: h)
        barView.backgroundColor = .white
        
        let line = UIImageView()
        line.frame = CGRect(x: 0, y: 0, width: w, height: 1)
        line.backgroundColor = UIColor(hex: 0xDDE4E6)
        barView.addSubview(line)
        
        return barView
    }()
    
    lazy var finishButton: UIButton = {
        let finishButton = UIButton()
        let w = self.view.bounds.size.width
        finishButton.frame = CGRect(x: w-64-16, y: 6, width: 64, height: 36)
        finishButton.backgroundColor = .theme
        finishButton.setTitle("完成", for: .normal)
        finishButton.layer.cornerRadius = 4
        finishButton.clipsToBounds = true
        finishButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        finishButton.addTarget(self, action: #selector(finishButtonClick), for: .touchUpInside)
        return finishButton
    }()
    
    @objc func finishButtonClick() {
        self.delegate?.previewViewController(finishClick: self.selectAssets)
//        self.dismiss(animated: false, completion: nil)
        let vc = self.presentingViewController
        
        self.dismiss(animated: false) {
            vc?.dismiss(animated: true, completion: {
                
            })
        }
    }
}

extension LKPhotoPickerPreviewViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assets.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "abc123", for: indexPath) as! LKPhotoPreviewViewCell
        
        let mod = self.assets[indexPath.row]
        cell.setup(asset: mod)
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        self.currentIndex = Int(x / scrollView.frame.size.width)
        self.titleLabel.text = String(format: "%zd/%zd", self.currentIndex+1, self.assets.count)
        
        let mod = self.assets[self.currentIndex]
        if self.containAsset(asset: mod) {
            self.selectButton.isSelected = true
            let idx = self.indexAsset(asset: mod)
            self.selectButton.setTitle(String(format: "%d", idx+1), for: .normal)
        } else {
            self.selectButton.isSelected = false
            self.selectButton.setTitle("", for: .normal)
        }
        
    }
    
    func containAsset(asset: LKAsset) -> Bool {
           for old_asset in self.selectAssets {
               if old_asset.asset?.localIdentifier == asset.asset?.localIdentifier {
                   return true
               }
           }
           return false
       }
       func indexAsset(asset: LKAsset) -> Int {
           var i = 0
           for old_asset in self.selectAssets {
               if old_asset.asset?.localIdentifier == asset.asset?.localIdentifier {
                   return i
               }
               i += 1
           }
           return i
       }
}

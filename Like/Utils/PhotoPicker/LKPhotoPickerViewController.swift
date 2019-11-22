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

class LKPhotoPickerViewController: UINavigationController {

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
    override func viewDidLoad() {
        super.viewDidLoad()

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
}
extension LKPhotoPickerRootViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currentAlbum.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "abc123", for: indexPath) as! LKPhotoViewCell
        
        cell.setup(asset: self.currentAlbum.models[indexPath.row])
        
        return cell
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


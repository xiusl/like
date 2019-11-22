//
//  LKAlbum.swift
//  Like
//
//  Created by xiusl on 2019/11/22.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit
import Photos

class LKAsset: NSObject {
    var asset: PHAsset?
}

class LKAlbum: NSObject {
    var name: String = ""
    var count: Int = 0
    var models: Array<LKAsset> = []
    
    
    class func create(withCollection collection: PHAssetCollection, assetResult: PHFetchResult<PHAsset>) -> LKAlbum {
        let ablum = LKAlbum()
        ablum.name = collection.localizedTitle ?? ""
        ablum.count = assetResult.count
        
        var arr:Array<LKAsset> = []
        assetResult.enumerateObjects { (asset, idx, stop) in
            let mod = LKAsset()
            mod.asset = asset
            arr.append(mod)
        }
        ablum.models = arr
        
        return ablum
    }
}

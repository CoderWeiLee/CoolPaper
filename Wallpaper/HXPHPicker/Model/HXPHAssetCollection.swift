//
//  HXPHAssetCollection.swift
//  照片选择器-Swift
//
//  Created by Silence on 2019/7/3.
//  Copyright © 2019年 Silence. All rights reserved.
//

import UIKit
import Photos

open class HXPHAssetCollection: NSObject {
    
    /// 相册名称
    public var albumName : String?
    
    /// 相册里的资源数量
    public var count : Int = 0
    
    /// PHAsset 集合
    public var result : PHFetchResult<PHAsset>?
    
    /// 相册对象
    public var collection : PHAssetCollection?
    
    /// 获取 PHFetchResult 中的 PHAsset 时的选项
    public var options : PHFetchOptions?
    
    /// 是否选中
    public var isSelected: Bool = false
    
    /// 是否是相机胶卷
    public var isCameraRoll: Bool = false
    
    /// 封面PHAsset
    var coverAsset: PHAsset?
    /// 真实的封面图片，如果不为nil就是封面
    var realCoverImage: UIImage?
    private var coverImage: UIImage?
    
    public init(collection: PHAssetCollection? , options: PHFetchOptions?) {
        super.init()
        self.collection = collection
        self.options = options
        fetchResult()
    }
    
    public init(albumName: String?, coverImage: UIImage?) {
        super.init()
        self.albumName = albumName
        self.coverImage = coverImage
    }
}
 
// MARK: Fetch Asset
extension HXPHAssetCollection {
    
    /// 请求获取相册封面图片
    /// - Parameter completion: 会回调多次
    /// - Returns: 请求ID
    open func requestCoverImage(completion: ((UIImage?, HXPHAssetCollection, [AnyHashable : Any]?) -> Void)?) -> PHImageRequestID? {
        if realCoverImage != nil {
            completion?(realCoverImage, self, nil)
            return nil
        }
        if coverAsset == nil {
            completion?(coverImage, self, nil)
            return nil
        }
        return HXPHAssetManager.requestThumbnailImage(for: coverAsset!, targetWidth: 160) { (image, info) in
            completion?(image, self, info)
        }
    }
    
    /// 枚举相册里的资源
    open func enumerateAssets(usingBlock :@escaping (HXPHAsset)->()) {
        if result == nil {
            fetchResult()
        }
        result?.enumerateObjects({ (asset, index, stop) in
            let photoAsset = HXPHAsset.init(asset: asset)
            usingBlock(photoAsset)
        })
    }
}

// MARK:
extension HXPHAssetCollection {
     
    func fetchResult() {
        if collection == nil {
            return
        }
        albumName = HXPHTools.transformAlbumName(for: collection!)
        result = PHAsset.fetchAssets(in: collection!, options: options)
        count = result?.count ?? 0
    }
    
    func changeResult(for result: PHFetchResult<PHAsset>) {
        self.result = result
        count = result.count
        if collection != nil {
            albumName = HXPHTools.transformAlbumName(for: collection!)
        }
    }
    
    func fetchCoverAsset() {
        coverAsset = result?.lastObject
    }
    
    func change(albumName: String?, coverImage: UIImage?) {
        self.albumName = albumName
        self.coverImage = coverImage
    }
}

//
//  HXPHAssetManager+AssetCollection.swift
//  HXPHPickerExample
//
//  Created by Slience on 2020/12/29.
//  Copyright © 2020 Silence. All rights reserved.
//

import Photos
import UIKit

public extension HXPHAssetManager {
     
    /// 获取系统相册
    /// - Parameter options: 选型
    /// - Returns: 相册列表
    class func fetchSmartAlbums(options : PHFetchOptions?) -> PHFetchResult<PHAssetCollection> {
        return PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: options)
    }
    
    /// 获取用户创建的相册
    /// - Parameter options: 选项
    /// - Returns: 相册列表
    class func fetchUserAlbums(options : PHFetchOptions?) -> PHFetchResult<PHAssetCollection> {
        return PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
    }
    
    
    /// 获取所有相册
    /// - Parameters:
    ///   - filterInvalid: 过滤无效的相册
    ///   - options: 可选项
    ///   - usingBlock: 枚举每一个相册集合
    class func enumerateAllAlbums(filterInvalid: Bool, options : PHFetchOptions?, usingBlock :@escaping (PHAssetCollection)->()) {
        let smartAlbums = fetchSmartAlbums(options: nil)
        let userAlbums = fetchUserAlbums(options: nil)
        let albums = [smartAlbums, userAlbums]
        for result in albums {
            result.enumerateObjects { (collection, index, stop) in
                if !collection.isKind(of: PHAssetCollection.self) {
                    return;
                }
                if filterInvalid {
                    if  collection.estimatedAssetCount <= 0 ||
                        collection.assetCollectionSubtype.rawValue == 205 ||
                        collection.assetCollectionSubtype.rawValue == 215 ||
                        collection.assetCollectionSubtype.rawValue == 212 ||
                        collection.assetCollectionSubtype.rawValue == 204 ||
                        collection.assetCollectionSubtype.rawValue == 1000000201 {
                        return;
                    }
                }
                usingBlock(collection)
            }
        }
    }
    
    /// 获取相机胶卷资源集合
    /// - Parameter options: 可选项
    /// - Returns: 相机胶卷集合
    class func fetchCameraRollAlbum(options: PHFetchOptions?) -> PHAssetCollection? {
        let smartAlbums = fetchSmartAlbums(options: options)
        var assetCollection : PHAssetCollection?
        smartAlbums.enumerateObjects { (collection, index, stop) in
            if  !collection.isKind(of: PHAssetCollection.self) ||
                collection.estimatedAssetCount <= 0 {
                return
            }
            if collectionIsCameraRollAlbum(collection: collection) {
                assetCollection = collection
                stop.initialize(to: true)
            }
        }
        return assetCollection
    }
    
    /// 判断是否是相机胶卷
    /// - Parameter collection: 相机胶卷集合
    class func collectionIsCameraRollAlbum(collection: PHAssetCollection?) -> Bool {
        var versionStr = UIDevice.current.systemVersion.replacingOccurrences(of: ".", with: "")
        if versionStr.count <= 1 {
            versionStr.append("00")
        }else if versionStr.count <= 2 {
            versionStr.append("0")
        }
        let version = Int(versionStr) ?? 0
        if version >= 800 && version <= 802  {
            return collection?.assetCollectionSubtype == .smartAlbumRecentlyAdded
        }else {
            return collection?.assetCollectionSubtype == .smartAlbumUserLibrary
        }
    }
    
    /// 创建相册
    /// - Parameter collectionName: 相册名
    /// - Returns: 对应的 PHAssetCollection 数据
    class func createAssetCollection(for collectionName: String) -> PHAssetCollection? {
        let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        var assetCollection: PHAssetCollection?
        collections.enumerateObjects { (collection, index, stop) in
            if collection.localizedTitle == collectionName {
                assetCollection = collection
                stop.pointee = true
            }
        }
        if assetCollection == nil {
            do {
                var createCollectionID: String?
                try PHPhotoLibrary.shared().performChangesAndWait {
                    createCollectionID = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: collectionName).placeholderForCreatedAssetCollection.localIdentifier
                }
                if let createCollectionID = createCollectionID {
                    assetCollection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [createCollectionID], options: nil).firstObject
                }
            }catch {}
        }
        return assetCollection
    }
}

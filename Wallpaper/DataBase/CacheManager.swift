//
//  CacheManager.swift
//  Wallpaper
//
//  Created by 李伟 on 2021/1/4.
//

import Foundation
final class CacheManager: NSObject {
    
    /// 写缓存
    /// - Parameters:
    ///   - data: 需要写入的data
    ///   - key: 对应的key
    /// - Returns:
    static func writeLocalCache(with data: Data, with key: String) -> Void {
        //设置缓存路径
        guard let catchPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/\(key)") else {return}
        //判断缓存数据是否存在
        if FileManager.default.fileExists(atPath: catchPath) {
            //删除旧的缓存
           try? FileManager.default.removeItem(atPath: catchPath)
        }
        //存储新的数据
        try? data.write(to: URL(fileURLWithPath: catchPath))
    }
    
    
    /// 读缓存
    /// - Parameter key: 需要查找的key
    /// - Returns: 返回的数据
    static func readLocalCacheData(with key: String) -> Data? {
        //设置缓存路径
        guard let catchPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/\(key)") else {return nil}
        print(catchPath)
        //判断缓存数据是否存在
        if FileManager.default.fileExists(atPath: catchPath) {
            //读取缓存数据
            return try? Data(contentsOf: URL(fileURLWithPath: catchPath))
        }
        return nil
    }
    
    
    /// 删除缓存中的数据
    /// - Parameter key: 需要删除的数据对应的key
    /// - Returns:
    static func deleteLocalCacheData(with key: String) -> Void {
        //设置缓存路径
        guard let catchPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/\(key)") else {return}
        //判断缓存数据是否存在
        if FileManager.default.fileExists(atPath: catchPath) {
            //删除旧的缓存
           try? FileManager.default.removeItem(atPath: catchPath)
        }
    }
    
    
}

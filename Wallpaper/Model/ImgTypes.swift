//
//  ImgTypes.swift
//  Wallpaper
//
//  Created by 李伟 on 2020/12/26.
//

import Foundation
import KakaJSON
class ImgTypes: NSObject, Convertible, NSSecureCoding {
    static var supportsSecureCoding: Bool {return true}
    
    func encode(with coder: NSCoder) {
        coder.encode(self.type, forKey: "type")
        coder.encode(self.key, forKey: "key")
        coder.encode(self.num,forKey: "num")
        coder.encode(self.keyword,forKey: "keyword")
        coder.encode(self.index,forKey: "index")
    }
    
    required init?(coder: NSCoder) {
        self.type = coder.decodeObject(of: NSString.self, forKey: "type") as String? ?? ""
        self.key = coder.decodeObject(of: NSString.self, forKey: "key") as String? ?? ""
        self.num = coder.decodeObject(of: NSString.self, forKey: "num") as String? ?? "0"
        self.keyword = coder.decodeObject(of: NSString.self, forKey: "keyword") as String? ?? ""
        self.index = coder.decodeObject(of: NSString.self, forKey: "index") as String? ?? "0"
    }

    
    required override init() {}
    /// 分类名称
    var type: String? = ""
    
    
    /// 对应文件夹目录名称
    var key: String? = ""
    
    
    /// 当前文件夹目录下面的图片数量
    var num: String? = ""
    
    
    /// 分类对应的关键词，用于搜索分类下图片
    var keyword: String? = ""
    
    ///具体对象持有的index下标 用来标记它是该type类型下的第index个元素
    var index: String? = ""
    
}

//
//  CategoryModel.swift
//  Wallpaper
//
//  Created by 李伟 on 2021/1/27.
//

import Foundation
import KakaJSON
struct CategoryResModel: Convertible, Hashable {
    var code: String?
    var data: [CategoryModel]?
    var msg: String?
    var time: String?
}

struct CategoryModel: Convertible, Hashable {
    var category_id: String?
    var name: String?
}



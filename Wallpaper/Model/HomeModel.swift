//
//  HomeModel.swift
//  Wallpaper
//
//  Created by 李伟 on 2021/1/26.
//

import Foundation
import KakaJSON
struct ResponseModel: Convertible, Hashable {
    var code: String?
    var data: HomeModel?
    var msg: String?
    var time: String?
}
struct ImageModel: Convertible, Hashable {
    var id: String?
    var url: String?
    var originurl: String?
    var views: String?
    var fav: String?
}

struct HomeModel: Convertible, Hashable {
    var total: String?
    var per_page: String?
    var current_page: String?
    var last_page: String?
    var data: [ImageModel]?
}

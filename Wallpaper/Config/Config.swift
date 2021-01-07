//
//  Config.swift
//  Wallpaper
//
//  Created by 李伟 on 2020/12/27.
//

import UIKit
let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height
//获取状态栏的高度，全面屏手机的状态栏高度为44pt，非全面屏手机的状态栏高度为20pt
//状态栏高度
let statusBarHeight = UIApplication.shared.statusBarFrame.height
//导航栏高度
let navigationHeight = (statusBarHeight + 44)
//tabbar高度
let tabBarHeight = (statusBarHeight==44 ? 83 : 49)
//顶部的安全距离
let topSafeAreaHeight = (statusBarHeight - 20)
//底部的安全距离，全面屏手机为34pt，非全面屏手机为0pt
let bottomSafeAreaHeight = (tabBarHeight - 49)

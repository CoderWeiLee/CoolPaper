//
//  MyDownloadController.swift
//  Wallpaper
//
//  Created by 李伟 on 2021/2/2.
//

import Foundation
import UIKit
import JXSegmentedView
import MJRefresh
import Alamofire
import KakaJSON
class MyDownloadController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension MyDownloadController: JXSegmentedListContainerViewListDelegate {
    /// 如果列表是VC，就返回VC.view
    /// 如果列表是View，就返回View自己
    /// - Returns: 返回列表视图
    func listView() -> UIView {
        return view
    }
}


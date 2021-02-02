//
//  LocalController.swift
//  Wallpaper
//
//  Created by 李伟 on 2021/2/2.
//  本地

import Foundation
import UIKit
import JXSegmentedView
import Alamofire
import KakaJSON
class LocalController: UIViewController , JXSegmentedViewDelegate, JXSegmentedListContainerViewDataSource {
    var segmentedView: JXSegmentedView!
    var segmentedDataSource: JXSegmentedTitleDataSource!
    var listContainerView: JXSegmentedListContainerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //隐藏导航栏
        navigationController?.setNavigationBarHidden(true, animated: true)
        //7.添加渐变层
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenW, height: statusBarHeight + 50)
        gradientLayer.colors = [UIColor(hexString: "#FF62A5").cgColor, UIColor(hexString: "#FF632E").cgColor]
        gradientLayer.locations = [0,1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        //1、初始化JXSegmentedView
        segmentedView = JXSegmentedView()
            
        //2、配置数据源
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedDataSource = JXSegmentedTitleDataSource()
        segmentedDataSource.itemWidth = 46
        segmentedDataSource.titles = ["我的下载", "本地壁纸"]
        segmentedDataSource.titleNormalColor = .white
        segmentedDataSource.titleNormalFont = UIFont.systemFont(ofSize: 14)
        segmentedDataSource.titleSelectedFont = UIFont.systemFont(ofSize: 17)
        segmentedDataSource.titleSelectedColor = .white
        segmentedDataSource.isTitleColorGradientEnabled = true
        segmentedView.dataSource = segmentedDataSource
            
        //3、配置指示器
        let indicator = JXSegmentedIndicatorLineView()
            indicator.indicatorColor = .white
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.lineStyle = .lengthen
        indicator.verticalOffset = 5
        segmentedView.indicators = [indicator]
            
        //4、配置JXSegmentedView的属性
        view.addSubview(segmentedView)
            
        //5、初始化JXSegmentedListContainerView
        listContainerView = JXSegmentedListContainerView(dataSource: self)
        view.addSubview(listContainerView)
            
        //6、将listContainerView.scrollView和segmentedView.contentScrollView进行关联
        segmentedView.listContainer = listContainerView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        segmentedView.frame = CGRect(x: 0, y: statusBarHeight, width: view.bounds.size.width, height: 50)
        listContainerView.frame = CGRect(x: 0, y: statusBarHeight + 50, width: view.bounds.size.width, height: view.bounds.size.height - statusBarHeight - 50)
    }
}

extension LocalController {
    //点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，而不关心具体是点击还是滚动选中的情况。
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {}
    
    // 点击选中的情况才会调用该方法
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {}
    
    // 滚动选中的情况才会调用该方法
    func segmentedView(_ segmentedView: JXSegmentedView, didScrollSelectedItemAt index: Int) {}
    
    // 正在滚动中的回调
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {}
}

extension LocalController {
    //返回列表的数量
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentedDataSource.titles.count
    }
    
    //返回遵从`JXSegmentedListContainerViewListDelegate`协议的实例
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        switch index {
        case 0:
            return MyDownloadController()
        default:
            return LocalPaperController()
            
        }
    }
}


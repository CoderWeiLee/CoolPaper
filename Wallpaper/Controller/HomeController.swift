//
//  HomeController.swift
//  Wallpaper
//
//  Created by 李伟 on 2020/12/25.
//

import UIKit
import JXSegmentedView
import Alamofire
import KakaJSON
class HomeController: UIViewController, JXSegmentedViewDelegate, JXSegmentedListContainerViewDataSource {
    struct Category: Encodable {
        let appkey: String
        let video: String
    }
    var segmentedView: JXSegmentedView!
    var segmentedDataSource: JXSegmentedTitleDataSource!
    var listContainerView: JXSegmentedListContainerView!
    var dataArray: Array<CategoryModel>?
    var menuImageView: UIImageView!
    var menuBtn: UIButton!
        override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = .systemBackground
        //1、初始化JXSegmentedView
        segmentedView = JXSegmentedView()
            
        //2、配置数据源
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedDataSource = JXSegmentedTitleDataSource()
        segmentedDataSource.isItemSpacingAverageEnabled = false
        segmentedDataSource.itemWidth = 30
        segmentedDataSource.titles = ["推荐", "热门"]
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
        
        //7.添加渐变层
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenW, height: statusBarHeight + 50)
        gradientLayer.colors = [UIColor(hexString: "#FF62A5").cgColor, UIColor(hexString: "#FF632E").cgColor]
        gradientLayer.locations = [0,1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        view.layer.insertSublayer(gradientLayer, at: 0)

        //8.添加选择更多的按钮
        menuImageView = UIImageView(image: UIImage(named: "menu"))
        view.addSubview(menuImageView)
        menuImageView.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-19)
            make.centerY.equalTo(segmentedView);
        }
            
        menuBtn = UIButton(type: .custom)
        menuBtn.addTarget(self, action: #selector(menuAction), for: .touchUpInside)
        view.addSubview(menuBtn)
        menuBtn.snp.makeConstraints { (make) in
            make.top.right.equalTo(view)
            make.height.equalTo(statusBarHeight + 50)
            make.width.equalTo(100)
        }
            
        //发起请求查询分页的数据
        let category = Category(appkey: "035d4cebaaf8bc9d9f5aa782368224ac", video: "0")
            AF.request(categoryListURL, method: .post, parameters: category).responseJSON {[self] (response) in
            if let responseModel = (response.data?.kj.model(CategoryResModel.self)){
                self.dataArray = Array(responseModel.data!)
//                self.segmentedDataSource.titles.append(contentsOf: self.dataArray.flatMap {
//                    $0.map {$0.name!}
//                }!)
//                self.segmentedView.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        segmentedView.frame = CGRect(x: 0, y: statusBarHeight, width: view.bounds.size.width, height: 50)
        listContainerView.frame = CGRect(x: 0, y: statusBarHeight + 50, width: view.bounds.size.width, height: view.bounds.size.height - statusBarHeight - 50)
    }
    
    @objc func menuAction() {
        let typeVc = TypeController()
        typeVc.hidesBottomBarWhenPushed = true
        typeVc.dataArray = self.dataArray
        navigationController?.pushViewController(typeVc, animated: true)
    }
}


extension HomeController {
    //点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，而不关心具体是点击还是滚动选中的情况。
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {}
    
    // 点击选中的情况才会调用该方法
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {}
    
    // 滚动选中的情况才会调用该方法
    func segmentedView(_ segmentedView: JXSegmentedView, didScrollSelectedItemAt index: Int) {}
    
    // 正在滚动中的回调
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {}
}

extension HomeController {
    //返回列表的数量
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentedDataSource.titles.count
    }
    
    //返回遵从`JXSegmentedListContainerViewListDelegate`协议的实例
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        switch index {
        case 0:
            return RecommendController()
        case 1:
            return PopularController()
        default:
            let categoryVC = CategoryController()
            categoryVC.model = self.dataArray?[index-2]
            return categoryVC
            
        }
    }
}

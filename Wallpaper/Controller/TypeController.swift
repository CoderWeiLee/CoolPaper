//
//  TypeController.swift
//  Wallpaper
//
//  Created by 李伟 on 2021/2/2.
//

import Foundation
import UIKit
import SnapKit
import Combine
import Alamofire
import MJRefresh
class TypeController: UIViewController, UIScrollViewDelegate {
    var dataArray: Array<CategoryModel>?
    var scroll: UIScrollView!
    struct Login: Encodable {
        let appkey: String
        let category_id: String
        let page: String
        let pagesize: String
    }
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: w, height: h)
        layout.minimumLineSpacing = 7
        layout.minimumInteritemSpacing = 7
        let collectionView = UICollectionView(frame: CGRect(x: 8, y: statusBarHeight + 100, width: view.bounds.width - 16, height: view.bounds.height - 100 - statusBarHeight), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = true
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: reuseID)
        return collectionView
    }()
    var num: Int = 0
    var maxCount: NSInteger?
    var datas: NSMutableArray?
    var currentPage: NSInteger?
    var totalPage: NSInteger?
    var model: CategoryModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //隐藏导航栏
        navigationController?.setNavigationBarHidden(true, animated: true)
        //7.添加渐变层
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenW, height: statusBarHeight + 100)
        gradientLayer.colors = [UIColor(hexString: "#FF62A5").cgColor, UIColor(hexString: "#FF632E").cgColor]
        gradientLayer.locations = [0,1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        //添加返回按钮
        let backBtn = UIButton(type: .custom)
        backBtn.adjustsImageWhenHighlighted = false
        backBtn.setImage(UIImage(named: "btn-top-backwhite"), for: .normal)
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(17)
            make.top.equalTo(view).offset(statusBarHeight + 13)
            make.width.height.equalTo(30)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "分类"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.centerY.equalTo(backBtn)
        }
        
        let searchBtn = UIButton(type: .custom)
        searchBtn.adjustsImageWhenHighlighted = false
        searchBtn.setImage(UIImage(named: "nav_search"), for: .normal)
        searchBtn.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        view.addSubview(searchBtn)
        searchBtn.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-17)
            make.centerY.equalTo(backBtn)
        }
        
        scroll = UIScrollView(frame: CGRect(x: 0, y: statusBarHeight + 50, width: view.width, height: 50))
//        scroll.backgroundColor = UIColor(hexString: "#162223")
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        
        view.addSubview(scroll)
        let count = self.dataArray?.count ?? 0
        let w = 80 * count + 10 * (count + 1)
        let h = 50
        scroll.contentSize = CGSize(width: w, height: h)
        
        if let array = self.dataArray {
            for (index, value) in array.enumerated() {
                let btn = UIButton()
                btn.tag = index
                btn.setTitle(value.name, for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.setTitleColor(UIColor(hexString: "#162223"), for: .selected)
                btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
                btn.layer.cornerRadius = 15
                btn.layer.masksToBounds = true
                if (index == 0) {
                    btn.layer.borderColor = UIColor(hexString: "#162223").cgColor
                    btn.isSelected = true
                }else {
                    btn.layer.borderColor = UIColor.white.cgColor
                    btn.isSelected = false
                }
                btn.layer.borderWidth = 1
                scroll.addSubview(btn)
                btn.snp.makeConstraints { (make) in
                    make.left.equalTo(scroll).offset(80 * index + 10 * (index + 1))
                    make.width.equalTo(80)
                    make.height.equalTo(30)
                    make.centerY.equalTo(scroll)
                }
            }
        }
        view.addSubview(collectionView)
        collectionView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadData))
        collectionView.mj_header?.isAutomaticallyChangeAlpha = true;
        collectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        collectionView.mj_footer?.isAutomaticallyChangeAlpha = true
        self.model = self.dataArray?[0]
        collectionView.mj_header?.beginRefreshing()
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func btnAction(_ btn: UIButton) {
        let subviews = self.scroll.subviews.filter{$0.isKind(of: UIButton.self)} as! [UIButton]
        for subbtn in subviews {
            if subbtn.tag == btn.tag {
                subbtn.isSelected = true
                subbtn.layer.borderColor = UIColor(hexString: "#162223").cgColor
            }else {
                subbtn.isSelected = false
                subbtn.layer.borderColor = UIColor.white.cgColor
            }
        }
        self.model = self.dataArray?[btn.tag]
//        self.collectionView.reloadData()
        self.collectionView.mj_header?.beginRefreshing()
    }
    
    @objc func searchAction() {
        let searchVc = SearchController()
        searchVc.dataArray = self.dataArray
        searchVc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchVc, animated: true)
    }
    
    //下拉刷新
    @objc func loadData() -> Void {
        currentPage = 1
        let login = Login(appkey: "035d4cebaaf8bc9d9f5aa782368224ac", category_id: model?.id ?? "1", page: "\(currentPage ?? 1)", pagesize: "20")
        AF.request(categoryURL, method: .post, parameters: login).responseJSON {[self] (response) in
            if let responseModel = (response.data?.kj.model(ResponseModel.self)){
                self.datas = NSMutableArray(array: (responseModel.data?.data)!)
                self.collectionView.reloadData()
                self.collectionView.mj_header?.endRefreshing()
            }
        }
    }
    
    //上拉加载更多
    @objc func loadMore() -> Void {
        currentPage = currentPage ?? 1 + 1
        let login = Login(appkey: "035d4cebaaf8bc9d9f5aa782368224ac", category_id: model?.id ?? "1", page: "\(currentPage ?? 1)", pagesize: "20")
        AF.request(categoryURL, method: .post, parameters: login).response {[self] (response) in
            if let responseModel = (response.data?.kj.model(ResponseModel.self)){
                self.currentPage = NSInteger(responseModel.data?.current_page ?? "1")
                self.totalPage = NSInteger(responseModel.data?.total ?? "1")
                let dataArray = NSMutableArray(array: (responseModel.data?.data)!)
                self.datas?.addObjects(from: dataArray as! [Any])
                self.collectionView.reloadData()
                self.currentPage == self.totalPage ? self.collectionView.mj_footer?.endRefreshingWithNoMoreData() : self.collectionView.mj_footer?.endRefreshing()
            }
            
        }
    }
}

extension TypeController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datas?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! CollectionCell
        cell.imageModel = self.datas?[indexPath.row] as? ImageModel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bigC = BigImageController()
        bigC.model = self.datas?[indexPath.row] as? ImageModel
        navigationController?.pushViewController(bigC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

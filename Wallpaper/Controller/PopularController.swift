//
//  PopularController.swift
//  Wallpaper
//
//  Created by 李伟 on 2020/12/26.
//

import UIKit
import JXSegmentedView
import MJRefresh
import Alamofire
import KakaJSON 
class PopularController: UIViewController {
    struct Login: Encodable {
        let appkey: String
        let page: String
        let pagesize: String
        let video: String
    }
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: w, height: h)
        layout.minimumLineSpacing = 7
        layout.minimumInteritemSpacing = 7
        let collectionView = UICollectionView(frame: CGRect(x: 8, y: 8, width: view.bounds.width - 16, height: view.bounds.height - 8 - CGFloat(bottomSafeAreaHeight)), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = true
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: reuseID)
        return collectionView
    }()
    
    var num: Int = 0
    var maxCount: NSInteger?
    var dataArray: NSMutableArray?
    var currentPage: NSInteger?
    var totalPage: NSInteger?

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.addSubview(collectionView)
        collectionView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadData))
        collectionView.mj_header?.isAutomaticallyChangeAlpha = true;
        collectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        collectionView.mj_footer?.isAutomaticallyChangeAlpha = true
        collectionView.mj_header?.beginRefreshing()
    }
    
    //下拉刷新
    @objc func loadData() -> Void {
        currentPage = 1
        let login = Login(appkey: "035d4cebaaf8bc9d9f5aa782368224ac", page: "\(currentPage ?? 1)", pagesize: "20", video: "0")
        AF.request(hotURL, method: .post, parameters: login).responseJSON {[self] (response) in
            if let responseModel = (response.data?.kj.model(ResponseModel.self)){
                self.dataArray = NSMutableArray(array: (responseModel.data?.data)!)
                self.collectionView.reloadData()
                self.collectionView.mj_header?.endRefreshing()
            }
        }
    }
    
    //上拉加载更多
    @objc func loadMore() -> Void {
        currentPage = currentPage ?? 1 + 1
        let login = Login(appkey: "035d4cebaaf8bc9d9f5aa782368224ac", page: "\(currentPage ?? 1)", pagesize: "20", video: "0")
        AF.request(hotURL, method: .post, parameters: login).response {[self] (response) in
            if let responseModel = (response.data?.kj.model(ResponseModel.self)){
                self.currentPage = NSInteger(responseModel.data?.current_page ?? "1")
                self.totalPage = NSInteger(responseModel.data?.total ?? "1")
                let dataArray = NSMutableArray(array: (responseModel.data?.data)!)
                self.dataArray?.addObjects(from: dataArray as! [Any])
                self.collectionView.reloadData()
                self.currentPage == self.totalPage ? self.collectionView.mj_footer?.endRefreshingWithNoMoreData() : self.collectionView.mj_footer?.endRefreshing()
            }
            
        }
    }
}

extension PopularController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! CollectionCell
        cell.imageModel = self.dataArray?[indexPath.row] as? ImageModel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bigC = BigImageController()
        bigC.model = self.dataArray?[indexPath.row] as? ImageModel
        bigC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(bigC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //
    }
}

extension PopularController: JXSegmentedListContainerViewListDelegate {
    /// 如果列表是VC，就返回VC.view
    /// 如果列表是View，就返回View自己
    /// - Returns: 返回列表视图
    func listView() -> UIView {
        return view
    }
}

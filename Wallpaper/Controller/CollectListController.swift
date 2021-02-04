//
//  CollectListController.swift
//  Wallpaper
//
//  Created by 李伟 on 2021/2/2.
//

import UIKit
import JXSegmentedView
import MJRefresh
import Alamofire
import KakaJSON
class CollectListController: UIViewController {
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
    var dataArray: NSMutableArray?
    override func viewDidLoad() {
        super.viewDidLoad()
        ///api/token/refresh
        AF.request(checkTokenURL, method: .get, parameters: nil).responseJSON {[self] (response) in
            if let responseModel = (response.data?.kj.model(ResponseModel.self)){
                if (responseModel.data?.data != nil) {
                    self.dataArray = NSMutableArray(array: (responseModel.data?.data)!)
                    self.collectionView.reloadData()
                }
                self.collectionView.mj_header?.endRefreshing()
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.addSubview(collectionView)
        collectionView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadData))
        collectionView.mj_header?.isAutomaticallyChangeAlpha = true;
        collectionView.mj_header?.beginRefreshing()
    }
    
    //下拉刷新
    @objc func loadData() -> Void {
        
//        let login = Login(appkey: "035d4cebaaf8bc9d9f5aa782368224ac", page: "\(currentPage ?? 1)", pagesize: "20", video: "0")
        AF.request(favListURL, method: .post, parameters: nil).responseJSON {[self] (response) in
            if let responseModel = (response.data?.kj.model(ResponseModel.self)){
                if (responseModel.data?.data != nil) {
                    self.dataArray = NSMutableArray(array: (responseModel.data?.data)!)
                    self.collectionView.reloadData()
                }
                self.collectionView.mj_header?.endRefreshing()
            }
        }
    }
}

extension CollectListController: UICollectionViewDataSource, UICollectionViewDelegate {
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

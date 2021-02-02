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
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: w, height: h)
        layout.minimumLineSpacing = 7
        layout.minimumInteritemSpacing = 7
        let collectionView = UICollectionView(frame: CGRect(x: 8, y: 8, width: view.bounds.width - 16, height: view.bounds.height-8 - CGFloat(bottomSafeAreaHeight)), collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = true
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: reuseID)
        return collectionView
    }()
    
    lazy var noDataImg: UIImageView = {
       let imgV = UIImageView(image: UIImage(named: "noData"))
       imgV.frame = view.bounds
       return imgV
    }()
    
    var dataArray: [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         
         guard let imgPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/\(imageModel?.id ?? "0").JPG") else {return}
         guard let videoPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/\(imageModel?.id ?? "0").MOV") else {return}
         */
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
        let videoPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        self.dataArray = try? FileManager.default.contentsOfDirectory(atPath: videoPath ?? "").filter {
            $0.hasSuffix(".MOV")
        }
        self.collectionView.reloadData()
        self.collectionView.mj_header?.endRefreshing()
        if (self.dataArray?.count == 0) {
            self.collectionView.addSubview(self.noDataImg)
        }else {
            self.noDataImg.removeFromSuperview()
        }
    }
}

extension MyDownloadController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! CollectionCell
        let name = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/\(self.dataArray?[indexPath.row] ?? "")") ?? ""
        cell.showWithFileName(name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let bigC = BigImageController()
//        bigC.model = self.dataArray?[indexPath.row] as? ImageModel
//        bigC.hidesBottomBarWhenPushed = true
//        navigationController?.pushViewController(bigC, animated: true)
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


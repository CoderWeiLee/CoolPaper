//
//  RecommendController.swift
//  Wallpaper
//
//  Created by 李伟 on 2020/12/26.
//

import UIKit
import JXSegmentedView

let w = (kScreenW - 9) * 0.5
let h = w * 2
let reuseID = "CollectionCell"
class RecommendController: UIViewController {
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: w, height: h)
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        let collectionView = UICollectionView(frame: CGRect(x: 3, y: 3, width: view.bounds.width - 6, height: view.bounds.height-3 - CGFloat(bottomSafeAreaHeight)), collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = true
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: reuseID)
        return collectionView
    }()
    
    var num: Int = 0
    var imgType: ImgTypes?
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.addSubview(collectionView)
        if let data = UserDefaults.standard.value(forKey: "ImgTypes") as? Data{
            if let imgTypes = try! NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSObject.self], from: data) as? [ImgTypes]{
                if let type = imgTypes.filter({$0.key == "Daily"}).first {
                    imgType = type
                    num = Int(type.num ?? "0") ?? 0
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //
    }
}

extension RecommendController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return num
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! CollectionCell
        guard let type = imgType else {
            return cell
        }
        type.index = String(format: "%04d", indexPath.row + 1)
        cell.type = type
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bigC = BigImageController()
        guard let type = imgType else {
            return 
        }
        type.index = String(format: "%04d", indexPath.row + 1)
        bigC.type = type
        bigC.hidesBottomBarWhenPushed = true
        bigC.scene = .navHideScene
        navigationController?.pushViewController(bigC, animated: true)
    }
}

extension RecommendController: JXSegmentedListContainerViewListDelegate {
    /// 如果列表是VC，就返回VC.view
    /// 如果列表是View，就返回View自己
    /// - Returns: 返回列表视图
    func listView() -> UIView {
        return view
    }
}

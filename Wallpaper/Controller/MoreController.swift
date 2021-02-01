//
//  MoreController.swift
//  Wallpaper
//
//  Created by 李伟 on 2020/12/25.
//

import UIKit
import PhotosUI
let moreW = (kScreenW - 12) / 3
let moreH = moreW
let moreReuseID = "moreReuseID"
class MoreController: UIViewController {
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: moreW, height: moreH)
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        let collectionView = UICollectionView(frame: CGRect(x: 3, y: 3, width: view.bounds.width - 6, height: view.bounds.height-3), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = true
        collectionView.register(MoreCollectionCell.self, forCellWithReuseIdentifier: reuseID)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    var num: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        //0.设置导航栏和文字标题
        title = "动态"
//        tabBarItem.title = ""
        navigationController?.setNavigationBarHidden(false, animated: true)
        view.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "indicatorColor") ?? .green, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        //隐藏分割线
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let searchImg = UIImageView(image: UIImage(named: "search"))
        searchImg.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(searchAction))
        searchImg.addGestureRecognizer(tap)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchImg)
        view.addSubview(collectionView)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        collectionView.reloadData()
    }
    
    private func loadData() {
        //读取缓存中的数据
        if let data = UserDefaults.standard.value(forKey: "ImgTypes") as? Data{
            if let imgTypes = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSObject.self], from: data) as? [ImgTypes]{
                num = imgTypes.count
            }
        }
    }
    
    @objc func searchAction() {
        let searchVc = SearchController()
        searchVc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(searchVc, animated: true)
    }
}

extension MoreController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! MoreCollectionCell
        if let data = UserDefaults.standard.value(forKey: "ImgTypes") as? Data{
            if let imgTypes = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSObject.self], from: data) as? [ImgTypes]{
                let type = imgTypes[indexPath.row]
                if type.key == "Dongtai" {
                    type.index = "0001"
                }else {
                    type.index = String(format: "%04d", indexPath.row + 1)
                }
                cell.type = type
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return num
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let data = UserDefaults.standard.value(forKey: "ImgTypes") as? Data{
            if let imgTypes = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSObject.self], from: data) as? [ImgTypes]{
                let cell = collectionView.cellForItem(at: indexPath) as! MoreCollectionCell
                cell.livePhotoView.stopPlayback()
                let type = imgTypes[indexPath.row]
                type.index = String(format: "%04d", indexPath.row + 1)
                let commonVc = CommonController()
                commonVc.hidesBottomBarWhenPushed = true
                commonVc.imgType = type
                navigationController?.pushViewController(commonVc, animated: true)
            }
        }
      
    }
}

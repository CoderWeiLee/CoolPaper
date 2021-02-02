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
        layout.minimumLineSpacing = 7
        layout.minimumInteritemSpacing = 7
        let collectionView = UICollectionView(frame: CGRect(x: 8, y: 8, width: view.bounds.width - 16, height: view.bounds.height-8), collectionViewLayout: layout)
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

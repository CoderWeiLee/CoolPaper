//
//  SearchController.swift
//  Wallpaper
//
//  Created by 李伟 on 2020/12/28.
//

import Foundation
import UIKit
import SnapKit
let recommendID = "recommendID"
let searchID = "searchID"
let searchW = (kScreenW - 12) / 3
let searchH = searchW * 2
class SearchController: UIViewController {
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: moreW, height: moreH)
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        layout.headerReferenceSize = CGSize(width: kScreenW - 6, height: 30)
        let collectionView = UICollectionView(frame: CGRect(x: 3, y: statusBarHeight + 33, width: view.bounds.width - 6, height: view.bounds.height - statusBarHeight - 33), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = true
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "header")
        collectionView.register(RecommendCell.self, forCellWithReuseIdentifier: recommendID)
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: searchID)
        return collectionView
    }()
    var recommendNum = 0
    var searchNum = 0
    var types: [String]?
    var keys: [String]?
    var imgTypes: [ImgTypes]?
    var dataArray: Array<CategoryModel>?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = UserDefaults.standard.value(forKey: "ImgTypes") as? Data{
            if let imgTypes = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSObject.self], from: data) as? [ImgTypes]{
                types = imgTypes.compactMap {$0.type}
                keys = imgTypes.compactMap {$0.key}
                self.imgTypes = imgTypes
            }
        }
        view.backgroundColor = .white
        //隐藏导航栏
        navigationController?.setNavigationBarHidden(true, animated: true)
        let searchBar = UISearchBar()
        //去掉上下阴影
        searchBar.layer.borderWidth = 1
        searchBar.placeholder = "请输入搜索的内容"
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        searchBar.layer.cornerRadius = 6
        searchBar.layer.masksToBounds = true
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(50)
            make.right.equalTo(view).offset(-50)
            make.top.equalTo(view).offset(statusBarHeight)
            make.height.equalTo(30)
        }
        
        //添加返回按钮
        let backBtn = UIButton(type: .custom)
        backBtn.adjustsImageWhenHighlighted = false
        backBtn.setImage(UIImage(named: "browser-back-black"), for: .normal)
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(10)
            make.centerY.equalTo(searchBar)
            make.width.height.equalTo(30)
        }
        
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cancelBtn.setTitleColor(UIColor(named: "indicatorColor"), for: .normal)
        view.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-20)
            make.centerY.equalTo(searchBar)
            make.width.height.equalTo(30)
        }
        
        view.addSubview(collectionView)
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func cancelAction() {
        navigationController?.popViewController(animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension SearchController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recommendID, for: indexPath) as! RecommendCell
            cell.title = "# \(types?[indexPath.row] ?? "")"
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchID, for: indexPath) as! SearchCell
            let content = "/\(keys?[indexPath.row] ?? "daily")/0001.JPG"
            cell.contents = content
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return types?.count ?? 0
        default:
            return keys?.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "header", for: indexPath) as! CollectionHeaderView
            if indexPath.section == 0 {
                header.title = "热门推荐"
            }else {
                header.title = "热门搜索"
            }
            return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            guard let type = imgTypes?[indexPath.row] else {
                return
            }
            let commonVc = CommonController()
            commonVc.hidesBottomBarWhenPushed = true
            commonVc.imgType = type
            navigationController?.pushViewController(commonVc, animated: true)
        default:
            guard let type = imgTypes?[indexPath.row] else {
                return
            }
            let bigC = BigImageController()
            bigC.scene = .navHideScene
            type.index = String(format: "04d", indexPath.row + 1)
            bigC.type = type
            bigC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(bigC, animated: true)
        }
    }
}

extension SearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            guard let type = types?[indexPath.row]  else {
                return CGSize(width: 0, height: 0)
            }
            let attrType = NSAttributedString(string: "# \(type)")
            let size = attrType.boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity), options: NSStringDrawingOptions.init(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue), context: nil).size
            let w = size.width
            let h = size.height
            return CGSize(width: w + 30, height: h + 10)
        default:
            return CGSize(width: searchW, height: searchH)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 0:
            return 6
        default:
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 0:
            return 6
        default:
            return 3
        }
    }
}

extension SearchController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let types = imgTypes {
            if let type = types.filter({$0.type == searchBar.text}).first {
                let commonVc = CommonController()
                commonVc.hidesBottomBarWhenPushed = true
                commonVc.imgType = type
                navigationController?.pushViewController(commonVc, animated: true)
            }
        }
    }
}

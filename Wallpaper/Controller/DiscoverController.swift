//
//  DiscoverController.swift
//  Wallpaper
//
//  Created by 李伟 on 2021/1/5.
//

import Foundation
import UIKit
import SnapKit
class DiscoverController: UIViewController {
    var tableView: UITableView!
    var publishBtn: UIButton!
    var names: [String] = ["知否", "艾欧尼亚", "想你的夜", "孤独的狼", "一颗中国心", "麻花藤是狗", "周杰伦武汉分伦"]
    var times: [String] = ["2020年1月4日 10:04", "2020年1月3日 16:31", "2020年1月3日 11:01", "2020年1月2日 10:05", "2020年1月2日 07:08", "2020年12月31日 21:09", "2020年12月28日 15:22"]
    var tags: [String] = ["# 风景 #", "# 美女 #", "# 卡通 #", "# 杰伦 #", "# 萌宠 #", "# 情侣 #", "# 自定义 #"]
    var contents: [String] = ["非常中国风的美景照片", "这些美女都好漂亮", "卡通的充满了童趣", "周杰伦华语歌坛巨星", "好想养一只这样萌萌哒的宠物", "有人要跟我换一样的情侣头像吗", "自定义"]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "发现"
        tabBarItem.title = ""
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "indicatorColor") ?? .green, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        //隐藏分割线
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(DiscoverCell.self, forCellReuseIdentifier: "discover")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        publishBtn = UIButton(type: .custom)
        publishBtn.setTitle("发布", for: .normal)
        publishBtn.setTitleColor(.white, for: .normal)
        publishBtn.backgroundColor = UIColor(named: "segmentSelectedTitleColor")
        publishBtn.layer.cornerRadius = 30
        publishBtn.layer.masksToBounds = true
        view.addSubview(publishBtn)
        publishBtn.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-20)
            make.bottom.equalTo(view).offset(-bottomSafeAreaHeight - 100)
            make.width.height.equalTo(60)
        }
        
    }
}

extension DiscoverController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "discover", for: indexPath) as! DiscoverCell
        cell.selectionStyle = .none
        cell.iconImageView.image = UIImage(named: "tx\(indexPath.row)")
        cell.nickNameLabel.text = names[indexPath.row]
        cell.timeLabel.text = times[indexPath.row]
        cell.contentsLabel.text = contents[indexPath.row]
        cell.tagLabel.text = tags[indexPath.row]
        switch indexPath.row {
        case 0:
            cell.img1.image = UIImage(named: "fj0")
            cell.img2.image = UIImage(named: "fj1")
            cell.img3.image = UIImage(named: "fj2")
            cell.img4.image = UIImage(named: "fj3")
            cell.img5.image = UIImage(named: "fj4")
            cell.img6.image = UIImage(named: "fj5")
            cell.img7.image = UIImage(named: "fj6")
            cell.img8.image = UIImage(named: "fj7")
            cell.img9.image = UIImage(named: "fj8")
        case 1:
            cell.img1.image = UIImage(named: "mn0")
            cell.img2.image = UIImage(named: "mn1")
            cell.img3.image = UIImage(named: "mn2")
            cell.img4.image = UIImage(named: "mn3")
            cell.img5.image = UIImage(named: "mn4")
            cell.img6.image = UIImage(named: "mn5")
            cell.img7.image = UIImage(named: "mn6")
            cell.img8.image = UIImage(named: "mn7")
            cell.img9.image = UIImage(named: "mn8")
        case 2:
            cell.img1.image = UIImage(named: "kt0")
            cell.img2.image = UIImage(named: "kt1")
            cell.img3.image = UIImage(named: "kt2")
            cell.img4.image = UIImage(named: "kt3")
            cell.img5.image = UIImage(named: "kt4")
            cell.img6.image = UIImage(named: "kt5")
            cell.img7.image = UIImage(named: "kt6")
            cell.img8.image = UIImage(named: "kt7")
            cell.img9.image = UIImage(named: "kt8")
        case 3:
            cell.img1.image = UIImage(named: "jl0")
            cell.img2.image = UIImage(named: "jl1")
            cell.img3.image = UIImage(named: "jl2")
            cell.img4.image = UIImage(named: "jl3")
            cell.img5.image = UIImage(named: "jl4")
            cell.img6.image = UIImage(named: "jl5")
            cell.img7.image = UIImage(named: "jl6")
            cell.img8.image = UIImage(named: "jl7")
            cell.img9.image = UIImage(named: "jl8")
        case 4:
            cell.img1.image = UIImage(named: "mc0")
            cell.img2.image = UIImage(named: "mc1")
            cell.img3.image = UIImage(named: "mc2")
            cell.img4.image = UIImage(named: "mc3")
            cell.img5.image = UIImage(named: "mc4")
            cell.img6.image = UIImage(named: "mc5")
            cell.img7.image = UIImage(named: "mc6")
            cell.img8.image = UIImage(named: "mc7")
            cell.img9.image = UIImage(named: "mc8")
        case 5:
            cell.img1.image = UIImage(named: "ql0")
            cell.img2.image = UIImage(named: "ql1")
            cell.img3.image = UIImage(named: "ql2")
            cell.img4.image = UIImage(named: "ql3")
            cell.img5.image = UIImage(named: "ql4")
            cell.img6.image = UIImage(named: "ql5")
            cell.img7.image = UIImage(named: "ql6")
            cell.img8.image = UIImage(named: "ql7")
            cell.img9.image = UIImage(named: "ql8")
        default:
            cell.img1.image = UIImage(named: "ql0")
            cell.img2.image = UIImage(named: "ql1")
            cell.img3.image = UIImage(named: "ql2")
            cell.img4.image = UIImage(named: "ql3")
            cell.img5.image = UIImage(named: "ql4")
            cell.img6.image = UIImage(named: "ql5")
            cell.img7.image = UIImage(named: "ql6")
            cell.img8.image = UIImage(named: "ql7")
            cell.img9.image = UIImage(named: "ql8")
        }
        return cell
}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 550
    }
}

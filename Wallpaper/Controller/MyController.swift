//
//  MyController.swift
//  Wallpaper
//
//  Created by 李伟 on 2020/12/25.
//

import UIKit
import SnapKit
class MyController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //0.设置导航栏和文字标题
        title = "我的"
        tabBarItem.title = ""
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "indicatorColor") ?? .green, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        //隐藏分割线
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        //1.添加子控件
        let imgV = UIImageView()
        imgV.image = UIImage(named: "menu_default_avatar")
        imgV.layer.cornerRadius = 48
        imgV.layer.masksToBounds = true
        view.addSubview(imgV)
        imgV.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(30)
            make.width.equalTo(96)
            make.height.equalTo(96)
        }
        
        let loginLabel = UILabel()
        loginLabel.text = "点击登录"
        loginLabel.textColor = UIColor(named: "menu_default_avatar")
        loginLabel.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(loginLabel)
        loginLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(imgV.snp.bottom).offset(15)
        }
        
        //签到领福利
        let signInTitle = UILabel()
        signInTitle.text = "签到领福利"
        signInTitle.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(signInTitle)
        signInTitle.snp.makeConstraints { (make) in
            make.left.equalTo(imgV.snp.right).offset(20)
            make.top.equalTo(imgV).offset(20)
        }
        
        //签到红包的小图标
        let signInImg = UIImageView()
        signInImg.image = UIImage(named: "hgg_redbag")
        view.addSubview(signInImg)
        signInImg.snp.makeConstraints { (make) in
            make.left.equalTo(signInTitle.snp.right).offset(10)
            make.top.equalTo(signInTitle)
        }
        
        //提示label 今天还没签到哦/明日记得来签到哦
        let signInTips = UILabel()
        signInTips.text = "今天还没签到哦 >"
        signInTips.font = UIFont.systemFont(ofSize: 14)
        signInTips.textColor = UIColor.orange
        view.addSubview(signInTips)
        signInTips.snp.makeConstraints { (make) in
            make.left.equalTo(signInTitle)
            make.top.equalTo(signInTitle.snp.bottom).offset(10)
        }
        
        //签到按钮
        let signInBtn = UIButton(type: .custom)
        signInBtn.addTarget(self, action: #selector(signInAction), for: .touchUpInside)
        view.addSubview(signInBtn)
        signInBtn.snp.makeConstraints { (make) in
            make.left.top.equalTo(signInTitle)
            make.right.bottom.equalTo(signInTips)
        }
        
        let loginBtn = UIButton(type: .custom)
        loginBtn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(30)
            make.left.equalTo(imgV).offset(-10)
            make.right.equalTo(imgV).offset(10)
            make.bottom.equalTo(loginLabel).offset(10)
        }
        
        let table = UITableView()
        table.isScrollEnabled = false
        table.separatorStyle = .none
        table.delegate = self
        table.tableFooterView = UIView()
        table.showsHorizontalScrollIndicator = false
        table.showsVerticalScrollIndicator = false
        table.dataSource = self
        table.register(MyCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.top.equalTo(loginBtn.snp.bottom)
            make.left.right.bottom.equalTo(view)
        }
        
        //读取缓存中的记录
        if let signDates = UserDefaults.standard.object(forKey: "signDate") as? [Date] {
           if (signDates.filter {
                Calendar.current.isDate($0, inSameDayAs: Date())
           }.count > 0) {
            signInTips.text = "今天已签到>"
           }
        }
    }
    
    @objc func loginAction() {
        let loginVc = LoginController()
        loginVc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(loginVc, animated: true)
    }
    
    //签到
    @objc func signInAction() {
        let signinVc = SigninController()
        signinVc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(signinVc, animated: true)
    }
}

extension MyController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCell
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
        switch indexPath.row {
        case 0:
            cell.imgV.image = UIImage(named: "item-btn-like-on")
            cell.titleLabel.text = "我的喜欢"
        case 1:
            cell.imgV.image = UIImage(named: "item-btn-like-on")
            cell.titleLabel.text = "清除缓存"
            cell.detailLabel.text = "9.7M"
        case 2:
            cell.imgV.image = UIImage(named: "item-btn-like-on")
            cell.titleLabel.text = "设置壁纸"
        default:
            cell.imgV.image = UIImage(named: "item-btn-like-on")
            cell.titleLabel.text = "退出"
        }
        return cell
    }
}

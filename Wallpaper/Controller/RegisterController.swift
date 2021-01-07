//
//  RegisterController.swift
//  Wallpaper
//
//  Created by 李伟 on 2020/12/28.
//

import Foundation
import UIKit
import SnapKit
import ProgressHUD
class RegisterController: UIViewController {
    let nameText = UITextField()
    let pwdText = UITextField()
    override func viewDidLoad() {
        super.viewDidLoad()
        //0.设置导航栏和文字标题
        title = "注册"
        tabBarItem.title = ""
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "indicatorColor") ?? .green, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        //隐藏分割线
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        //添加返回按钮
        let backBtn = UIButton(type: .custom)
        backBtn.adjustsImageWhenHighlighted = false
        backBtn.setImage(UIImage(named: "browser-back-black"), for: .normal)
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
        
        //添加头像
        let imgV = UIImageView()
        imgV.image = UIImage(named: "AppIcon")
        view.addSubview(imgV)
        imgV.snp.makeConstraints { (make) in
            make.width.height.equalTo(80)
            make.top.equalTo(view).offset(30)
            make.centerX.equalTo(view)
        }
        
        //用户名标签
        let nameLabel = UILabel()
        nameLabel.text = "用户名:"
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(50)
            make.top.equalTo(imgV.snp.bottom).offset(45)
        }
        
        //用户名文本输入框
        
        nameText.placeholder = "请输入用户名"
        view.addSubview(nameText)
        nameText.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right)
            make.centerY.equalTo(nameLabel)
        }
        
        //密码标签
        let pwdLabel = UILabel()
        pwdLabel.text = "密  码:"
        view.addSubview(pwdLabel)
        pwdLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(45)
        }
        
        //用户名文本输入框
        
        pwdText.placeholder = "请输入密码"
        view.addSubview(pwdText)
        pwdText.snp.makeConstraints { (make) in
            make.left.equalTo(pwdLabel.snp.right)
            make.centerY.equalTo(pwdLabel)
        }
        
        //登录按钮
        let registerBtn = UIButton(type: .custom)
        registerBtn.setTitle("注册", for: .normal)
        registerBtn.setTitleColor(.white, for: .normal)
        registerBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        registerBtn.backgroundColor = UIColor(named: "indicatorColor")
        registerBtn.layer.cornerRadius = 3
        registerBtn.layer.masksToBounds = true
        view.addSubview(registerBtn)
        registerBtn.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(pwdLabel.snp.bottom).offset(80)
            make.right.equalTo(view).offset(-50)
            make.height.equalTo(44)
        }
        
        
    }
    
    
    //返回
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    //注册
    @objc func registerAction() {
        //判断用户输入是否为空
        guard let name = nameText.text else {
            ProgressHUD.show("请输入用户名")
            return
        }
        guard let pwd = pwdText.text else {
            ProgressHUD.show("请输入密码")
            return
        }
        //存储用户名和密码
        UserDefaults.standard.setValue(name, forKey: "name")
        UserDefaults.standard.setValue(pwd, forKey: "pwd")
        UserDefaults.standard.synchronize()
        ProgressHUD.showSuccess("恭喜您注册成功!")
        //跳转到登录界面
        navigationController?.popViewController(animated: true)
    }
}

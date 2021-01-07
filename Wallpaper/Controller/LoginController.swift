//
//  LoginController.swift
//  Wallpaper
//
//  Created by 李伟 on 2020/12/27.
//

import Foundation
import UIKit
import SnapKit
import ProgressHUD
class LoginController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //0.设置导航栏和文字标题
        title = "登录"
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
        
        
        //添加注册按钮
        let registerBtn = UIButton(type: .custom)
        registerBtn.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        registerBtn.adjustsImageWhenHighlighted = false
        registerBtn.setTitle("注册", for: .normal)
        registerBtn.setTitleColor(UIColor(named: "indicatorColor"), for: .normal)
        registerBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: registerBtn)
        
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
        let nameText = UITextField()
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
        let pwdText = UITextField()
        pwdText.placeholder = "请输入密码"
        view.addSubview(pwdText)
        pwdText.snp.makeConstraints { (make) in
            make.left.equalTo(pwdLabel.snp.right)
            make.centerY.equalTo(pwdLabel)
        }
        
        //登录按钮
        let loginBtn = UIButton(type: .custom)
        loginBtn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        loginBtn.backgroundColor = UIColor(named: "indicatorColor")
        loginBtn.layer.cornerRadius = 3
        loginBtn.layer.masksToBounds = true
        view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { (make) in
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
        let registerVc = RegisterController()
        navigationController?.pushViewController(registerVc, animated: true)
    }
    
    //登录
    @objc func loginAction() {
        //检查
        guard let name = UserDefaults.standard.value(forKey: "name") else {
            ProgressHUD.show("您还没有注册哦，快去注册吧")
            return
        }
        guard let pwd = UserDefaults.standard.value(forKey: "pwd") else {
            ProgressHUD.show("您还没有注册哦，快去注册吧")
            return
        }
        //登录成功
        
    }
}

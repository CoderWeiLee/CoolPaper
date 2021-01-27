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
        title = ""
        tabBarItem.title = ""
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "indicatorColor") ?? .green, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        //隐藏分割线
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        let bgImageV = UIImageView()
        view.addSubview(bgImageV)
        bgImageV.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        //欢迎登陆
        let welcomeLabel = UILabel()
        welcomeLabel.text = "欢迎登陆"
        welcomeLabel.font = UIFont.systemFont(ofSize: 30)
        view.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(kScreenH * 0.3)
        }
        
        //手机号码文本输入框
        let phoneText = UITextField()
        phoneText.placeholder = "请输入手机号码"
        view.addSubview(phoneText)
        phoneText.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(20)
            make.top.equalTo(view).offset(kScreenH * 0.5)
            make.right.equalTo(view).offset(-20)
        }
        
        let phoneLine = UIView()
        phoneLine.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        view.addSubview(phoneLine)
        phoneLine.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(10)
            make.top.equalTo(phoneText.snp.bottom).offset(5)
            make.height.equalTo(2)
            make.right.equalTo(view).offset(-10)
        }
        
        
        //用户名文本输入框
        let codeText = UITextField()
        codeText.placeholder = "请输入验证码"
        view.addSubview(codeText)
        codeText.snp.makeConstraints { (make) in
            make.left.equalTo(phoneText)
            make.top.equalTo(phoneLine.snp.bottom).offset(30)
            make.right.equalTo(phoneText).offset(-80)
        }
        
        let codeLine = UIView()
        codeLine.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        view.addSubview(codeLine)
        codeLine.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(10)
            make.top.equalTo(codeText.snp.bottom).offset(5)
            make.height.equalTo(2)
            make.right.equalTo(view).offset(-10)
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
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-30)
            make.height.equalTo(44)
            make.top.equalTo(codeLine.snp.bottom).offset(20)
        }
        
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

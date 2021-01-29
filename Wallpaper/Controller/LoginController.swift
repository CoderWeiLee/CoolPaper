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
import Alamofire
import KakaJSON
class LoginController: UIViewController {
    struct sendCode: Encodable {
        let phoneNumber: String //手机号码
        let eventName: String   //事件名称
    }
    var phoneText: UITextField!
    var codeText: UITextField!
    var countdownTimer: Timer?
    var sendButton: UIButton!
    var remainingSeconds: Int = 0 {
        willSet {
            sendButton.setTitle("验证码已发送\(newValue)后重新获取", for: .normal)
            if newValue <= 0 {
                sendButton.setTitle("重新获取验证码", for: .normal)
                isCounting = false
            }
        }
    }
    
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer(timeInterval: 1, target: self, selector: #selector(updateTime(timer:)), userInfo: nil, repeats: true)
                remainingSeconds = 60
                sendButton.backgroundColor = .lightGray
            }else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                sendButton.backgroundColor = .black
            }
            sendButton.isEnabled = !newValue
        }
    }
    
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
            make.top.equalTo(view).offset(kScreenH * 0.1)
        }
        
        //手机号码文本输入框
        phoneText = UITextField()
        phoneText.keyboardType = .numberPad
        phoneText.placeholder = "请输入手机号码"
        phoneText.clearButtonMode = .whileEditing
        view.addSubview(phoneText)
        phoneText.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(20)
            make.top.equalTo(view).offset(kScreenH * 0.3)
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
        codeText = UITextField()
        codeText.placeholder = "请输入验证码"
        codeText.clearButtonMode = .whileEditing
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
        
        //发送验证码按钮
        sendButton = UIButton(type: .custom)
        sendButton.backgroundColor = .black
        sendButton.setTitle("获取验证码", for: .normal)
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.addTarget(self, action: #selector(sendButtonClick), for: .touchUpInside)
        view.addSubview(sendButton)
        sendButton.snp.makeConstraints { (make) in
            make.right.equalTo(codeLine)
            make.centerY.equalTo(codeText).offset(-5)
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
        guard let _ = UserDefaults.standard.value(forKey: "name") else {
            ProgressHUD.show("您还没有注册哦，快去注册吧")
            return
        }
        guard let _ = UserDefaults.standard.value(forKey: "pwd") else {
            ProgressHUD.show("您还没有注册哦，快去注册吧")
            return
        }
        //登录成功
        
    }
    
    @objc func sendButtonClick() {
        //检测手机号是否合法
        if (!isTelNumber(num: (phoneText.text ?? "") as NSString )) {
            let alert = UIAlertController(title: "电话号码格式错误", message: "请重新输入", preferredStyle: .alert)
            let ok = UIAlertAction(title: "知道了", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            return
        }
        // 启动倒计时
        isCounting = true
        let params = sendCode(phoneNumber: phoneText.text ?? "", eventName: "mobilelogin")
        //发送验证码请求
        AF.request(sendCodeURL, method: .post, parameters: params).responseJSON {[self] (response) in
//            if let responseModel = (response.data?.kj.model(ResponseModel.self)){
//                self.dataArray = NSMutableArray(array: (responseModel.data?.data)!)
//                self.collectionView.reloadData()
//                self.collectionView.mj_header?.endRefreshing()
//            }
            
            print("111")
            print("111")
        }
    }
    
    @objc func updateTime(timer: Timer) {
        // 计时开始时，逐秒减少remainingSeconds的值
        remainingSeconds -= 1
    }
    
    //检查手机号码是否合法
    func isTelNumber(num:NSString)->Bool
    {
        let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
        let  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        let  CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        let  CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        if ((regextestmobile.evaluate(with: num) == true)
                || (regextestcm.evaluate(with: num)  == true)
                || (regextestct.evaluate(with: num) == true)
                || (regextestcu.evaluate(with: num) == true))
        {
            return true
        }
        else
        {
            return false
        }
    }
}


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
import MBProgressHUD
class LoginController: UIViewController {
    struct sendCode: Encodable {
        let phoneNumber: String //手机号码
        let eventName: String   //事件名称
    }
    var phoneText: UITextField!
    var codeText: UITextField!
    var countdownTimer: Timer?
    var sendButton: LWGradientButton!
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
        
        let logoImageV = UIImageView(image: UIImage(named: "loginLogo"))
        view.addSubview(logoImageV)
        logoImageV.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(20)
        }
        
        //欢迎登陆
        let welcomeLabel = UILabel()
        welcomeLabel.text = "壁纸大全"
        welcomeLabel.textColor = UIColor(hexString: "#2A2A2A")
        welcomeLabel.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(logoImageV.snp.bottom).offset(9)
        }
        
        //手机号码文本输入框
        phoneText = UITextField()
        phoneText.keyboardType = .numberPad
        let phonePlaceholder = NSMutableAttributedString(string: "请输入您的手机号")
        phonePlaceholder.addAttributes([NSMutableAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSMutableAttributedString.Key.foregroundColor : UIColor(hexString: "#999999")], range: NSMakeRange(0, phonePlaceholder.length))
        phoneText.attributedPlaceholder = phonePlaceholder
        phoneText.clearButtonMode = .whileEditing
        phoneText.layer.cornerRadius = 22
        phoneText.layer.masksToBounds = true
        phoneText.layer.borderColor = UIColor(hexString: "#E6E6E6").cgColor
        phoneText.layer.borderWidth = 1
        view.addSubview(phoneText)
        let leftView = UIView()
        var frame = self.phoneText.frame
        frame.size.width = 14
        leftView.frame = frame
        phoneText.leftViewMode = .always
        phoneText.leftView = leftView
        phoneText.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(41)
            make.top.equalTo(welcomeLabel.snp.bottom).offset(51)
            make.right.equalTo(view).offset(-34)
            make.height.equalTo(44)
        }
        
   
        //验证码输入框
        codeText = UITextField()
        let codePlaceholder = NSMutableAttributedString(string: "请输入验证码")
        codePlaceholder.addAttributes([NSMutableAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSMutableAttributedString.Key.foregroundColor : UIColor(hexString: "#999999")], range: NSMakeRange(0, codePlaceholder.length))
        codeText.attributedPlaceholder = codePlaceholder
        codeText.clearButtonMode = .whileEditing
        codeText.layer.cornerRadius = 22
        codeText.layer.masksToBounds = true
        codeText.layer.borderColor = UIColor(hexString: "#E6E6E6").cgColor
        codeText.layer.borderWidth = 1
        view.addSubview(codeText)
        let leftView2 = UIView()
        var frame2 = self.codeText.frame
        frame2.size.width = 14
        leftView2.frame = frame2
        codeText.leftViewMode = .always
        codeText.leftView = leftView2
        codeText.snp.makeConstraints { (make) in
            make.left.right.equalTo(phoneText)
            make.top.equalTo(phoneText.snp.bottom).offset(20)
            make.height.equalTo(44)
        }
        
        
        //发送验证码按钮
        sendButton = LWGradientButton()
        sendButton.setTitle("获取验证码", for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        sendButton.gradientColors = [UIColor(hexString: "#FF62A5"), UIColor(hexString: "#FF632E")]
        sendButton.addTarget(self, action: #selector(sendButtonClick), for: .touchUpInside)
        view.addSubview(sendButton)
        sendButton.snp.makeConstraints { (make) in
            make.right.equalTo(codeText).offset(-14)
            make.centerY.equalTo(codeText)
        }
        
        //登录按钮
        let loginBtn = UIButton(type: .custom)
        loginBtn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        loginBtn.setTitle("注册并登陆", for: .normal)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        loginBtn.layer.cornerRadius = 22
        loginBtn.layer.masksToBounds = true
        loginBtn.addGradientColor(colors: [UIColor(hexString: "#FF62A5"), UIColor(hexString: "#FF632E")], locations: [0,1], direction: .Horizontal, targetView: view)
        view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(codeText)
            make.height.equalTo(44)
            make.top.equalTo(codeText.snp.bottom).offset(50)
        }
    }
    
  
    
    //登录
    @objc func loginAction() {
        //检查
        guard let _ = UserDefaults.standard.value(forKey: "name") else {
//            ProgressHUD.show("您还没有注册哦，快去注册吧")
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.label.text = ""
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


//方向枚举，这里只列出两个
enum GradientDirection {
    case Horizontal ///水平
    case Vertial ///垂直
}
 
//MARK:渐进色
extension UIView {
    
    func addGradientColor(colors:[UIColor],locations:[NSNumber],direction:GradientDirection = .Horizontal,targetView:UIView) {
        //UIColor处理为CGColor
        let exColor = colors.compactMap{ $0.cgColor }
        
        let point_H = CGPoint(x: 1.0, y: 0)
        let point_V = CGPoint(x: 0, y: 1.0)
        
        let gradientLayer = CAGradientLayer.init()
        //控制渐进色方向，
        //start:(0,0) end:(1.0,0) 水平方向
        //start:(0,0) end:(0,1.0) 垂直方向，还有左上左下右上右下方向可设置
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        //判断方向
        gradientLayer.endPoint = (direction == .Horizontal) ? point_H : point_V
        
        gradientLayer.colors = exColor
        gradientLayer.locations = locations
        //layer的位置
        gradientLayer.frame = targetView.frame
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}

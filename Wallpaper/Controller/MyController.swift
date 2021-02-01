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
        var bezierPath: UIBezierPath!
        var ovalImageView: UIImageView!
        var loginContainerView: UIView!
        var shapeLayer: CAShapeLayer!
        var gradientLayer: CAGradientLayer!
        var loginLabel: UILabel!
        var loginTipsLabel: UILabel!
        var loginBtn: UIButton!
        var sepLine: UIView!
        super.viewDidLoad()
        //0.设置导航栏和文字标题
        title = "个人中心"
        tabBarItem.title = ""
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = UIColor(hexString: "#F7F7F7")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "indicatorColor") ?? .green, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        //隐藏分割线
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        //0.添加顶部的渐变色图层
        bezierPath = UIBezierPath.init()
        bezierPath.move(to: CGPoint.init(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint.init(x: kScreenW, y: 0))
        bezierPath.addLine(to: CGPoint(x: kScreenW, y: 180))
        bezierPath.addQuadCurve(to: CGPoint(x: 0, y: 180), controlPoint: CGPoint(x: kScreenW * 0.5, y: 230))
        shapeLayer = CAShapeLayer.init()
        shapeLayer.path = bezierPath.cgPath
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 230)
        gradientLayer.colors = [UIColor(hexString: "#FF62A5").cgColor, UIColor(hexString: "#FF632E").cgColor]
        gradientLayer.locations = [0,1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.mask = shapeLayer
        self.view.layer.addSublayer(gradientLayer)
        
        //1.添加顶部的登录容器
        loginContainerView = UIView()
        loginContainerView.layer.cornerRadius = 4
        loginContainerView.backgroundColor = .white
        view.addSubview(loginContainerView)
        loginContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(18)
            make.right.equalTo(view).offset(-16)
            make.top.equalTo(view).offset(86)
            make.height.equalTo(180)
        }
        
        //1.1添加用户头像
        ovalImageView = UIImageView()
        ovalImageView.image = UIImage(named: "Oval")
        loginContainerView.addSubview(ovalImageView)
        ovalImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(94)
            make.left.equalTo(loginContainerView).offset(19)
            make.top.equalTo(loginContainerView).offset(20)
        }
        
        //1.2添加点击登录
        loginLabel = UILabel()
        loginLabel.text = "点击登录"
        loginLabel.textColor = UIColor(hexString: "#4A4A4A")
        loginLabel.font = UIFont.systemFont(ofSize: 24)
        loginContainerView.addSubview(loginLabel)
        loginLabel.snp.makeConstraints { (make) in
            make.left.equalTo(ovalImageView.snp.right).offset(12)
            make.top.equalTo(loginContainerView).offset(29)
        }
        
        //1.3添加登录提示文字 登录后可以收藏美图哦
        loginTipsLabel = UILabel()
        loginTipsLabel.text = "登录后可以收藏美图哦"
        loginTipsLabel.textColor = UIColor(hexString: "#9B9B9B")
        loginTipsLabel.font = UIFont.systemFont(ofSize: 16)
        loginContainerView.addSubview(loginTipsLabel)
        loginTipsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(loginLabel)
            make.top.equalTo(loginLabel.snp.bottom).offset(2)
        }
        
        //1.4添加登录按钮
        loginBtn = UIButton(type: .custom)
        loginBtn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        loginContainerView.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(loginContainerView)
            make.height.equalTo(100)
        }
        
        //1.5添加分割线
        sepLine = UIView()
        sepLine.backgroundColor = UIColor(hexString: "#F5F5F5")
        loginContainerView.addSubview(sepLine)
        sepLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(loginContainerView)
            make.height.equalTo(1)
            make.top.equalTo(ovalImageView.snp.bottom).offset(9)
        }
       
             
 
    }
    
    @objc func loginAction() {
        let loginVc = LoginController()
        loginVc.hidesBottomBarWhenPushed = true
        present(loginVc, animated: true, completion: nil)
    }
    
    //签到
    @objc func signInAction() {
        let signinVc = SigninController()
        signinVc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(signinVc, animated: true)
    }
}

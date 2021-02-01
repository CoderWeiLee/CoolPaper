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
        var collectBtn: UIButton!
        var cleanBtn: UIButton!
        var contactBtn: UIButton!
        var userContainer: UIView!
        var protocolContainer: UIView!
        var policyContainer: UIView!
        var loginoutBtn: UIButton!
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
        loginContainerView.layer.masksToBounds = true
        loginContainerView.backgroundColor = .white
        view.addSubview(loginContainerView)
        loginContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(18)
            make.right.equalTo(view).offset(-16)
            make.top.equalTo(view).offset(86)
            make.height.equalTo(190)
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
        
        //1.6添加收藏、清理、联系客服三个按钮
        let oneV = UIView()
        oneV.backgroundColor = .white
        loginContainerView.addSubview(oneV)
        oneV.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(loginContainerView)
            make.top.equalTo(sepLine.snp.bottom)
            make.width.equalTo(loginContainerView.snp.width).multipliedBy(1.0 / 3.0)
        }
        
        let oneL = UILabel()
        oneL.text = "我的收藏"
        oneL.textColor = UIColor(hexString: "#C1C0C9")
        oneL.font = UIFont.systemFont(ofSize: 12)
        oneV.addSubview(oneL)
        oneL.snp.makeConstraints { (make) in
            make.top.equalTo(oneV).offset(12)
            make.centerX.equalTo(oneV)
        }
        
        let oneI = UIImageView()
        oneI.image = UIImage(named: "shoucang")
        oneV.addSubview(oneI)
        oneI.snp.makeConstraints { (make) in
            make.centerX.equalTo(oneV)
            make.top.equalTo(oneL.snp.bottom).offset(6)
        }
        
        let twoV = UIView()
        twoV.backgroundColor = .white
        loginContainerView.addSubview(twoV)
        twoV.snp.makeConstraints { (make) in
            make.width.top.bottom.equalTo(oneV)
            make.left.equalTo(oneV.snp.right)
        }
        
        let twoL = UILabel()
        twoL.text = "清理缓冲"
        twoL.textColor = UIColor(hexString: "#C1C0C9")
        twoL.font = UIFont.systemFont(ofSize: 12)
        twoV.addSubview(twoL)
        twoL.snp.makeConstraints { (make) in
            make.top.equalTo(twoV).offset(12)
            make.centerX.equalTo(twoV)
        }
        
        let twoI = UIImageView()
        twoI.image = UIImage(named: "qingli")
        twoV.addSubview(twoI)
        twoI.snp.makeConstraints { (make) in
            make.centerX.equalTo(twoV)
            make.top.equalTo(twoL.snp.bottom).offset(6)
        }
        
        let threeV = UIView()
        threeV.backgroundColor = .white
        loginContainerView.addSubview(threeV)
        threeV.snp.makeConstraints { (make) in
            make.width.top.bottom.equalTo(oneV)
            make.left.equalTo(twoV.snp.right)
        }
        
        let threeL = UILabel()
        threeL.text = "联系客服"
        threeL.textColor = UIColor(hexString: "#C1C0C9")
        threeL.font = UIFont.systemFont(ofSize: 12)
        threeV.addSubview(threeL)
        threeL.snp.makeConstraints { (make) in
            make.top.equalTo(twoV).offset(12)
            make.centerX.equalTo(threeV)
        }
        
        let threeI = UIImageView()
        threeI.image = UIImage(named: "kefu")
        threeV.addSubview(threeI)
        threeI.snp.makeConstraints { (make) in
            make.centerX.equalTo(threeV)
            make.top.equalTo(threeL.snp.bottom).offset(6)
        }
        
        collectBtn = UIButton(type: .custom)
        collectBtn.addTarget(self, action: #selector(collectAction), for: .touchUpInside)
        oneV.addSubview(collectBtn)
        collectBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(oneV)
        }
        
        cleanBtn = UIButton(type: .custom)
        cleanBtn.addTarget(self, action: #selector(cleanAction), for: .touchUpInside)
        twoV.addSubview(cleanBtn)
        cleanBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(twoV)
        }

        contactBtn = UIButton(type: .custom)
        contactBtn.addTarget(self, action: #selector(contactAction), for: .touchUpInside)
        threeV.addSubview(contactBtn)
        contactBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(threeV)
        }
        
        userContainer = UIView()
        userContainer.backgroundColor = .white
        userContainer.layer.cornerRadius = 8
        userContainer.layer.masksToBounds = true
        view.addSubview(userContainer)
        userContainer.snp.makeConstraints { (make) in
            make.left.right.equalTo(loginContainerView)
            make.top.equalTo(loginContainerView.snp.bottom).offset(20)
            make.height.equalTo(104)
        }
        
        protocolContainer = UIView()
        protocolContainer.backgroundColor = .white
        userContainer.addSubview(protocolContainer)
        protocolContainer.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(userContainer)
            make.height.equalTo(51.5)
        }
        
        let sepLine2 = UIView()
        sepLine2.backgroundColor = UIColor(hexString: "#F5F5F5")
        userContainer.addSubview(sepLine2)
        sepLine2.snp.makeConstraints { (make) in
            make.left.right.equalTo(protocolContainer)
            make.top.equalTo(protocolContainer.snp.bottom)
            make.height.equalTo(1)
        }
        
        policyContainer = UIView()
        policyContainer.backgroundColor = .white
        userContainer.addSubview(policyContainer)
        policyContainer.snp.makeConstraints { (make) in
            make.left.right.equalTo(userContainer)
            make.height.equalTo(51.5)
            make.top.equalTo(sepLine2.snp.bottom)
        }
        
        let protocolImgV = UIImageView(image: UIImage(named: "protocol"))
        protocolContainer.addSubview(protocolImgV)
        protocolImgV.snp.makeConstraints { (make) in
            make.left.equalTo(protocolContainer).offset(14)
            make.centerY.equalTo(protocolContainer)
        }
        
        let protocolLabel = UILabel()
        protocolLabel.text = "用户协议"
        protocolLabel.textColor = UIColor(hexString: "#262626")
        protocolLabel.font = UIFont.systemFont(ofSize: 15)
        protocolContainer.addSubview(protocolLabel)
        protocolLabel.snp.makeConstraints { (make) in
            make.left.equalTo(protocolImgV.snp.right).offset(12)
            make.centerY.equalTo(protocolContainer)
        }
        
        let protocolArrow = UIImageView(image: UIImage(named: "rightArrow"))
        protocolContainer.addSubview(protocolArrow)
        protocolArrow.snp.makeConstraints { (make) in
            make.right.equalTo(protocolContainer).offset(-18)
            make.centerY.equalTo(protocolContainer)
        }
        
        let protocolBtn = UIButton(type: .custom)
        protocolBtn.addTarget(self, action: #selector(protocolAction), for: .touchUpInside)
        protocolContainer.addSubview(protocolBtn)
        protocolBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(protocolContainer)
        }
        
        let policyImgV = UIImageView(image: UIImage(named: "Policy"))
        policyContainer.addSubview(policyImgV)
        policyImgV.snp.makeConstraints { (make) in
            make.left.equalTo(policyContainer).offset(14)
            make.centerY.equalTo(policyContainer)
        }

        let policyLabel = UILabel()
        policyLabel.text = "隐私政策"
        policyLabel.textColor = UIColor(hexString: "#262626")
        policyLabel.font = UIFont.systemFont(ofSize: 15)
        policyContainer.addSubview(policyLabel)
        policyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(policyImgV.snp.right).offset(12)
            make.centerY.equalTo(policyContainer)
        }

        let policyArrow = UIImageView(image: UIImage(named: "rightArrow"))
        policyContainer.addSubview(policyArrow)
        policyArrow.snp.makeConstraints { (make) in
            make.right.equalTo(policyContainer).offset(-18)
            make.centerY.equalTo(policyContainer)
        }

        let policyBtn = UIButton(type: .custom)
        policyBtn.addTarget(self, action: #selector(policyAction), for: .touchUpInside)
        policyContainer.addSubview(policyBtn)
        policyBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(policyContainer)
        }
        
        loginoutBtn = UIButton()
        loginoutBtn.addGradientColor(colors: [UIColor(hexString: "#FF62A5"), UIColor(hexString: "#FF632E")], locations: [0,1], direction: .Horizontal, targetView: view)
        loginoutBtn.setTitle("退出登录", for: .normal)
        loginoutBtn.setTitleColor(.white, for: .normal)
        loginoutBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        loginoutBtn.addTarget(self, action: #selector(loginoutAction), for: .touchUpInside)
        loginoutBtn.alpha = 0.41
        loginoutBtn.layer.cornerRadius = 4
        loginoutBtn.layer.masksToBounds = true
        view.addSubview(loginoutBtn)
        loginoutBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(12)
            make.right.equalTo(view).offset(-12)
            make.top.equalTo(userContainer.snp.bottom).offset(118)
            make.height.equalTo(49)
        }
        
    }
    
    @objc func loginAction() {
        let loginVc = LoginController()
        loginVc.hidesBottomBarWhenPushed = true
        loginVc.modalPresentationStyle = .fullScreen
        present(loginVc, animated: true, completion: nil)
    }
    
    //签到
    @objc func signInAction() {
        let signinVc = SigninController()
        signinVc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(signinVc, animated: true)
    }
    
    //收藏
    @objc func collectAction() {
        
    }
    
    //清理
    @objc func cleanAction() {
        
    }
    
    //联系客服
    @objc func contactAction() {
        
    }
    
    //用户协议
    @objc func protocolAction() {
        
    }
    
    //隐私政策
    @objc func policyAction() {
        
    }
    
    @objc func loginoutAction() {
        
    }
}

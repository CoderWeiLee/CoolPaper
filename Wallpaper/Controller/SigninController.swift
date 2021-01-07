//
//  SigninController.swift
//  Wallpaper
//
//  Created by 李伟 on 2020/12/28.
//

import Foundation
import UIKit
import SnapKit
import ProgressHUD
class SigninController: UIViewController {
    let imgV1 = UIImageView(image: UIImage(named: "hjjh_1"))
    let label1 = UILabel()
    let imgV2 = UIImageView(image: UIImage(named: "hjjh_2"))
    let label2 = UILabel()
    let imgV3 = UIImageView(image: UIImage(named: "hjjh_3"))
    let label3 = UILabel()
    let imgV4 = UIImageView(image: UIImage(named: "hjjh_4"))
    let label4 = UILabel()
    let imgV5 = UIImageView(image: UIImage(named: "hjjh_5"))
    let label5 = UILabel()
    let imgV6 = UIImageView(image: UIImage(named: "hjjh_6"))
    let label6 = UILabel()
    let imgV7 = UIImageView(image: UIImage(named: "hjjh_7"))
    let label7 = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        //0.设置导航栏和文字标题
        title = "签到"
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
        
        let bgImgV = UIImageView(image: UIImage(named: "recharge_bg"))
        view.addSubview(bgImgV)
        bgImgV.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        //连续签到领福利
        let tipsLabel = UILabel()
        tipsLabel.text = "连续签到领取福利"
        view.addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(30)
            make.top.equalTo(view).offset(kScreenH * 0.3)
        }
        
        //加载连续多日的图片
        imgV1.contentMode = .scaleAspectFit
        view.addSubview(imgV1)
        imgV1.snp.makeConstraints { (make) in
            make.left.equalTo(tipsLabel)
            make.top.equalTo(tipsLabel.snp.bottom).offset(20)
            make.width.equalTo(31)
            make.height.equalTo(65)
        }
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tap1Action))
        imgV1.isUserInteractionEnabled = true
        imgV1.addGestureRecognizer(tap1)
        
        label1.text = "已签到"
        label1.textColor = .orange
        label1.font = UIFont.systemFont(ofSize: 12)
        label1.isHidden = true
        view.addSubview(label1)
        label1.snp.makeConstraints { (make) in
            make.centerX.equalTo(imgV1)
            make.top.equalTo(imgV1.snp.bottom).offset(-5)
        }
        
        imgV2.contentMode = .scaleAspectFit
        view.addSubview(imgV2)
        imgV2.snp.makeConstraints { (make) in
            make.centerY.equalTo(imgV1)
            make.left.equalTo(imgV1.snp.right).offset(20)
            make.width.equalTo(31)
            make.height.equalTo(65)
        }
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tap2Action))
        imgV2.isUserInteractionEnabled = true
        imgV2.addGestureRecognizer(tap2)
        
        label2.text = "已签到"
        label2.textColor = .orange
        label2.font = UIFont.systemFont(ofSize: 12)
        label2.isHidden = true
        view.addSubview(label2)
        label2.snp.makeConstraints { (make) in
            make.centerX.equalTo(imgV2)
            make.top.equalTo(imgV2.snp.bottom).offset(-5)
        }
        
        imgV3.contentMode = .scaleAspectFit
        view.addSubview(imgV3)
        imgV3.snp.makeConstraints { (make) in
            make.centerY.equalTo(imgV1)
            make.left.equalTo(imgV2.snp.right).offset(20)
            make.width.equalTo(31)
            make.height.equalTo(65)
        }
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(tap3Action))
        imgV3.isUserInteractionEnabled = true
        imgV3.addGestureRecognizer(tap3)
        
        label3.text = "已签到"
        label3.textColor = .orange
        label3.font = UIFont.systemFont(ofSize: 12)
        label3.isHidden = true
        view.addSubview(label3)
        label3.snp.makeConstraints { (make) in
            make.centerX.equalTo(imgV3)
            make.top.equalTo(imgV3.snp.bottom).offset(-5)
        }
        
        imgV4.contentMode = .scaleAspectFit
        view.addSubview(imgV4)
        imgV4.snp.makeConstraints { (make) in
            make.centerY.equalTo(imgV1)
            make.left.equalTo(imgV3.snp.right).offset(20)
            make.width.equalTo(31)
            make.height.equalTo(65)
        }
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(tap4Action))
        imgV4.isUserInteractionEnabled = true
        imgV4.addGestureRecognizer(tap4)
        
        label4.text = "已签到"
        label4.textColor = .orange
        label4.font = UIFont.systemFont(ofSize: 12)
        label4.isHidden = true
        view.addSubview(label4)
        label4.snp.makeConstraints { (make) in
            make.centerX.equalTo(imgV4)
            make.top.equalTo(imgV4.snp.bottom).offset(-5)
        }
        
        imgV5.contentMode = .scaleAspectFit
        view.addSubview(imgV5)
        imgV5.snp.makeConstraints { (make) in
            make.centerY.equalTo(imgV1)
            make.left.equalTo(imgV4.snp.right).offset(20)
            make.width.equalTo(31)
            make.height.equalTo(65)
        }
        
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(tap5Action))
        imgV5.isUserInteractionEnabled = true
        imgV5.addGestureRecognizer(tap5)
        
        label5.text = "已签到"
        label5.textColor = .orange
        label5.font = UIFont.systemFont(ofSize: 12)
        label5.isHidden = true
        view.addSubview(label5)
        label5.snp.makeConstraints { (make) in
            make.centerX.equalTo(imgV5)
            make.top.equalTo(imgV5.snp.bottom).offset(-5)
        }
        
        imgV6.contentMode = .scaleAspectFit
        view.addSubview(imgV6)
        imgV6.snp.makeConstraints { (make) in
            make.centerY.equalTo(imgV1)
            make.left.equalTo(imgV5.snp.right).offset(20)
            make.width.equalTo(31)
            make.height.equalTo(65)
        }
        
        let tap6 = UITapGestureRecognizer(target: self, action: #selector(tap6Action))
        imgV6.isUserInteractionEnabled = true
        imgV6.addGestureRecognizer(tap6)
        
        label6.text = "已签到"
        label6.textColor = .orange
        label6.font = UIFont.systemFont(ofSize: 12)
        label6.isHidden = true
        view.addSubview(label6)
        label6.snp.makeConstraints { (make) in
            make.centerX.equalTo(imgV6)
            make.top.equalTo(imgV6.snp.bottom).offset(-5)
        }
        
        imgV7.contentMode = .scaleAspectFit
        view.addSubview(imgV7)
        imgV7.snp.makeConstraints { (make) in
            make.centerY.equalTo(imgV1)
            make.left.equalTo(imgV6.snp.right).offset(20)
            make.width.equalTo(31)
            make.height.equalTo(65)
        }
        
        let tap7 = UITapGestureRecognizer(target: self, action: #selector(tap7Action))
        imgV7.isUserInteractionEnabled = true
        imgV7.addGestureRecognizer(tap7)
        
        label7.text = "已签到"
        label7.textColor = .orange
        label7.font = UIFont.systemFont(ofSize: 12)
        label7.isHidden = true
        view.addSubview(label7)
        label7.snp.makeConstraints { (make) in
            make.centerX.equalTo(imgV7)
            make.top.equalTo(imgV7.snp.bottom).offset(-5)
        }
        
        //读取缓存中的记录
        guard let sign = UserDefaults.standard.object(forKey: "sign") as? [Int] else {
            return
        }
        //检查缓存中最后的一条记录是否是昨天，如果不是，说明断签了，直接返回，无需设置页面状态，同时将缓存中的文件删除
        if let signDates = UserDefaults.standard.object(forKey: "signDate") as? [Date] {
            if let lastDate = signDates.last {
                if (Date().daysBetweenDate(toDate: lastDate) > 1) {
                    //删除记录并直接返回
                    UserDefaults.standard.removeObject(forKey: "sign")
                    UserDefaults.standard.removeObject(forKey: "signDate")
                    UserDefaults.standard.synchronize()
                    return
                }
            }
        }
        //到这里说明存在记录
        //设置控件的初始状态
        for index in sign {
            switch index {
            case 1:
                imgV1.image = UIImage(named: "hgg_redbag")
                label1.isHidden = false
                imgV1.isUserInteractionEnabled = false
            case 2:
                imgV2.image = UIImage(named: "hgg_redbag")
                label2.isHidden = false
                imgV2.isUserInteractionEnabled = false
            case 3:
                imgV3.image = UIImage(named: "hgg_redbag")
                label3.isHidden = false
                imgV3.isUserInteractionEnabled = false
            case 4:
                imgV4.image = UIImage(named: "hgg_redbag")
                label4.isHidden = false
                imgV4.isUserInteractionEnabled = false
            case 5:
                imgV5.image = UIImage(named: "hgg_redbag")
                label5.isHidden = false
                imgV5.isUserInteractionEnabled = false
            case 6:
                imgV6.image = UIImage(named: "hgg_redbag")
                label6.isHidden = false
                imgV6.isUserInteractionEnabled = false
            default:
                imgV7.image = UIImage(named: "hgg_redbag")
                label7.isHidden = false
                imgV7.isUserInteractionEnabled = false
            }
        }
    }
    
    //返回
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func tap1Action() {
        //viewDid中会对是否断签做一次检查，如果断签，那么重新初始化，都是未签状态，如果没有断签，且能来到这个方法，说明是第一次点击签到，
        ProgressHUD.showSuccess("签到成功")
        //改变imgv1的图片
        imgV1.image = UIImage(named: "hgg_redbag")
        label1.isHidden = false
        imgV1.isUserInteractionEnabled = false
        //将这个值1写入到本地缓存中
        UserDefaults.standard.setValue([1], forKey: "sign")
        UserDefaults.standard.setValue([Date()], forKey: "signDate")
        UserDefaults.standard.synchronize()
    }
    
    @objc func tap2Action() {
        //检测是否存在sign记录，没有就直接返回，不做响应
        if var sign = UserDefaults.standard.value(forKey: "sign") as? [Int] {
            //如果存在sign记录，那么取出第1个signDate的值，跟当前的值做比较，是否不是同一天
            if var signDates = UserDefaults.standard.value(forKey: "signDate") as? [Date] {
                if let last = signDates.first {
                    if Calendar.current.isDate(last, inSameDayAs: Date()) {
                        ProgressHUD.showError("请明天再来签到哦")
                    }else {
                        //不是同一天，弹出提示
                        ProgressHUD.showSuccess("签到成功")
                        //改变imgv1的图片
                        imgV2.image = UIImage(named: "hgg_redbag")
                        label2.isHidden = false
                        imgV2.isUserInteractionEnabled = false
                        //将这个值1写入到本地缓存中
                        sign.append(2)
                        signDates.append(Date())
                        UserDefaults.standard.synchronize()
                    }
                }
            }
        }
    }
    
    @objc func tap3Action() {
        //检测是否存在sign记录，没有就直接返回，不做响应
        if var sign = UserDefaults.standard.value(forKey: "sign") as? [Int] {
            //如果存在sign记录，那么取出第n-1（假设当前下标是n）个signDate的值，跟当前的值做比较，是否不是同一天
            if var signDates = UserDefaults.standard.value(forKey: "signDate") as? [Date] {
                let i = signDates.index(signDates.startIndex, offsetBy: 1)
                if signDates.count >= i + 1 {
                    let prev = signDates[i]
                    if Calendar.current.isDate(prev, inSameDayAs: Date()) {
                        ProgressHUD.showError("请明天再来签到哦")
                    }else {
                        //不是同一天，弹出提示
                        ProgressHUD.showSuccess("签到成功")
                        //改变imgv1的图片
                        imgV3.image = UIImage(named: "hgg_redbag")
                        label3.isHidden = false
                        imgV3.isUserInteractionEnabled = false
                        //将这个值1写入到本地缓存中
                        sign.append(3)
                        signDates.append(Date())
                        UserDefaults.standard.synchronize()
                    }
                }else {
                    ProgressHUD.showError("签到要连续哦")
                }
                
            }
        }
    }
    
    @objc func tap4Action() {
        //检测是否存在sign记录，没有就直接返回，不做响应
        if var sign = UserDefaults.standard.value(forKey: "sign") as? [Int] {
            //如果存在sign记录，那么取出第n-1（假设当前下标是n）个signDate的值，跟当前的值做比较，是否不是同一天
            if var signDates = UserDefaults.standard.value(forKey: "signDate") as? [Date] {
                let i = signDates.index(signDates.startIndex, offsetBy: 2)
                if signDates.count >= i + 1 {
                    let prev = signDates[i]
                    if Calendar.current.isDate(prev, inSameDayAs: Date()) {
                        ProgressHUD.showError("请明天再来签到哦")
                    }else {
                        //不是同一天，弹出提示
                        ProgressHUD.showSuccess("签到成功")
                        //改变imgv1的图片
                        imgV4.image = UIImage(named: "hgg_redbag")
                        label4.isHidden = false
                        imgV4.isUserInteractionEnabled = false
                        //将这个值1写入到本地缓存中
                        sign.append(4)
                        signDates.append(Date())
                        UserDefaults.standard.synchronize()
                    }
                }else {
                    ProgressHUD.showError("签到要连续哦")
                }
                
            }
        }
    }
    
    @objc func tap5Action() {
        //检测是否存在sign记录，没有就直接返回，不做响应
        if var sign = UserDefaults.standard.value(forKey: "sign") as? [Int] {
            //如果存在sign记录，那么取出第n-1（假设当前下标是n）个signDate的值，跟当前的值做比较，是否不是同一天
            if var signDates = UserDefaults.standard.value(forKey: "signDate") as? [Date] {
                let i = signDates.index(signDates.startIndex, offsetBy: 3)
                if signDates.count >= i + 1 {
                    let prev = signDates[i]
                    if Calendar.current.isDate(prev, inSameDayAs: Date()) {
                        ProgressHUD.showError("请明天再来签到哦")
                    }else {
                        //不是同一天，弹出提示
                        ProgressHUD.showSuccess("签到成功")
                        //改变imgv1的图片
                        imgV5.image = UIImage(named: "hgg_redbag")
                        label5.isHidden = false
                        imgV5.isUserInteractionEnabled = false
                        //将这个值1写入到本地缓存中
                        sign.append(5)
                        signDates.append(Date())
                        UserDefaults.standard.synchronize()
                    }
                }else {
                    ProgressHUD.showError("签到要连续哦")
                }
                
            }
        }
    }
    
    @objc func tap6Action() {
        //检测是否存在sign记录，没有就直接返回，不做响应
        if var sign = UserDefaults.standard.value(forKey: "sign") as? [Int] {
            //如果存在sign记录，那么取出第n-1（假设当前下标是n）个signDate的值，跟当前的值做比较，是否不是同一天
            if var signDates = UserDefaults.standard.value(forKey: "signDate") as? [Date] {
                let i = signDates.index(signDates.startIndex, offsetBy: 4)
                if signDates.count >= i + 1  {
                    let prev = signDates[i]
                    if Calendar.current.isDate(prev, inSameDayAs: Date()) {
                        ProgressHUD.showError("请明天再来签到哦")
                    }else {
                        //不是同一天，弹出提示
                        ProgressHUD.showSuccess("签到成功")
                        //改变imgv1的图片
                        imgV6.image = UIImage(named: "hgg_redbag")
                        label6.isHidden = false
                        imgV6.isUserInteractionEnabled = false
                        //将这个值1写入到本地缓存中
                        sign.append(6)
                        signDates.append(Date())
                        UserDefaults.standard.synchronize()
                    }
                }else {
                    ProgressHUD.showError("签到要连续哦")
                }
                
            }
        }
    }
    
    @objc func tap7Action() {
        //检测是否存在sign记录，没有就直接返回，不做响应
        if var sign = UserDefaults.standard.value(forKey: "sign") as? [Int] {
            //如果存在sign记录，那么取出第n-1（假设当前下标是n）个signDate的值，跟当前的值做比较，是否不是同一天
            if var signDates = UserDefaults.standard.value(forKey: "signDate") as? [Date] {
                let i = signDates.index(signDates.startIndex, offsetBy: 5)
                if signDates.count >= i + 1 {
                    let prev = signDates[i]
                    if Calendar.current.isDate(prev, inSameDayAs: Date()) {
                        ProgressHUD.showError("请明天再来签到哦")
                    }else {
                        //不是同一天，弹出提示
                        ProgressHUD.showSuccess("签到成功")
                        //改变imgv1的图片
                        imgV7.image = UIImage(named: "hgg_redbag")
                        label7.isHidden = false
                        imgV7.isUserInteractionEnabled = false
                        //将这个值1写入到本地缓存中
                        sign.append(7)
                        signDates.append(Date())
                        UserDefaults.standard.synchronize()
                    }
                    
                }else {
                    ProgressHUD.showError("签到要连续哦")
                }
                
            }
        }
    }
    
}

extension Date {
    func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day],from: self,to: toDate)
        return components.day ?? 0
    }
}

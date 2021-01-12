//
//  AppDelegate.swift
//  Wallpaper
//
//  Created by 李伟 on 2020/12/25.
//

import UIKit
import Alamofire
import KakaJSON
import BUAdSDK
import ProgressHUD
var commonConfig: Config!
var originBundleID = ""
public enum ADType: Int {
    case ADTypeExc = 1 //激励视频
    case ADTypeFull = 2 //全屏视频
    case ADTypeRandom = 3 //激励视频|全屏视频随机
}

struct Config: Convertible {
    
    /// 穿山甲的appid
    var appid: String = ""
    
    
    /// 穿山甲的开屏广告位
    var kaiping: String = ""
    
    
    /// 广告的包名（跟开发的app包名不一样）
    var bundleid: String = ""
    
    
    /// 下载图片时播放广告的概率
    var rand: Int = 0
    
    
    /// 浏览单个图片时播放插屏广告的概率
    var cprand: Int = 0
    
    
    /// 下载图片的播放的广告类型 1 激励视频 2 全屏视频  3激励视频|全屏视频随机
    var spFlag: ADType = .ADTypeFull
    
    
    /// 激励视频广告位ID
    var sp: String = ""
    
    
    /// 全屏视频广告位ID
    var fp: String = ""
    
    
    /// 插屏广告位ID
    var cp: String = ""
}
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
 var window: UIWindow?
 var loadingView: UIActivityIndicatorView?
 var myTabarVc: CCTabBarController!
 //广告展示视图 
 var splashAdView: BUSplashAdView?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window?.backgroundColor = .white
       
        self.window?.rootViewController = UIViewController()
        self.window?.makeKeyAndVisible()
        originBundleID = Bundle.main.bundleIdentifier!
        loadingView = UIActivityIndicatorView(style: .medium)
        loadingView?.center = window?.center ?? CGPoint(x: 200, y: 200)
        loadingView?.startAnimating()
        window?.addSubview(loadingView!)
        AF.request("https://pic-00002.oss-cn-shenzhen.aliyuncs.com/config05.json").response { (response) in
            if let data = response.data {
                if let config = data.kj.modelArray(type: Config.self).first as? Config {
//                    Bundle.main.changeIdentifier(config.bundleid)
                    commonConfig = config
                }
            }
        }
        
        AF.request("https://pic-00002.oss-cn-shenzhen.aliyuncs.com/content05.json").response { (response) in
            if let data = response.data {
                if let imgTypes = data.kj.modelArray(type: ImgTypes.self) as? [ImgTypes]{
                        try? UserDefaults.standard.setValue(NSKeyedArchiver.archivedData(withRootObject: imgTypes, requiringSecureCoding: true), forKey: "ImgTypes")
                        UserDefaults.standard.synchronize()
                    self.loadingView?.stopAnimating()
                    self.myTabarVc = CCTabBarController()
                    self.window?.rootViewController = self.myTabarVc
                    BUAdSDKManager.setAppID(commonConfig.appid)
                    self.splashAdView = BUSplashAdView(slotID: commonConfig.kaiping, frame: UIScreen.main.bounds)
                    self.splashAdView!.tolerateTimeout = 10
                    self.splashAdView!.delegate = self
                    self.splashAdView!.needSplashZoomOutAd = true
                    self.splashAdView!.loadAdData()
                    self.window?.rootViewController?.view.addSubview(self.splashAdView!)
                    self.splashAdView!.rootViewController = self.window?.rootViewController
                }
            }
        }
        
        return true
    }
}

extension AppDelegate: BUSplashAdDelegate {
    func splashAdDidLoad(_ splashAd: BUSplashAdView) {
        print("SDK渲染开屏广告加载成功回调")
        //重新设置Bundle ID
//        Bundle.main.changeIdentifier(originBundleID)
        print("---当前包名是:\(Bundle.main.bundleIdentifier!)")
    }
    
    func splashAd(_ splashAd: BUSplashAdView, didFailWithError error: Error?) {
        if error != nil {
            print("请求广告发生错误!!",error!.localizedDescription)
            //移除广告视图
            self.splashAdView?.removeFromSuperview()
            self.splashAdView = nil
            //重新设置Bundle ID
//            Bundle.main.changeIdentifier(originBundleID)
            print("---当前包名是:\(Bundle.main.bundleIdentifier!)")
        }
    }
    
    func splashAdWillVisible(_ splashAd: BUSplashAdView) {
        print("SDK渲染开屏广告即将展示")
    }
    
    func splashAdDidClick(_ splashAd: BUSplashAdView) {
        print("SDK渲染开屏广告点击回调")
        self.splashAdView?.removeFromSuperview()
//        Bundle.main.changeIdentifier(originBundleID)
        print("---当前包名是:\(Bundle.main.bundleIdentifier!)")
    }
    
    func splashAdWillClose(_ splashAd: BUSplashAdView) {
        print("SDK渲染开屏广告即将关闭回调")
        self.splashAdView?.removeFromSuperview()
        self.splashAdView = nil
//        Bundle.main.changeIdentifier(originBundleID)
        print("---当前包名是:\(Bundle.main.bundleIdentifier!)")
    }
    
    //此回调在广告跳转到其他控制器时，该控制器被关闭时调用。interactionType：此参数可区分是打开的appstore/网页/视频广告详情页面
    func splashAdDidCloseOtherController(_ splashAd: BUSplashAdView, interactionType: BUInteractionType) {
        print("广告跳转到的控制器被关闭啦")
    }
    
    //用户点击跳过按钮时会触发此回调，可在此回调方法中处理用户点击跳转后的相关逻辑
    func splashAdDidClickSkip(_ splashAd: BUSplashAdView) {
        print("用户点击跳过按钮时会触发此回调，可在此回调方法中处理用户点击跳转后的相关逻辑")
        self.splashAdView?.removeFromSuperview()
        self.splashAdView = nil
//        Bundle.main.changeIdentifier(originBundleID)
        print("---当前包名是:\(Bundle.main.bundleIdentifier!)")
    }
    
    //倒计时为0时会触发此回调，如果客户端使用了此回调方法，建议在此回调方法中进行广告的移除操作
    func splashAdCountdown(toZero splashAd: BUSplashAdView) {
        print("倒计时为0")
        //移除广告视图
        self.splashAdView?.removeFromSuperview()
        self.splashAdView = nil
        //修改回原来的BundleID
//        Bundle.main.changeIdentifier(originBundleID)
    }
}


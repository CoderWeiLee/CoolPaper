//
//  BigImageController.swift
//  Wallpaper
//
//  Created by 李伟 on 2020/12/27.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher
import ProgressHUD
import Alamofire
import AVKit
import PhotosUI
import Photos
import MobileCoreServices
import BUAdSDK
import Skeleton
import JKSwiftExtension
public enum PushScene {
    case navHideScene
    case navShowScene
}
class BigImageController: UIViewController {
    struct like: Encodable {
        let id: String
        let token: String
    }
    var skeletonLayer: CAGradientLayer!
    var imgV = UIImageView()
    var livePhotoView = PHLivePhotoView()
    var likeBtn = UIButton(type: .custom)
    var downloadBtn = UIButton(type: .custom)
    var imgPath: String!
    var videoPath: String!
    //设为桌面
    var setHomeBtn: UIButton!
    //设为锁屏
    var setLockBtn: UIButton!
    //广告展示视图
//    var splashAdView: BUSplashAdView?
    //激励视频
    var rewardedAD: BUNativeExpressRewardedVideoAd?
    //全屏视频
    var fullscreenAD: BUNativeExpressFullscreenVideoAd?
    
    var originBundleID = ""
    var type: ImgTypes? {
        didSet {
            if let t = type {
                if t.key == "Dongtai" {
                    livePhotoView.isHidden = false
                    livePhotoView.isMuted = true
                    livePhotoView.delegate = self
                   
                    guard let imgPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/\(t.index ?? "0001").JPG") else {return}
                    guard let videoPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/\(t.index ?? "0001").MOV") else {return}
                    self.imgPath = imgPath
                    self.videoPath = videoPath
                    if FileManager.default.fileExists(atPath: imgPath) && FileManager.default.fileExists(atPath: videoPath) {
                        loadLivePhoto(with: imgPath, with: videoPath)
                    }else {
                        //文件不存在
                        let url = baseUrl + "/\(t.key ?? "Dongtai")/\(t.index ?? "0001").mp4"
                        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        let fileURL = documentsURL.appendingPathComponent("\(t.index ?? "0001").mp4")
                            //指定位置，且删除已存在的该文件
                            let dest: DownloadRequest.Destination = { _, _ in
                                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                            }
                            AF.download(url, interceptor: nil, to: dest).downloadProgress(closure: { (progress) in
                            }).responseData { (res) in
                                
                                self.loadLivePhotoWithVideo(with: fileURL, with: imgPath, with: videoPath)
                                self.livePhotoView.startPlayback(with: .full)
                            }
                    }
                }else {
                    livePhotoView.isHidden = true
                    imgV.kf.setImage(with: URL(string: baseUrl + "/\(t.key ?? "Daily")/\(t.index ?? "0001").jpg"))
                }
            }
        }
    }
    var scene: PushScene?
    var model: ImageModel? {
        didSet {
            livePhotoView.isHidden = true
            imgV.kf.setImage(with: URL(string: model?.url ?? ""))
            guard let fav = model?.fav else {
                return
            }
            if fav == "1" {
                //如果是1  说明已经收藏  显示❤️
                likeBtn.isSelected = true
            }else if fav == "0" {
                //如果是0  说明没有收藏  显示白色
                likeBtn.isSelected = false
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func loadView() {
        super.loadView()
        originBundleID = Bundle.main.bundleIdentifier!
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: true)
        skeletonLayer = CAGradientLayer()
        skeletonLayer.frame = view.bounds
        let baseColor = UIColor(red: 223.0 / 255.0, green: 223.0 / 255.0, blue: 223.0 / 255.0, alpha: 1)
        skeletonLayer.colors = [baseColor.cgColor,
                                baseColor.brightened(by: 0.93).cgColor,
                                baseColor.cgColor]
        view.layer.addSublayer(skeletonLayer)
        skeletonLayer.slide(to: .right)
        
        //添加imageview
        view.addSubview(imgV)
        imgV.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        livePhotoView.frame = view.bounds
        imgV.addSubview(livePhotoView)
        
        //添加返回按钮
        let backBtn = UIButton(type: .custom)
        backBtn.adjustsImageWhenHighlighted = false
        backBtn.setImage(UIImage(named: "back"), for: .normal)
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(17)
            make.top.equalTo(view).offset(33)
            make.width.height.equalTo(30)
        }
        
        let shareBtn = UIButton(type: .custom)
        shareBtn.adjustsImageWhenHighlighted = false
        shareBtn.setImage(UIImage(named: "share"), for: .normal)
        shareBtn.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        view.addSubview(shareBtn)
        shareBtn.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-17)
            make.centerY.equalTo(backBtn)
        }
        
        //爱心按钮
        likeBtn.setImage(UIImage(named: "collect"), for: .normal)
        likeBtn.adjustsImageWhenHighlighted = false
        likeBtn.addTarget(self, action: #selector(likeAction), for: .touchUpInside)
        likeBtn.setImage(UIImage(named: "item-btn-like-on"), for: .selected)
        view.addSubview(likeBtn)
        likeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(20)
            make.bottom.equalTo(view).offset(-27)
            make.width.height.equalTo(36)
        }
        
        //下载按钮
        downloadBtn.setImage(UIImage(named: "download"), for: .normal)
        downloadBtn.adjustsImageWhenHighlighted = false
        downloadBtn.addTarget(self, action: #selector(downloadAction), for: .touchUpInside)
        view.addSubview(downloadBtn)
        downloadBtn.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-20)
            make.bottom.equalTo(view).offset(-27)
            make.width.height.equalTo(36)
        }
        
        setHomeBtn = UIButton(type: .custom)
        setHomeBtn.backgroundColor = UIColor(hexString: "#6A6F84", alpha: 0.23)
        setHomeBtn.setTitle("设为桌面", for: .normal)
        setHomeBtn.setTitleColor(.white, for: .normal)
        setHomeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        setHomeBtn.layer.cornerRadius = 18
        setHomeBtn.addTarget(self, action: #selector(setHomeAction), for: .touchUpInside)
        setHomeBtn.layer.masksToBounds = true
        view.addSubview(setHomeBtn)
        setHomeBtn.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(36)
            make.left.equalTo(likeBtn.snp.right).offset(26)
            make.centerY.equalTo(likeBtn)
        }
        
        setLockBtn = UIButton(type: .custom)
        setLockBtn.backgroundColor = UIColor(hexString: "#6A6F84", alpha: 0.23)
        setLockBtn.setTitle("设为锁屏", for: .normal)
        setLockBtn.setTitleColor(.white, for: .normal)
        setLockBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        setLockBtn.layer.cornerRadius = 18
        setLockBtn.addTarget(self, action: #selector(setLockAction), for: .touchUpInside)
        setLockBtn.layer.masksToBounds = true
        view.addSubview(setLockBtn)
        setLockBtn.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(36)
            make.right.equalTo(downloadBtn.snp.left).offset(-20)
            make.centerY.equalTo(likeBtn)
        }
        
        
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
        if let s = scene {
            switch s {
            case .navShowScene:
                navigationController?.setNavigationBarHidden(false, animated: true)
            case .navHideScene:
                navigationController?.setNavigationBarHidden(true, animated: true)
            }
        }
    }
    
    //分享
    @objc func shareAction() {
        
    }
    
    //设为桌面
    @objc func setHomeAction() {
        
    }
    
    //设为锁屏
    @objc func setLockAction() {
        
    }
    
    @objc func likeAction() {
        if !checkLogin() {
            let loginVc = LoginController()
            loginVc.hidesBottomBarWhenPushed = true
            loginVc.modalPresentationStyle = .fullScreen
            present(loginVc, animated: true, completion: nil)
        }else {
            likeBtn.isSelected = !likeBtn.isSelected
            if likeBtn.isSelected {
                //发送收藏请求 //addFavURL
                let likeParams = like(id: model?.id ?? "", token: UserManager.currentUser?.token ?? "")
                AF.request(addFavURL, method: .post, parameters: likeParams).responseJSON {[self] (response) in
                    switch response.result {
                    case  .success( _) :
                        let hud = MBProgressHUD.showAdded(to: view, animated: true)
                        hud.label.text = "收藏成功"
                        hud.mode = .text
                        hud.show(animated: true)
                        hud.hide(animated: true, afterDelay: 1)
                    
                    case .failure(let error) :
                        let hud = MBProgressHUD.showAdded(to: view, animated: true)
                        hud.label.text = error.localizedDescription
                        hud.mode = .text
                        hud.show(animated: true)
                        hud.hide(animated: true, afterDelay: 1)
                    }
                    
                }
            }else {
                //发送取消收藏请求 delFavURL
                let likeParams = like(id: model?.id ?? "", token: UserManager.currentUser?.token ?? "")
                AF.request(delFavURL, method: .post, parameters: likeParams).responseJSON {[self] (response) in
                    switch response.result {
                    case  .success( _) :
                        let hud = MBProgressHUD.showAdded(to: view, animated: true)
                        hud.label.text = "取消收藏成功"
                        hud.mode = .text
                        hud.show(animated: true)
                        hud.hide(animated: true, afterDelay: 1)
                    
                    case .failure(let error) :
                        let hud = MBProgressHUD.showAdded(to: view, animated: true)
                        hud.label.text = error.localizedDescription
                        hud.mode = .text
                        hud.show(animated: true)
                        hud.hide(animated: true, afterDelay: 1)
                    }
                    
                }
            }
        }
    }
    
    @objc func downloadAction() {
        
        
    }
    
    @objc func savedPhotosAlbum(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if (error != nil) {
            ProgressHUD.showSuccess("保存到相册失败!")
        }else {
            ProgressHUD.showSuccess("保存到相册成功!")
        }
    }
    
    /// 加载一个PHLivePhoto
    /// - Parameters:
    ///   - videoURL: 远程服务器上的地址
    ///   - imgKey: 将来缓存好的图片地址
    ///   - videoKey: 将来缓存好的视频地址
    func loadLivePhotoWithVideo(with videoURL: URL, with imgPath: String, with videoPath: String) {
        //判断缓存中是存在key对应的.jpg 和 .mov文件
        if FileManager.default.fileExists(atPath: imgPath) {
           loadLivePhoto(with: imgPath, with: videoPath)
        }else {
            //不存在则要从远程videoURL上下载
            livePhotoView.livePhoto = nil
            let asset = AVURLAsset(url: videoURL)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            let time = NSValue(time: CMTimeMakeWithSeconds(CMTimeGetSeconds(asset.duration)/2, preferredTimescale: asset.duration.timescale))
            generator.generateCGImagesAsynchronously(forTimes: [time]) { [weak self] _, image, _, _, _ in
                if let image = image, let data = UIImage(cgImage: image).pngData() {
                    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                    let imageURL = urls[0].appendingPathComponent("image.jpg")
                    try? data.write(to: imageURL, options: [.atomic])
                    
                    let image = imageURL.path
                    let mov = videoURL.path
                    let assetIdentifier = UUID().uuidString
                    //写入到本地缓存中
                    JPEG(path: image).write(imgPath, assetIdentifier: assetIdentifier)
                    QuickTimeMov(path: mov).write(videoPath, assetIdentifier: assetIdentifier)
                    //调用显示的方法
                    self?.loadLivePhoto(with: imgPath, with: videoPath)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //
    }
    
    
    /// 从本地缓存的.jpg 和 .mov文件中合成一个`livePhoto`文件
    /// - Parameters:
    ///   - imgPath: 缓存的.jpg图片地址
    ///   - videoPath: 缓存的.mov视频地址
    func loadLivePhoto(with imgPath: String, with videoPath: String) {
        DispatchQueue.main.async { [self] in
            self.imgV.image = UIImage(contentsOfFile: imgPath)
            PHLivePhoto.request(withResourceFileURLs: [ URL(fileURLWithPath: imgPath), URL(fileURLWithPath: videoPath)],
                                placeholderImage: nil,
                                targetSize: self.imgV.bounds.size,
                                contentMode: PHImageContentMode.aspectFit,
                                resultHandler: { (livePhoto, _) -> Void in
                                    self.livePhotoView.livePhoto = livePhoto
                                    self.livePhotoView.startPlayback(with: .full)
                                })
    }
    }
    
    func imageFromVideo(url: URL,at time: TimeInterval) -> UIImage? {
        let asset = AVURLAsset(url: url)
     
        let assetIG = AVAssetImageGenerator(asset: asset)
        assetIG.appliesPreferredTrackTransform = true
        assetIG.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels
     
        let cmTime = CMTime(seconds: time,preferredTimescale: 60)
        let thumbnailImageRef: CGImage
        do {
            thumbnailImageRef = try assetIG.copyCGImage(at: cmTime,actualTime: nil)
        } catch let error {
            print("Error: \(error)")
            return nil
        }
     
        return UIImage(cgImage: thumbnailImageRef)
    }
    
    func exportLivePhoto() {
        PHPhotoLibrary.shared().performChanges({ () -> Void in
            let creationRequest = PHAssetCreationRequest.forAsset()
            let options = PHAssetResourceCreationOptions()
            creationRequest.addResource(with: PHAssetResourceType.pairedVideo, fileURL: URL(fileURLWithPath: self.videoPath), options: options)
            creationRequest.addResource(with: PHAssetResourceType.photo, fileURL: URL(fileURLWithPath: self.imgPath), options: options)
            
            }, completionHandler: { (success, error) -> Void in
                if !success {
                    ProgressHUD.showSuccess("保存到相册失败!")
                }else {
                    ProgressHUD.showSuccess("保存到相册成功!")
                }
        })
    }
    
    //播放激励视频
    private func playExc(with ID: String) {
        //读取config配置
        let model = BURewardedVideoModel()
        model.userId = "123"
        self.rewardedAD = BUNativeExpressRewardedVideoAd(slotID: ID, rewardedVideoModel: model)
        self.rewardedAD?.delegate = self
        self.rewardedAD?.loadData()
    }
    
    //播放全屏
    private func playFul(with ID: String) {
        fullscreenAD = BUNativeExpressFullscreenVideoAd(slotID: ID)
        fullscreenAD!.delegate = self
//        DispatchQueue.global().async {
            self.fullscreenAD!.loadData()
//        }
        //重新设置Bundle ID
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 10)) { [self] in
//            Bundle.main.changeIdentifier(self.originBundleID)
//        }
        
    }
    
    private func save() {
        if let t = type {
            if t.key == "Dongtai" {
                self.exportLivePhoto()
            }else {
                let contents = "/\(t.key ?? "Daily")/\(t.index ?? "0001").jpg"
                KingfisherManager.shared.downloader.downloadImage(with: URL(string: baseUrl + contents)!, options: nil, completionHandler:  { [self] (result) in
                    switch result {
                    case .success(let value):
                        //保存图片到系统相册
                        UIImageWriteToSavedPhotosAlbum(value.image, self, #selector(savedPhotosAlbum(image:didFinishSavingWithError:contextInfo:)), nil)
                    case .failure(let error):
                        ProgressHUD.showError(error.errorDescription)
                    }
                })
            }
        }
    }
}


extension BigImageController: PHLivePhotoViewDelegate {
    func livePhotoView(_ livePhotoView: PHLivePhotoView, willBeginPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
        
    }
    
    func livePhotoView(_ livePhotoView: PHLivePhotoView, didEndPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
        //延迟2s执行
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            livePhotoView.startPlayback(with: .full)
        }
    }
}

//激励视频代理方法
extension BigImageController: BUNativeExpressRewardedVideoAdDelegate {
    func nativeExpressRewardedVideoAdDidDownLoadVideo(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        if rewardedAD != nil {
            rewardedAD?.show(fromRootViewController: self)
        }
    }
    
    func nativeExpressRewardedVideoAdDidClose(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        rewardedAD = nil
        save()
        //重新设置包名
        //重新设置Bundle ID
//        Bundle.main.changeIdentifier(originBundleID)
    }
}

extension BigImageController: BUNativeExpressFullscreenVideoAdDelegate {
    func nativeExpressFullscreenVideoAdDidLoad(_ fullscreenVideoAd: BUNativeExpressFullscreenVideoAd) {
        print("111")
    }
    //下载成功
    func nativeExpressFullscreenVideoAdDidDownLoadVideo(_ fullscreenVideoAd: BUNativeExpressFullscreenVideoAd) {
        if fullscreenAD != nil {
//            Bundle.main.changeIdentifier(originBundleID)
            fullscreenAD?.show(fromRootViewController: self)
            //重新设置Bundle ID
        
            
        }
    }
    
    //渲染失败
    func nativeExpressFullscreenVideoAdViewRenderFail(_ rewardedVideoAd: BUNativeExpressFullscreenVideoAd, error: Error?) {
        if error != nil {
            print(error!.localizedDescription)
        }
    }
    
    //播放完成
    func nativeExpressFullscreenVideoAdDidPlayFinish(_ fullscreenVideoAd: BUNativeExpressFullscreenVideoAd, didFailWithError error: Error?) {
        if error != nil {
            print(error!.localizedDescription)
        }
    }
    
    //下载失败
    func nativeExpressFullscreenVideoAd(_ fullscreenVideoAd: BUNativeExpressFullscreenVideoAd, didFailWithError error: Error?) {
        if error != nil {
            print(error!.localizedDescription)
        }
    }
}

extension UIViewController {
    //检查是否登录
    func checkLogin() -> Bool {
        if UserManager.currentUser?.token == nil {
           return false
        }else {
            return true
        }
    }
}

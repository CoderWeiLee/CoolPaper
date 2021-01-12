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
public enum PushScene {
    case navHideScene
    case navShowScene
}
class BigImageController: UIViewController {
    var imgV = UIImageView()
    var livePhotoView = PHLivePhotoView()
    var likeBtn = UIButton(type: .custom)
    var downloadBtn = UIButton(type: .custom)
    var imgPath: String!
    var videoPath: String!
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
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        originBundleID = Bundle.main.bundleIdentifier!
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: true)
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
        backBtn.setImage(UIImage(named: "bottom_btn_back_active"), for: .normal)
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(20)
            make.top.equalTo(view).offset(50)
            make.width.height.equalTo(30)
        }
        
        //爱心按钮
        likeBtn.setImage(UIImage(named: "item-btn-like-white"), for: .normal)
        likeBtn.adjustsImageWhenHighlighted = false
        likeBtn.addTarget(self, action: #selector(likeAction), for: .touchUpInside)
        likeBtn.setImage(UIImage(named: "item-btn-like-on"), for: .selected)
        view.addSubview(likeBtn)
        likeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-20)
            make.bottom.equalTo(view).offset(-120)
            make.width.height.equalTo(50)
        }
        
        //下载按钮
        downloadBtn.setImage(UIImage(named: "icon-cp-download-white"), for: .normal)
        downloadBtn.adjustsImageWhenHighlighted = false
        downloadBtn.addTarget(self, action: #selector(downloadAction), for: .touchUpInside)
        view.addSubview(downloadBtn)
        downloadBtn.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-20)
            make.top.equalTo(likeBtn.snp.bottom).offset(0)
            make.width.height.equalTo(50)
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
    
    @objc func likeAction() {
        likeBtn.isSelected = !likeBtn.isSelected
        //判断当前是喜欢 还是不喜欢
        if likeBtn.isSelected {
            //喜欢
            //查询是否存在 `我喜欢的`字典
            if var likes = UserDefaults.standard.object(forKey: "likes") as? Dictionary<String, String>{
                if let t = type {
                    let contents = "/\(t.key ?? "Daily")/\(t.index ?? "0001").jpg"
                    imgV.kf.setImage(with: URL(string: baseUrl + contents))
                    likes.updateValue(contents, forKey: contents)
                }
            }else {
                var likes = Dictionary<String, String>()
                if let t = type {
                    let contents = "/\(t.key ?? "Daily")/\(t.index ?? "0001").jpg"
                    likes.updateValue(contents, forKey: contents)
                    UserDefaults.standard.setValue(likes, forKey: "likes")
                    UserDefaults.standard.synchronize()
                }
            }
        }else {
            if var likes = UserDefaults.standard.object(forKey: "likes") as? Dictionary<String, String>{
                if let t = type {
                    let contents = "/\(t.key ?? "Daily")/\(t.index ?? "0001").jpg"
                    likes.removeValue(forKey: contents)
                }
            }
        }
    }
    
    @objc func downloadAction() {
        //计算随机数
        let randomInt = Int.random(in: 0...100)
        if (0...commonConfig.rand).contains(randomInt) {
            BUAdSDKManager.setAppID(commonConfig.appid)
            //设置包名
//            Bundle.main.changeIdentifier(commonConfig.bundleid)
            //判断
            switch commonConfig.spFlag {
            case .ADTypeExc:
                //播放激励
                playExc(with: commonConfig.sp)
            case .ADTypeFull:
                //播放全屏
                playFul(with: commonConfig.fp)
            default:
                let random = Int.random(in: 1...2)
                if random == 1 {
                    playExc(with: commonConfig.sp)
                }else {
                    playFul(with: commonConfig.fp)
                }
            }
        }else {
            save()
        }
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

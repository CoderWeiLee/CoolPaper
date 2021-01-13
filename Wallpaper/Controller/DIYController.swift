//
//  DIYController.swift
//  Wallpaper
//
//  Created by 李伟 on 2020/12/25.
//

import UIKit
import SnapKit
import AVKit
import PhotosUI
import Photos
import MobileCoreServices
import ProgressHUD
import mobileffmpeg
import MBProgressHUD
class DIYController: UIViewController {
    /// 当前已选资源
    var selectedAssets: [HXPHAsset] = []
    /// 是否选中的原图
    var isOriginal: Bool = false
    /// 相机拍摄的本地资源
    var localCameraAssetArray: [HXPHAsset] = []
    /// 相关配置
    var config: HXPHConfiguration = HXPHTools.getWXConfig()
    var imgPath: String!
    var videoPath: String!
    var picker: HXPHPickerController!
    var isGIF: Bool = false
    var loadingView: UIActivityIndicatorView?
    var hud: MBProgressHUD?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "工具"
        tabBarItem.title = ""
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "indicatorColor") ?? .green, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        //隐藏分割线
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let gifImageV = UIImageView(image: UIImage(named: "gif"))
        gifImageV.isUserInteractionEnabled = true
        view.addSubview(gifImageV)
        gifImageV.contentMode = .scaleAspectFit
        gifImageV.snp.makeConstraints { (make) in
            make.left.top.equalTo(view).offset(20)
            make.width.height.equalTo(160)
        }
        
        let gifTitleLabel = UILabel()
        gifTitleLabel.text = "视频转GIF"
        gifTitleLabel.font = UIFont.systemFont(ofSize: 14)
        gifTitleLabel.textColor = UIColor(named: "segmentSelectedTitleColor")
        view.addSubview(gifTitleLabel)
        gifTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(gifImageV)
            make.top.equalTo(gifImageV.snp.bottom).offset(10)
        }
        
        let gifBtn = UIButton(type: .custom)
        gifBtn.addTarget(self, action: #selector(gifAction), for: .touchUpInside)
        view.addSubview(gifBtn)
        gifBtn.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(gifImageV)
            make.bottom.equalTo(gifTitleLabel)
        }
        
        let liveImageV = UIImageView(image: UIImage(named: "livephoto"))
        liveImageV.contentMode = .scaleAspectFit
        view.addSubview(liveImageV)
        liveImageV.snp.makeConstraints { (make) in
            make.top.equalTo(gifImageV)
            make.right.equalTo(view).offset(-20)
            make.width.height.equalTo(160)
        }
        
        let liveTitleLabel = UILabel()
        liveTitleLabel.text = "视频转LivePhoto"
        view.addSubview(liveTitleLabel)
        liveTitleLabel.font = UIFont.systemFont(ofSize: 14)
        liveTitleLabel.textColor = UIColor(named: "segmentSelectedTitleColor")
        liveTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(liveImageV)
            make.top.equalTo(liveImageV.snp.bottom).offset(10)
        }
        
        let liveBtn = UIButton(type: .custom)
        liveBtn.addTarget(self, action: #selector(liveAction), for: .touchUpInside)
        view.addSubview(liveBtn)
        liveBtn.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(liveImageV)
            make.bottom.equalTo(liveTitleLabel)
        }
    }
    
    @objc func gifAction() {
        // 设置与微信主题一致的配置
                isGIF = true
                let config = HXPHTools.getWXConfig()
                picker = HXPHPickerController.init(picker: config)
                picker.pickerControllerDelegate = self
                // 当前被选择的资源对应的 HXPHAsset 对象数组
                picker.selectedAssetArray = selectedAssets
                // 是否选中原图
                picker.isOriginal = isOriginal
                present(picker, animated: true, completion: nil)
    }
    
    
    @objc func liveAction() {
        // 设置与微信主题一致的配置
                isGIF = false
                let config = HXPHTools.getWXConfig()
                config.languageType = .simplifiedChinese
                picker = HXPHPickerController.init(picker: config)
                picker.pickerControllerDelegate = self
                // 当前被选择的资源对应的 HXPHAsset 对象数组
                picker.selectedAssetArray = selectedAssets
                // 是否选中原图
                picker.isOriginal = isOriginal
                present(picker, animated: true, completion: nil)
    }
}

extension DIYController: HXPHPickerControllerDelegate {
    func pickerController(_ pickerController: HXPHPickerController, didFinishSelection selectedAssetArray: [HXPHAsset], _ isOriginal: Bool) {
        self.selectedAssets = selectedAssetArray
        self.isOriginal = isOriginal
        loadingView = UIActivityIndicatorView(style: .medium)
        loadingView?.center = CGPoint(x: view.centerX, y: view.centerY - 100)
        loadingView?.startAnimating()
        view.addSubview(loadingView!)
        //获取视频地址
        for photoAsset in selectedAssets {
            if photoAsset.mediaType == .video {
                photoAsset.requestVideoURL { (videoURL) in
                    if videoURL != nil {
                        guard let imgPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/videoToIMG.JPG") else {return}
                        guard let videoPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/videoToVideo.MOV") else {return}
                        if self.isGIF {
                            do {
                                let outfileName = String(format: "%@_%@", ProcessInfo.processInfo.globallyUniqueString, "outfile.gif")
                                let outfileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(outfileName)

                                let startTime = CFAbsoluteTimeGetCurrent()

                                let _ = MobileFFmpeg.execute("-i \(videoURL!.path) -vf fps=20,scale=450:-1 \(outfileURL.path)")
            
                                let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
                                print("Time elapsed: \(timeElapsed) s.")

                                PHPhotoLibrary.shared().performChanges({
                                    PHAssetCreationRequest.creationRequestForAssetFromImage(atFileURL: outfileURL)
                                }) { (saved, err) in
                                    DispatchQueue.main.async {
                                        self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                                        self.hud?.mode = .text
                                        if err == nil {
                                            self.hud?.label.text = "gif保存到相册成功"
                                        }else {
                                            self.hud?.label.text = err?.localizedDescription
                                        }
                                        self.loadingView?.stopAnimating()
                                        self.loadingView?.removeFromSuperview()
                                        self.loadingView = nil
                                        self.hud?.hide(animated: true, afterDelay: 2)
                                    }
                                }
                            }
                        }else {
                            self.imgPath = imgPath
                            self.videoPath = videoPath
                            self.loadLivePhotoWithVideo(with: videoURL!, with: imgPath, with: videoPath)
                        }
                    }else {
                        self.loadingView?.stopAnimating()
                        self.loadingView?.removeFromSuperview()
                        self.loadingView = nil
                        self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                        self.hud?.mode = .text
                        self.hud?.label.text = "获取相册视频失败"
                        self.hud?.hide(animated: true, afterDelay: 2)
                    }
                }
                
            }
        }
        
       
        
    }
    func pickerController(_ pickerController: HXPHPickerController, singleFinishSelection photoAsset:HXPHAsset, _ isOriginal: Bool) {
        selectedAssets = [photoAsset]
        self.isOriginal = isOriginal
      
        //
    }
    func pickerController(didCancel pickerController: HXPHPickerController) {
        
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
//            livePhotoView.livePhoto = nil
            let asset = AVURLAsset(url: videoURL)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            let time = NSValue(time: CMTimeMakeWithSeconds(CMTimeGetSeconds(asset.duration)/2, preferredTimescale: asset.duration.timescale))
            generator.generateCGImagesAsynchronously(forTimes: [time]) { [weak self] _, image, _, _, _ in
                if let image = image, let data = UIImage(cgImage: image).pngData() {
                    try? data.write(to: URL(fileURLWithPath: imgPath), options: [.atomic])
                    let mov = videoURL.path
                    let assetIdentifier = UUID().uuidString
                    //写入到本地缓存中
                    JPEG(path: imgPath).write(imgPath, assetIdentifier: assetIdentifier)
                    QuickTimeMov(path: mov).write(videoPath, assetIdentifier: assetIdentifier)
                    //调用显示的方法
                    self?.loadLivePhoto(with: imgPath, with: videoPath)
                }
            }
        }
    }
    
    
    /// 从本地缓存的.jpg 和 .mov文件中合成一个`livePhoto`文件
    /// - Parameters:
    ///   - imgPath: 缓存的.jpg图片地址
    ///   - videoPath: 缓存的.mov视频地址
    func loadLivePhoto(with imgPath: String, with videoPath: String) {
        DispatchQueue.main.async { [self] in
            PHLivePhoto.request(withResourceFileURLs: [ URL(fileURLWithPath: imgPath), URL(fileURLWithPath: videoPath)],
                                placeholderImage: nil,
                                targetSize: CGSize(width: 100, height: 100),
                                contentMode: PHImageContentMode.aspectFit,
                                resultHandler: { (livePhoto, _) -> Void in
                                    self.exportLivePhoto()
                                })
    }
    }
    
    func exportLivePhoto () {
        PHPhotoLibrary.shared().performChanges({ () -> Void in
            let creationRequest = PHAssetCreationRequest.forAsset()
            let options = PHAssetResourceCreationOptions()
            creationRequest.addResource(with: PHAssetResourceType.pairedVideo, fileURL: URL(fileURLWithPath: self.videoPath), options: options)
            creationRequest.addResource(with: PHAssetResourceType.photo, fileURL: URL(fileURLWithPath: self.imgPath), options: options)
            }, completionHandler: { (success, error) -> Void in
                if !success {
                    ProgressHUD.showError(error?.localizedDescription)
                }else {
                    ProgressHUD.showSuccess("转换已完成！请到相册查看")
                }
        })
    }
 
}


//
//  HXPHTools.swift
//  照片选择器-Swift
//
//  Created by Silence on 2019/6/29.
//  Copyright © 2019年 Silence. All rights reserved.
//

import UIKit
import Photos

public typealias statusHandler = (PHAuthorizationStatus) -> ()

public class HXPHTools: NSObject {
    
    
    /// 显示没有权限的弹窗
    /// - Parameters:
    ///   - viewController: 需要弹窗的viewController
    ///   - status: 权限类型
    public class func showNotAuthorizedAlert(viewController : UIViewController? , status : PHAuthorizationStatus) {
        if viewController == nil {
            return
        }
        if status == .denied ||
            status == .restricted {
            showAlert(viewController: viewController, title: "无法访问相册中照片".localized, message: "当前无照片访问权限，建议前往系统设置，\n允许访问「照片」中的「所有照片」。".localized, leftActionTitle: "取消".localized, leftHandler: {_ in }, rightActionTitle: "前往系统设置".localized) { (alertAction) in
                openSettingsURL()
            }
        }
    }
    
    /// 显示没有相机权限弹窗
    public class func showNotCameraAuthorizedAlert(viewController : UIViewController?) {
        if viewController == nil {
            return
        }
        showAlert(viewController: viewController, title: "无法使用相机功能".localized, message: "请前往系统设置中，允许访问「相机」。".localized, leftActionTitle: "取消".localized, leftHandler: {_ in }, rightActionTitle: "前往系统设置".localized) { (alertAction) in
            openSettingsURL()
        }
    }
    
    /// 跳转系统设置界面
    public class func openSettingsURL() {
        if #available(iOS 10, *) {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        }
    }
    
    
    /// 显示UIAlertController
    public class func showAlert(viewController: UIViewController? , title: String? , message: String? , leftActionTitle: String ,  leftHandler: @escaping (UIAlertAction)->(), rightActionTitle: String , rightHandler: @escaping (UIAlertAction)->()) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let leftAction = UIAlertAction.init(title: leftActionTitle, style: UIAlertAction.Style.cancel, handler: leftHandler)
        let rightAction = UIAlertAction.init(title: rightActionTitle, style: UIAlertAction.Style.default, handler: rightHandler)
        alertController.addAction(leftAction)
        alertController.addAction(rightAction)
        viewController?.present(alertController, animated: true, completion: nil)
    }
    
    /// 转换视频时长为 00:00 格式的字符串
    public class func transformVideoDurationToString(duration: TimeInterval) -> String {
        let time = Int(round(Double(duration)))
        if time < 10 {
            return String.init(format: "00:0%d", arguments: [time])
        }else if time < 60 {
            return String.init(format: "00:%d", arguments: [time])
        }else {
            let min = Int(time / 60)
            let sec = time - (min * 60)
            if sec < 10 {
                return String.init(format: "%d:0%d", arguments: [min,sec])
            }else {
                return String.init(format: "%d:%d", arguments: [min,sec])
            }
        }
    }
    
    /// 转换相册名称为当前语言
    public class func transformAlbumName(for collection: PHAssetCollection) -> String? {
        if collection.assetCollectionType == .album {
            return collection.localizedTitle
        }
        var albumName : String?
        let type = HXPHManager.shared.languageType
        if type == .system {
            albumName = collection.localizedTitle
        }else {
            if collection.localizedTitle == "最近项目" ||
                collection.localizedTitle == "最近添加"  {
                albumName = "HXAlbumRecents".localized
            }else if collection.localizedTitle == "Camera Roll" ||
                        collection.localizedTitle == "相机胶卷" {
                albumName = "HXAlbumCameraRoll".localized
            }else {
                switch collection.assetCollectionSubtype {
                case .smartAlbumUserLibrary:
                    albumName = "HXAlbumCameraRoll".localized
                    break
                case .smartAlbumVideos:
                    albumName = "HXAlbumVideos".localized
                    break
                case .smartAlbumPanoramas:
                    albumName = "HXAlbumPanoramas".localized
                    break
                case .smartAlbumFavorites:
                    albumName = "HXAlbumFavorites".localized
                    break
                case .smartAlbumTimelapses:
                    albumName = "HXAlbumTimelapses".localized
                    break
                case .smartAlbumRecentlyAdded:
                    albumName = "HXAlbumRecentlyAdded".localized
                    break
                case .smartAlbumBursts:
                    albumName = "HXAlbumBursts".localized
                    break
                case .smartAlbumSlomoVideos:
                    albumName = "HXAlbumSlomoVideos".localized
                    break
                case .smartAlbumSelfPortraits:
                    albumName = "HXAlbumSelfPortraits".localized
                    break
                case .smartAlbumScreenshots:
                    albumName = "HXAlbumScreenshots".localized
                    break
                case .smartAlbumDepthEffect:
                    albumName = "HXAlbumDepthEffect".localized
                    break
                case .smartAlbumLivePhotos:
                    albumName = "HXAlbumLivePhotos".localized
                    break
                case .smartAlbumAnimated:
                    albumName = "HXAlbumAnimated".localized
                    break
                default:
                    albumName = collection.localizedTitle
                    break
                }
            }
        }
        return albumName
    }
    
    // 根据视频地址获取视频封面
    public class func getVideoThumbnailImage(videoURL: URL?, atTime: TimeInterval) -> UIImage? {
        if videoURL == nil {
            return nil
        }
        let urlAsset = AVURLAsset.init(url: videoURL!)
        let assetImageGenerator = AVAssetImageGenerator.init(asset: urlAsset)
        assetImageGenerator.appliesPreferredTrackTransform = true
        assetImageGenerator.apertureMode = .encodedPixels
        let thumbnailImageTime: CFTimeInterval = atTime
        do {
            let thumbnailImageRef = try assetImageGenerator.copyCGImage(at: CMTime(value: CMTimeValue(thumbnailImageTime), timescale: urlAsset.duration.timescale), actualTime: nil)
            let image = UIImage.init(cgImage: thumbnailImageRef)
            return image
        } catch {
            return nil
        }
    }
    
    /// 根据视频地址获取视频时长
    public class func getVideoDuration(videoURL: URL?) -> TimeInterval {
        if videoURL == nil {
            return 0
        }
        let options = [AVURLAssetPreferPreciseDurationAndTimingKey: false]
        let urlAsset = AVURLAsset.init(url: videoURL!, options: options)
        let second = Int(urlAsset.duration.value) / Int(urlAsset.duration.timescale)
        return TimeInterval(second)
    }
    
    /// 将字节转换成字符串
    public class func transformBytesToString(bytes: Int) -> String {
        if CGFloat(bytes) >= 0.5 * 1000 * 1000 {
            return String.init(format: "%0.1fM", arguments: [CGFloat(bytes) / 1000 / 1000])
        }else if bytes >= 1000 {
            return String.init(format: "%0.0fK", arguments: [CGFloat(bytes) / 1000])
        }else {
            return String.init(format: "%dB", arguments: [bytes])
        }
    }
    /// 根据PHAsset资源获取对应的目标大小
    public class func transformTargetWidthToSize(targetWidth: CGFloat, asset: PHAsset) -> CGSize {
        let scale:CGFloat = 0.8
        let aspectRatio = CGFloat(asset.pixelWidth) / CGFloat(asset.pixelHeight)
        var width = targetWidth
        if asset.pixelWidth < Int(targetWidth) {
            width *= 0.5
        }
        var height = width / aspectRatio
        let maxHeight = UIScreen.main.bounds.size.height
        if height > maxHeight {
            width = maxHeight / height * width * scale
            height = maxHeight * scale
        }
        if height < targetWidth && width >= targetWidth {
            width = targetWidth / height * width * scale
            height = targetWidth * scale
        }
        return CGSize.init(width: width, height: height)
    }
    
    /// 导出编辑视频
    /// - Parameters:
    ///   - avAsset: 视频对应的 AVAsset 数据
    ///   - startTime: 需要裁剪的开始时间
    ///   - endTime: 需要裁剪的结束时间
    ///   - presentName: 导出的质量
    ///   - completion: 导出完成
    public class func exportEditVideo(for avAsset: AVAsset, startTime: TimeInterval, endTime: TimeInterval, presentName: String, completion:@escaping (URL?, Error?) -> Void) {
        let timescale = avAsset.duration.timescale
        let start = CMTime(value: CMTimeValue(startTime * TimeInterval(timescale)), timescale: timescale)
        let end = CMTime(value: CMTimeValue(endTime * TimeInterval(timescale)), timescale: timescale)
        let timeRang = CMTimeRange(start: start, end: end)
        exportEditVideo(for: avAsset, timeRang: timeRang, presentName: presentName, completion: completion)
    }
    
    /// 导出编辑视频
    /// - Parameters:
    ///   - avAsset: 视频对应的 AVAsset 数据
    ///   - timeRang: 需要裁剪的时间区域
    ///   - presentName: 导出的质量
    ///   - completion: 导出完成
    public class func exportEditVideo(for avAsset: AVAsset, timeRang: CMTimeRange, presentName: String, completion:@escaping (URL?, Error?) -> Void) {
        if AVAssetExportSession.allExportPresets().contains(presentName) {
            let videoURL = HXPHTools.getVideoTmpURL()
            if let exportSession = AVAssetExportSession.init(asset: avAsset, presetName: presentName) {
                let supportedTypeArray = exportSession.supportedFileTypes
                exportSession.outputURL = videoURL
                if supportedTypeArray.contains(AVFileType.mp4) {
                    exportSession.outputFileType = .mp4
                }else if supportedTypeArray.isEmpty {
                    completion(nil, HXPickerError.error(message: "不支持导出该类型视频"))
                    return
                }else {
                    exportSession.outputFileType = supportedTypeArray.first
                }
                exportSession.timeRange = timeRang
                exportSession.exportAsynchronously(completionHandler: {
                    DispatchQueue.main.async {
                        switch exportSession.status {
                        case .completed:
                            completion(videoURL, nil)
                            break
                        case .failed, .cancelled:
                            completion(nil, exportSession.error)
                            break
                        default: break
                        }
                    }
                })
            }else {
                completion(nil, HXPickerError.error(message: "不支持导出该类型视频"))
                return
            }
        }else {
            completion(nil, HXPickerError.error(message: "设备不支持导出：" + presentName))
            return
        }
    }
    /// 将UIImage转换成Data
    public class func getImageData(for image: UIImage?) -> Data? {
        if let pngData = image?.pngData() {
            return pngData
        }else if let jpegData = image?.jpegData(compressionQuality: 1) {
            return jpegData
        }
        return nil
    }
    /// 获取对应后缀的临时路径
    public class func getTmpURL(for suffix: String) -> URL {
        var tmpPath = NSTemporaryDirectory()
        tmpPath.append(contentsOf: String.fileName(suffix: suffix))
        let tmpURL = URL.init(fileURLWithPath: tmpPath)
        return tmpURL
    }
    /// 获取图片临时路径
    public class func getImageTmpURL() -> URL {
        return getTmpURL(for: "jpeg")
    }
    /// 获取视频临时路径
    public class func getVideoTmpURL() -> URL {
        return getTmpURL(for: "mp4")
    }
    /// 获取和微信主题一致的配置
    public class func getWXConfig() -> HXPHConfiguration {
        let config = HXPHConfiguration.init()
        config.maximumSelectedCount = 9
        config.maximumSelectedVideoCount = 0
        config.allowSelectedTogether = true
        config.albumShowMode = .popup
        config.appearanceStyle = .normal
        config.showLivePhoto = true
        config.navigationViewBackgroundColor = "#2E2F30".color
        config.navigationTitleColor = .white
        config.navigationTintColor = .white
        config.statusBarStyle = .lightContent
        config.navigationBarStyle = .black
        
        config.albumList.backgroundColor = "#2E2F30".color
        config.albumList.cellHeight = 60
        config.albumList.cellBackgroundColor = "#2E2F30".color
        config.albumList.cellSelectedColor = UIColor.init(red: 0.125, green: 0.125, blue: 0.125, alpha: 1)
        config.albumList.albumNameColor = .white
        config.albumList.photoCountColor = .white
        config.albumList.separatorLineColor = "#434344".color.withAlphaComponent(0.6)
        config.albumList.tickColor = "#07C160".color
        
        config.photoList.backgroundColor = "#2E2F30".color
        config.photoList.cancelPosition = .left
        config.photoList.cancelType = .image
        
        config.photoList.titleViewConfig.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        config.photoList.titleViewConfig.arrowBackgroundColor = "#B2B2B2".color
        config.photoList.titleViewConfig.arrowColor = "#2E2F30".color
        
        config.photoList.cell.selectBox.selectedBackgroundColor = "#07C160".color
        config.photoList.cell.selectBox.titleColor = .white
        
        config.photoList.cameraCell.cameraImageName = "hx_picker_photoList_photograph_white"
        
        config.photoList.bottomView.barStyle = .black
        config.photoList.bottomView.previewButtonTitleColor = .white
        
        config.photoList.bottomView.originalButtonTitleColor = .white
        config.photoList.bottomView.originalSelectBox.backgroundColor = .clear
        config.photoList.bottomView.originalSelectBox.borderColor = .white
        config.photoList.bottomView.originalSelectBox.tickColor = .white
        config.photoList.bottomView.originalSelectBox.selectedBackgroundColor = "#07C160".color
        
        config.photoList.bottomView.finishButtonTitleColor = .white
        config.photoList.bottomView.finishButtonBackgroundColor = "#07C160".color
        config.photoList.bottomView.finishButtonDisableBackgroundColor = "#666666".color.withAlphaComponent(0.3)
        
        config.photoList.bottomView.promptTitleColor = UIColor.white.withAlphaComponent(0.6)
        config.photoList.bottomView.promptIconColor = "#f5a623".color
        config.photoList.bottomView.promptArrowColor = UIColor.white.withAlphaComponent(0.6)
        
        config.photoList.emptyView.titleColor = "#ffffff".color
        config.photoList.emptyView.subTitleColor = .lightGray
        
        config.previewView.cancelType = .image
        config.previewView.cancelPosition = .left
        config.previewView.backgroundColor = .black
        config.previewView.selectBox.tickColor = .white
        config.previewView.selectBox.selectedBackgroundColor = "#07C160".color
        
        config.previewView.bottomView.barStyle = .black
        config.previewView.bottomView.editButtonTitleColor = .white
        
        config.previewView.bottomView.originalButtonTitleColor = .white
        config.previewView.bottomView.originalSelectBox.backgroundColor = .clear
        config.previewView.bottomView.originalSelectBox.borderColor = .white
        config.previewView.bottomView.originalSelectBox.tickColor = .white
        config.previewView.bottomView.originalSelectBox.selectedBackgroundColor = "#07C160".color
        config.previewView.bottomView.originalLoadingStyle = .white
        
        config.previewView.bottomView.finishButtonTitleColor = .white
        config.previewView.bottomView.finishButtonBackgroundColor = "#07C160".color
        config.previewView.bottomView.finishButtonDisableBackgroundColor = "#666666".color.withAlphaComponent(0.3)
        
        config.previewView.bottomView.selectedViewTickColor = "#07C160".color
        
        config.notAuthorized.closeButtonImageName = "hx_picker_notAuthorized_close_dark"
        config.notAuthorized.backgroundColor = "#2E2F30".color
        config.notAuthorized.titleColor = .white
        config.notAuthorized.subTitleColor = .white
        config.notAuthorized.jumpButtonTitleColor = .white
        config.notAuthorized.jumpButtonBackgroundColor = "#07C160".color
        
        return config
    }
}

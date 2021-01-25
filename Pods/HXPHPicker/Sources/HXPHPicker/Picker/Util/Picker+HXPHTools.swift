//
//  Picker+HXPHTools.swift
//  HXPHPicker
//
//  Created by Slience on 2021/1/7.
//

import UIKit
import Photos

extension HXPHTools {
    
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
        return getVideoThumbnailImage(avAsset: urlAsset as AVAsset, atTime: atTime)
    }
    // 根据视频地址获取视频封面
    public class func getVideoThumbnailImage(avAsset: AVAsset?, atTime: TimeInterval) -> UIImage? {
        if avAsset == nil {
            return nil
        }
        let assetImageGenerator = AVAssetImageGenerator.init(asset: avAsset!)
        assetImageGenerator.appliesPreferredTrackTransform = true
        assetImageGenerator.apertureMode = .encodedPixels
        let thumbnailImageTime: CFTimeInterval = atTime
        do {
            let thumbnailImageRef = try assetImageGenerator.copyCGImage(at: CMTime(value: CMTimeValue(thumbnailImageTime), timescale: avAsset!.duration.timescale), actualTime: nil)
            let image = UIImage.init(cgImage: thumbnailImageRef)
            return image
        } catch {
            return nil
        }
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
    
    /// 将UIImage转换成Data
    public class func getImageData(for image: UIImage?) -> Data? {
        if let pngData = image?.pngData() {
            return pngData
        }else if let jpegData = image?.jpegData(compressionQuality: 1) {
            return jpegData
        }
        return nil
    }
    /// 获取和微信主题一致的配置
    public class func getWXPickerConfig() -> HXPHPickerConfiguration {
        let config = HXPHPickerConfiguration.init()
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
        config.photoList.bottomView.originalLoadingStyle = .white
        
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

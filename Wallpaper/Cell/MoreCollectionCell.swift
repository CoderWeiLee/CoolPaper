//
//  MoreCollectionCell.swift
//  Wallpaper
//
//  Created by 李伟 on 2020/12/28.
//
/*
 
 
 
 */
import Foundation
import UIKit
import Kingfisher
import SnapKit
import Alamofire
import AVKit
import PhotosUI
import Photos
import MobileCoreServices
import SkeletonView
class MoreCollectionCell: UICollectionViewCell {
    var imgV: UIImageView!
    var livePhotoView: PHLivePhotoView!
    var bottomView = UIView()
    var tagLabel = UILabel()
    var imgPath: String!
    var videoPath: String!
//    var saveSuccess:((_ with: PHLivePhoto,_ key: String) -> Void)?
    var type: ImgTypes? {
        didSet {
            if let t = type {
                if t.key == "Dongtai" {
                    livePhotoView.isHidden = false
                    livePhotoView.isMuted = true
                    livePhotoView.delegate = self
                    guard let imgPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/0001.JPG") else {return}
                    guard let videoPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/0001.MOV") else {return}
                    self.imgPath = imgPath
                    self.videoPath = videoPath
                    if FileManager.default.fileExists(atPath: imgPath) && FileManager.default.fileExists(atPath: videoPath) {
                        loadLivePhoto(with: imgPath, with: videoPath)
                    }else {
                        let url = baseUrl + "/\(type!.key ?? "Dongtai")/0001.mp4"
                        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        let fileURL = documentsURL.appendingPathComponent("0001.mp4")
                            //指定位置，且删除已存在的该文件
                            let dest: DownloadRequest.Destination = { _, _ in
                                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                            }
                            AF.download(url, interceptor: nil, to: dest).downloadProgress(closure: { (progress) in
                            }).responseData { (res) in
                                self.loadLivePhotoWithVideo(with: fileURL, with: imgPath, with: videoPath)
                            }
                    }
                }else {
                    livePhotoView.isHidden = true
                    imgV.kf.setImage(with: URL(string: baseUrl + "/\(t.key ?? "Daily")/0001.jpg"))
                }
            }
            imgV.kf.setImage(with: URL(string: baseUrl + "/\(type?.key ?? "Daily")/0001.jpg"))
            tagLabel.text = type!.type
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isSkeletonable = true
        imgV = UIImageView()
        imgV.frame = contentView.bounds
        imgV.layer.cornerRadius = 6
        imgV.layer.masksToBounds = true
        imgV.isSkeletonable = true
        contentView.addSubview(imgV)
        
        livePhotoView = PHLivePhotoView()
        livePhotoView.frame = contentView.bounds
        livePhotoView.layer.cornerRadius = 6
        livePhotoView.layer.masksToBounds = true
        livePhotoView.isHidden = true
        livePhotoView.isSkeletonable = true
        imgV.addSubview(livePhotoView)
        
        bottomView.backgroundColor = UIColor(white: 0.1, alpha: 0.6)
        bottomView.isSkeletonable = true
        imgV.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(imgV)
            make.height.equalTo(20)
        }
        
        tagLabel.textColor = .white
        tagLabel.isSkeletonable = true
        tagLabel.font = UIFont.systemFont(ofSize: 14)
        imgV.addSubview(tagLabel)
        tagLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imgV).offset(3)
            make.bottom.equalTo(imgV).offset(-3)
        }
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func exportLivePhoto () {
        PHPhotoLibrary.shared().performChanges({ () -> Void in
            let creationRequest = PHAssetCreationRequest.forAsset()
            let options = PHAssetResourceCreationOptions()
            creationRequest.addResource(with: PHAssetResourceType.pairedVideo, fileURL: URL(fileURLWithPath: videoPath), options: options)
            creationRequest.addResource(with: PHAssetResourceType.photo, fileURL: URL(fileURLWithPath: imgPath), options: options)
            }, completionHandler: { (success, error) -> Void in
                if !success {
                    print(error?.localizedDescription as Any)
                }
        })
    }
}
}

extension MoreCollectionCell: PHLivePhotoViewDelegate {
//    func livePhotoView(_ livePhotoView: PHLivePhotoView, willBeginPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
//
//    }
    
    func livePhotoView(_ livePhotoView: PHLivePhotoView, didEndPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
        //延迟2s执行
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            livePhotoView.startPlayback(with: .full)
        }
    }
}



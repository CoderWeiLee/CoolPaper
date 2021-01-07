//
//  CCVideoImageTool.swift
//  VideoGifToolsDemo
//
//  Created by sischen on 2019/1/13.
//  Copyright © 2019 CC. All rights reserved.
//

import UIKit
import CoreGraphics
import AVFoundation
import MobileCoreServices
import ImageIO

public class CCVideoImageTool {
    
    /// 生成预览图
    public static func createPreviewsForVideo(fileURL: URL,
                                              previewCounts: Int,
                                              completion: @escaping ([UIImage]?, Error?) -> ()) {
        let asset = AVURLAsset(url: fileURL, options: nil)
        let tol = CMTimeMakeWithSeconds(0.01, preferredTimescale: 600)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.requestedTimeToleranceBefore = tol
        generator.requestedTimeToleranceAfter = tol
        
        let videoTotalSeconds = Double(asset.duration.value) / Double(asset.duration.timescale)
        let increment = videoTotalSeconds / Double(previewCounts)
        var timePoints = [NSValue]()
        for i in 0..<previewCounts {
            let seconds = Double(i) * increment
            let cmtime = CMTimeMakeWithSeconds(seconds, preferredTimescale: 600)
            timePoints.append(NSValue(time: cmtime))
        }
        
        var resultImgs = [UIImage]()
        DispatchQueue.global().async {
            for time in timePoints {
                let imageRef = try? generator.copyCGImage(at: time.timeValue, actualTime: nil)
                
                if let imgRef = imageRef {
                    let img = UIImage(cgImage: imgRef)
                    resultImgs.append(img)
                } else {
                    resultImgs.append(UIImage())
                }
            }
            DispatchQueue.main.async {
                completion(resultImgs, nil)
            }
        }
    }
    
    /// 生成Gif图片
    ///
    /// - Parameters:
    ///   - fileURL: 本地视频文件URL
    ///   - startTime: 截取的开始时间(秒)
    ///   - duration: 截取的持续时间(秒)
    ///   - frameRate: 生成的gif每秒帧数
    ///   - completion: 完成回调
    public static func generateGIFfromVideoFileURL(_ fileURL: URL,
                                                   startTime: TimeInterval,
                                                   duration: TimeInterval = 1.0,
                                                   frameRate: Int = 20,
                                                   completion: @escaping (URL?, Error?) -> ()) {
        let asset = AVURLAsset(url: fileURL)
        guard let track = asset.tracks(withMediaType: AVMediaType.video).first else {
            completion(nil, GifCustomError("fileURL is not a video format"))
            return
        }
        let videoTotalSeconds = Double(asset.duration.value) / Double(asset.duration.timescale) // 视频总秒数
        if startTime + duration > videoTotalSeconds {
            completion(nil, GifCustomError("target time range is beyond the video length"))
            return
        }
        
        let videoWidth = track.naturalSize.width
        let videoHeight = track.naturalSize.height
        let optimalSize = GIFSize.initWith(videoWidth: videoWidth, videoHeight: videoHeight)
        
        let frameCount = Int(floor(duration * Double(frameRate))) // 截取总帧数
        let increment = Float(duration) / Float(frameCount)
        
        var timePoints = [NSValue]()
        for frameIndex in 0..<frameCount {
            let seconds = startTime + (Double(frameIndex) * Double(increment))
            let cmtime = CMTimeMakeWithSeconds(seconds, preferredTimescale: 600)
            timePoints.append(NSValue(time: cmtime))
        }
        
        let fileProperties = filePropertiesWithLoopCount(0) // 无限循环
        let frameProperties = framePropertiesWithDelayTime(increment)
        
        let gifGroup = DispatchGroup()
        gifGroup.enter()
        
        var gifURL: URL?
        DispatchQueue.global().async {
            do { try gifURL = createGIFfor(timePoints: timePoints,
                                           fromURL: fileURL,
                                           fileProperties: fileProperties,
                                           frameProperties: frameProperties,
                                           frameCount: frameCount,
                                           gifSize: optimalSize)
            } catch {
                completion(nil, error)
            }
            gifGroup.leave()
        }
        gifGroup.notify(queue: DispatchQueue.main) {
            if let url = gifURL {
                completion(url, nil)
            } else {
                completion(nil, GifCustomError("generate gif error"))
            }
        }
    }
    
    
    
    fileprivate static func createGIFfor(timePoints: [NSValue],
                                         fromURL url: URL,
                                         fileProperties: [String: Any],
                                         frameProperties: [String: Any],
                                         frameCount: Int,
                                         gifSize: GIFSize) throws -> URL {
        
        let gifFileName = String(format: "\(self)-%lu.gif", Date().timeIntervalSince1970 * 10)
        let temporaryFilePath = NSTemporaryDirectory().appending(gifFileName)
        let fileURL = URL(fileURLWithPath: temporaryFilePath)
        
        guard let destination = CGImageDestinationCreateWithURL(fileURL as CFURL, kUTTypeGIF, frameCount, nil) else {
            throw GifCustomError("create gif destination error")
        }
        CGImageDestinationSetProperties(destination, fileProperties as CFDictionary)
        
        let asset = AVURLAsset(url: url, options: nil)
        let tol = CMTimeMakeWithSeconds(0.01, preferredTimescale: 600)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.requestedTimeToleranceBefore = tol
        generator.requestedTimeToleranceAfter = tol
        
        var previousImageRefCopy: CGImage?
        for time in timePoints {
            var imageRef: CGImage?
            if gifSize.rawValue / 10 != 1 { // 有压缩
                let img = try generator.copyCGImage(at: time.timeValue, actualTime: nil)
                imageRef = img.ccCreateImageWithScale(Float(gifSize.rawValue) / 10.0)
            } else {
                imageRef = try generator.copyCGImage(at: time.timeValue, actualTime: nil)
            }
            
            if let imgRef = imageRef {
                previousImageRefCopy = imgRef.copy()
            } else if let previous = previousImageRefCopy {
                imageRef = previous.copy()
            } else {
                throw GifCustomError("generating gif copyCGImage error")
            }
            if let imgRef2 = imageRef {
                CGImageDestinationAddImage(destination, imgRef2, frameProperties as CFDictionary)
            }
        }
        
        if CGImageDestinationFinalize(destination) == false {
            throw GifCustomError("gif destination finalize error")
        }
        return fileURL
    }
    
    
    
    fileprivate static func filePropertiesWithLoopCount(_ loopCount: Int) -> [String: Any] {
        let dict = [String(kCGImagePropertyGIFLoopCount): NSNumber(value: loopCount)]
        let retdict = [String(kCGImagePropertyGIFDictionary): dict]
        return retdict
    }
    
    fileprivate static func framePropertiesWithDelayTime(_ delayTime: Float) -> [String: Any] {
        let dict = [String(kCGImagePropertyGIFDelayTime): NSNumber(value: delayTime)]
        let retdict: [String : Any] = [String(kCGImagePropertyGIFDictionary): dict,
                                       String(kCGImagePropertyColorModel): String(kCGImagePropertyColorModelRGB)]
        return retdict
    }
}


fileprivate enum GIFSize: Int {
    case veryLow    = 2
    case low        = 3
    case medium     = 5
    case high       = 7
    case original   = 10
    
    fileprivate static func initWith(videoWidth: CGFloat, videoHeight: CGFloat) -> GIFSize {
        var optimalSize = GIFSize.medium
        
        if (videoWidth >= 1200 || videoHeight >= 1200){
            optimalSize = .veryLow
        }
        else if (videoWidth >= 800 || videoHeight >= 800){
            optimalSize = .low
        }
        else if (videoWidth >= 400 || videoHeight >= 400){
            optimalSize = .medium
        }
        else if (videoWidth >= 200 || videoHeight >= 200){
            optimalSize = .high
        }
        else {
            optimalSize = .original
        }
        return optimalSize
    }
}


struct GifCustomError: LocalizedError {
    private var desc: String?
    
    var errorDescription: String? {
        return desc
    }
    
    var localizedDescription: String {
        return desc ?? ""
    }
    
    init(_ desc: String) {
        self.desc = desc
    }
}


fileprivate extension CGImage {
    
    func ccCreateImageWithScale(_ scale: Float) -> CGImage {
        var imageRef = self
        let newWidth = CGFloat(imageRef.width) * CGFloat(scale)
        let newHeight = CGFloat(imageRef.height) * CGFloat(scale)
        let newSize = CGSize(width: newWidth, height: newHeight)
        let newRect = CGRect(origin: CGPoint.zero, size: newSize).integral
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return imageRef }
        
        context.interpolationQuality = .high
        let flipVertical = __CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height)
        context.concatenate(flipVertical)
        context.draw(imageRef, in: newRect)
        if let imgRef = context.makeImage() {
            imageRef = imgRef
        }
        UIGraphicsEndImageContext()
        return imageRef
    }
}

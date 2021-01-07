//
//  HXPHAlbumViewCell.swift
//  照片选择器-Swift
//
//  Created by Silence on 2019/6/28.
//  Copyright © 2019年 Silence. All rights reserved.
//

import UIKit
import Photos

open class HXPHAlbumViewCell: UITableViewCell {
    
    /// 封面图片
    public lazy var albumCoverView: UIImageView = {
        let albumCoverView = UIImageView.init()
        albumCoverView.contentMode = .scaleAspectFill
        albumCoverView.clipsToBounds = true
        return albumCoverView
    }()
    
    /// 相册名称
    public lazy var albumNameLb: UILabel = {
        let albumNameLb = UILabel.init()
        return albumNameLb
    }()
    
    /// 相册里的照片数量
    public lazy var photoCountLb: UILabel = {
        let photoCountLb = UILabel.init()
        return photoCountLb
    }()
    
    /// 底部线
    public lazy var bottomLineView: UIView = {
        let bottomLineView = UIView.init()
        bottomLineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.15)
        return bottomLineView
    }()
    
    /// 选中时勾勾的颜色
    public lazy var tickView: HXPHAlbumTickView = {
        let tickView = HXPHAlbumTickView.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        return tickView
    }()
    
    /// 选中时的背景视图
    public lazy var selectedBgView : UIView = {
        let selectedBgView = UIView.init()
        return selectedBgView
    }()
    
    /// 配置
    public var config : HXPHAlbumListConfiguration? {
        didSet {
            albumNameLb.font = config?.albumNameFont
            photoCountLb.font = config?.photoCountFont
            configColor()
        }
    }
    
    /// 照片集合
    public var assetCollection: HXPHAssetCollection? {
        didSet {
            albumNameLb.text = assetCollection?.albumName
            photoCountLb.text = String(assetCollection!.count)
            tickView.isHidden = !(assetCollection?.isSelected ?? false)
            requestCoverImage()
        }
    }
    
    /// 请求id
    public var requestID: PHImageRequestID?
    
    open func initView() {
        contentView.addSubview(albumCoverView)
        contentView.addSubview(albumNameLb)
        contentView.addSubview(photoCountLb)
        contentView.addSubview(bottomLineView)
        contentView.addSubview(tickView)
    }
    
    /// 获取相册封面图片，重写此方法修改封面图片
    open func requestCoverImage() {
        weak var weakSelf = self
        requestID = assetCollection?.requestCoverImage(completion: { (image, assetCollection, info) in
            if assetCollection == weakSelf?.assetCollection && image != nil {
                weakSelf?.albumCoverView.image = image
                if !HXPHAssetManager.assetDownloadIsDegraded(for: info) {
                    weakSelf?.requestID = nil
                }
            }
        })
    }
    // 颜色配置，重写此方法修改颜色配置
    open func configColor() {
        let isDark = HXPHManager.shared.isDark
        albumNameLb.textColor = isDark ? config?.albumNameDarkColor : config?.albumNameColor
        photoCountLb.textColor = isDark ? config?.photoCountDarkColor : config?.photoCountColor
        bottomLineView.backgroundColor = isDark ? config?.separatorLineDarkColor : config?.separatorLineColor
        tickView.tickLayer.strokeColor = isDark ? config?.tickDarkColor.cgColor : config?.tickColor.cgColor
        backgroundColor = isDark ? config?.cellbackgroundDarkColor : config?.cellBackgroundColor
        if isDark {
            selectedBgView.backgroundColor = config?.cellSelectedDarkColor
            selectedBackgroundView = selectedBgView
        }else {
            if config?.cellSelectedColor != nil {
                selectedBgView.backgroundColor = config?.cellSelectedColor
                selectedBackgroundView = selectedBgView
            }else {
                selectedBackgroundView = nil
            }
        }
    }
    /// 布局，重写此方法修改布局
    open func layoutView() {
        let coverMargin : CGFloat = 5
        let coverWidth = height - (coverMargin * 2)
        albumCoverView.frame = CGRect(x: coverMargin, y: coverMargin, width: coverWidth, height: coverWidth)
        
        tickView.x = width - 12 - tickView.width - UIDevice.current.rightMargin
        tickView.centerY = height * 0.5
        
        albumNameLb.x = albumCoverView.frame.maxX + 10
        albumNameLb.size = CGSize(width: tickView.x - albumNameLb.x - 20, height: 16)
        albumNameLb.centerY = height / CGFloat(2) - albumNameLb.height / CGFloat(2)
        
        photoCountLb.x = albumCoverView.frame.maxX + 10
        photoCountLb.y = albumNameLb.frame.maxY + 5
        photoCountLb.size = CGSize(width: width - photoCountLb.x - 20, height: 14)
        
        bottomLineView.frame = CGRect(x: coverMargin, y: height - 0.5, width: width - coverMargin * 2, height: 0.5)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutView()
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                configColor()
            }
        }
    }
    
    public func cancelRequest() {
        if requestID != nil {
            PHImageManager.default().cancelImageRequest(requestID!)
            requestID = nil
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

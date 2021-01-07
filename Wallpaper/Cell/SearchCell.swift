//
//  SearchCell.swift
//  Wallpaper
//
//  Created by 李伟 on 2020/12/29.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher
class SearchCell: UICollectionViewCell {
    var imgV = UIImageView()
    var contents: String? {
        didSet {
            imgV.kf.setImage(with: URL(string: baseUrl + contents!))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imgV.frame = contentView.bounds
        imgV.layer.cornerRadius = 6
        imgV.layer.masksToBounds = true
        contentView.addSubview(imgV)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

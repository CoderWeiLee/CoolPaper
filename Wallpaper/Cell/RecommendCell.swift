//
//  RecommendCell.swift
//  Wallpaper
//
//  Created by 李伟 on 2020/12/29.
//

import Foundation
import UIKit
import SnapKit
class RecommendCell: UICollectionViewCell {
    var titleLabel = UILabel()
    var title: String? {
        didSet {
            if let content = title {
                titleLabel.text = content
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.textColor = UIColor(named: "indicatorColor")
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(contentView)
        }
        layer.cornerRadius = 12
        layer.masksToBounds = true
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(white: 0.1, alpha: 0.7).cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

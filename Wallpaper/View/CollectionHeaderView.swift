//
//  CollectionHeaderView.swift
//  Wallpaper
//
//  Created by 李伟 on 2020/12/29.
//

import Foundation
import UIKit
import SnapKit
class CollectionHeaderView: UICollectionReusableView {
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
        titleLabel.textColor = .lightGray
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(4)
            make.centerY.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

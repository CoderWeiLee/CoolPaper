//
//  MyCell.swift
//  Wallpaper
//
//  Created by 李伟 on 2020/12/27.
//

import Foundation
import UIKit
import SnapKit
class MyCell: UITableViewCell {
    let imgV = UIImageView()
    let titleLabel = UILabel()
    let detailLabel = UILabel()
    let line = UIView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(imgV)
        imgV.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(20)
            make.width.height.equalTo(30)
        }
        
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textColor = UIColor(named: "segmentSelectedTitleColor")
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imgV.snp.right).offset(20)
            make.centerY.equalTo(contentView)
        }
        
        detailLabel.font = UIFont.systemFont(ofSize: 10)
        detailLabel.textColor = UIColor(named: "segmentSelectedTitleColor")
        contentView.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-20)
            make.centerY.equalTo(contentView)
        }
        
        line.backgroundColor = UIColor(white: 0, alpha: 0.1)
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.bottom.equalTo(contentView)
            make.right.equalTo(contentView)
            make.height.equalTo(0.5)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

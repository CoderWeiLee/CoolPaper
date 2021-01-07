//
//  DiscoverCell.swift
//  Wallpaper
//
//  Created by 李伟 on 2021/1/5.
//

import Foundation
import UIKit
import SnapKit
let discoverW = (kScreenW - 6) / 3
class DiscoverCell: UITableViewCell {
    
    /// 头像
    var iconImageView: UIImageView!
    /// 昵称
    var nickNameLabel: UILabel!
    /// 时间
    var timeLabel: UILabel!
    /// 更多
    var moreBtn: UIButton!
    /// 文本内容
    var contentsLabel: UILabel!
    /// 九张图
    var img1: UIImageView!
    var img2: UIImageView!
    var img3: UIImageView!
    var img4: UIImageView!
    var img5: UIImageView!
    var img6: UIImageView!
    var img7: UIImageView!
    var img8: UIImageView!
    var img9: UIImageView!
    var tagLabel: UILabel!
    var likeBtn: UIButton!
    var commentBtn: UIButton!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        iconImageView = UIImageView()
        iconImageView.layer.cornerRadius = 30
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.layer.masksToBounds = true
        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(60)
            make.left.equalTo(contentView).offset(20)
            make.top.equalTo(contentView).offset(20)
        }
        
        nickNameLabel = UILabel()
        nickNameLabel.font = UIFont.systemFont(ofSize: 14)
        nickNameLabel.textColor = UIColor(named: "segmentSelectedTitleColor")
        contentView.addSubview(nickNameLabel)
        nickNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.top.equalTo(iconImageView.snp.top).offset(15)
        }
        
        timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = UIColor.lightGray
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nickNameLabel)
            make.top.equalTo(nickNameLabel.snp.bottom).offset(10)
        }
        
        moreBtn = UIButton(type: .custom)
        moreBtn.setTitle("···", for: .normal)
        moreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .init(rawValue: 10))
        moreBtn.setTitleColor(UIColor.darkGray, for: .normal)
        moreBtn.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        contentView.addSubview(moreBtn)
        moreBtn.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-30)
            make.bottom.equalTo(timeLabel).offset(-5)
        }
        
        contentsLabel = UILabel()
        contentsLabel.numberOfLines = 0
        contentsLabel.textColor = UIColor(named: "segmentSelectedTitleColor")
        contentsLabel.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(contentsLabel)
        contentsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView)
            make.right.equalTo(contentView).offset(-20)
            make.top.equalTo(iconImageView.snp.bottom).offset(5)
        }
        
        img1 = UIImageView()
        img1.contentMode = .scaleAspectFill
        img1.layer.masksToBounds = true
        contentView.addSubview(img1)
        img1.snp.makeConstraints { (make) in
            make.width.height.equalTo(discoverW)
            make.left.equalTo(contentView)
            make.top.equalTo(contentsLabel.snp.bottom).offset(13)
        }
        
        img2 = UIImageView()
        img2.contentMode = .scaleAspectFill
        img2.layer.masksToBounds = true
        contentView.addSubview(img2)
        img2.snp.makeConstraints { (make) in
            make.width.height.equalTo(discoverW)
            make.left.equalTo(img1.snp.right).offset(3)
            make.top.equalTo(img1)
        }
        
        img3 = UIImageView()
        img3.contentMode = .scaleAspectFill
        img3.layer.masksToBounds = true
        contentView.addSubview(img3)
        img3.snp.makeConstraints { (make) in
            make.width.height.equalTo(discoverW)
            make.left.equalTo(img2.snp.right).offset(3)
            make.top.equalTo(img1)
        }
        
        img4 = UIImageView()
        img4.contentMode = .scaleAspectFill
        img4.layer.masksToBounds = true
        contentView.addSubview(img4)
        img4.snp.makeConstraints { (make) in
            make.width.height.equalTo(discoverW)
            make.left.equalTo(contentView)
            make.top.equalTo(img1.snp.bottom).offset(3)
        }
        
        img5 = UIImageView()
        img5.contentMode = .scaleAspectFill
        img5.layer.masksToBounds = true
        contentView.addSubview(img5)
        img5.snp.makeConstraints { (make) in
            make.width.height.equalTo(discoverW)
            make.left.equalTo(img4.snp.right).offset(3)
            make.top.equalTo(img4)
        }
        
        img6 = UIImageView()
        img6.contentMode = .scaleAspectFill
        img6.layer.masksToBounds = true
        contentView.addSubview(img6)
        img6.snp.makeConstraints { (make) in
            make.width.height.equalTo(discoverW)
            make.left.equalTo(img5.snp.right).offset(3)
            make.top.equalTo(img4)
        }
        
        img7 = UIImageView()
        img7.contentMode = .scaleAspectFill
        img7.layer.masksToBounds = true
        contentView.addSubview(img7)
        img7.snp.makeConstraints { (make) in
            make.width.height.equalTo(discoverW)
            make.left.equalTo(contentView)
            make.top.equalTo(img4.snp.bottom).offset(3)
        }
        
        img8 = UIImageView()
        img8.contentMode = .scaleAspectFill
        img8.layer.masksToBounds = true
        contentView.addSubview(img8)
        img8.snp.makeConstraints { (make) in
            make.width.height.equalTo(discoverW)
            make.left.equalTo(img7.snp.right).offset(3)
            make.top.equalTo(img7)
        }
        
        img9 = UIImageView()
        img9.contentMode = .scaleAspectFill
        img9.layer.masksToBounds = true
        contentView.addSubview(img9)
        img9.snp.makeConstraints { (make) in
            make.width.height.equalTo(discoverW)
            make.left.equalTo(img8.snp.right).offset(3)
            make.top.equalTo(img7)
        }
        
        tagLabel = UILabel()
        tagLabel.font = UIFont.systemFont(ofSize: 14)
        tagLabel.textColor = UIColor(named: "segmentSelectedTitleColor")
        contentView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(20)
            make.top.equalTo(img9.snp.bottom).offset(10)
        }
        
        likeBtn = UIButton(type: .custom)
        likeBtn.tintColor = UIColor.darkGray
        likeBtn.setImage(UIImage(named: "ic_home_like_before"), for: .normal)
        likeBtn.setImage(UIImage(named: "ic_home_like_after"), for: .selected)
        likeBtn.setTitle("300", for: .normal)
        likeBtn.setTitle("301", for: .selected)
        likeBtn.setTitleColor(.black, for: .normal)
        likeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        likeBtn.addTarget(self, action: #selector(likeAction), for: .touchUpInside)
        contentView.addSubview(likeBtn)
        likeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(30)
            make.top.equalTo(tagLabel.snp.bottom).offset(10)
            make.width.height.equalTo(30)
        }
        
        commentBtn = UIButton(type: .custom)
        commentBtn.tintColor = UIColor.darkGray
        commentBtn.setImage(UIImage(named: "icon_home_comment"), for: .normal)
        likeBtn.setTitle("0", for: .normal)
        likeBtn.setTitleColor(.lightGray, for: .normal)
        likeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(commentBtn)
        commentBtn.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-50)
            make.centerY.equalTo(likeBtn)
            make.width.height.equalTo(30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func moreAction() {
        
    }
    
    @objc func likeAction() {
        likeBtn.isSelected = !likeBtn.isSelected
    }
}

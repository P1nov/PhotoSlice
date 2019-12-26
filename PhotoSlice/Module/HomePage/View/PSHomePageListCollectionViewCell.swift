//
//  PSHomePageListCollectionViewCell.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2019/12/25.
//  Copyright © 2019 leiyonglin. All rights reserved.
//

import UIKit

class PSHomePageListCollectionViewCell: UICollectionViewCell {
    
    lazy var avatarImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "default_avatar")
        imageView.layer.cornerRadius = Scale(15)
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x333333)
        label.font = UIFont.systemFont(ofSize: 10.0, weight: .medium)
        
        return label
    }()
    
    lazy var browseNumberLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x999999)
        label.font = UIFont.systemFont(ofSize: 10.0)
        
        return label
    }()
    
    lazy var operateButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(named: "more_icon"), for: .normal)
        
        return button
    }()
    
    lazy var imageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Christmas")
        
        return imageView
    }()
    
    lazy var experienceButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("体验", for: .normal)
        button.clipsToBounds = true
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(browseNumberLabel)
        contentView.addSubview(operateButton)
        contentView.addSubview(imageView)
        contentView.addSubview(experienceButton)
        
        avatarImageView.snp.makeConstraints { (make) in
            
            make.left.top.equalToSuperview().offset(Scale(15))
            make.width.height.equalTo(Scale(30))
        }
        
        nameLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(avatarImageView)
            make.left.equalTo(avatarImageView.snp_right).offset(Scale(10))
        }
        
        browseNumberLabel.snp.makeConstraints { (make) in
            
            make.bottom.equalTo(avatarImageView)
            make.left.equalTo(nameLabel)
        }
        
        operateButton.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(avatarImageView)
            make.right.equalToSuperview().offset(-Scale(15))
        }
        
        imageView.snp.makeConstraints { (make) in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarImageView.snp_bottom).offset(Scale(8))
            make.width.equalTo(Scale(315))
            make.height.equalTo(Scale(150))
        }
        
        experienceButton.snp.makeConstraints { (make) in
            
            make.right.equalToSuperview().offset(-Scale(15))
            make.top.equalTo(imageView.snp_bottom).offset(Scale(5))
            make.width.equalTo(Scale(70))
            make.height.equalTo(Scale(40))
            make.bottom.equalToSuperview().offset(-Scale(15))
        }
        
        self.layoutIfNeeded()
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor(rgb: 0x336699).cgColor, UIColor(rgb: 0x3399ff).cgColor]
        gradientLayer.startPoint = .init(x: 0, y: 0.5)
        gradientLayer.endPoint = .init(x: 1, y: 0.5)
        gradientLayer.frame = experienceButton.bounds
        gradientLayer.cornerRadius = Scale(5)
        gradientLayer.locations = [0.0, 0.7]
        
        experienceButton.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

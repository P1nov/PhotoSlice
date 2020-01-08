//
//  PSImageFilterCollectionViewCell.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2020/1/7.
//  Copyright © 2020 leiyonglin. All rights reserved.
//

import UIKit

class PSImageFilterCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Scale(20)
        imageView.image = UIImage(named: "fiter_default")
        
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        label.textColor = .white
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        imageView.snp.makeConstraints { (make) in
            
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-Scale(10))
            make.width.height.equalTo(Scale(40))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp_bottom).offset(Scale(5))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

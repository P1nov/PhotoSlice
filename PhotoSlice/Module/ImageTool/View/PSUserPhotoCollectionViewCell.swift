//
//  PSUserPhotoCollectionViewCell.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2019/12/26.
//  Copyright © 2019 leiyonglin. All rights reserved.
//

import UIKit

class PSUserPhotoCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        
        let imageView = UIImageView()
        
        return imageView
    }()
    
    lazy var selectBtn: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(named: "image_unselect"), for: .normal)
        button.setImage(UIImage(named: "image_select"), for: .selected)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(selectBtn)
        
        imageView.snp.makeConstraints { (make) in
            
            make.center.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        
        selectBtn.snp.makeConstraints { (make) in
            
            make.top.equalToSuperview().offset(Scale(10))
            make.right.equalToSuperview().offset(-Scale(10))
            make.width.height.equalTo(Scale(30))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

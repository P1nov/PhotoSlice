//
//  PSLongImageSliceCompleteCollectionViewCell.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2019/12/27.
//  Copyright © 2019 leiyonglin. All rights reserved.
//

import UIKit

class PSLongImageSliceCompleteCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
           
           let imageView = UIImageView()
           
           return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        
        
        imageView.snp.makeConstraints { (make) in
            
            make.center.equalToSuperview()
            make.width.equalTo(Scale(345))
            make.bottom.equalToSuperview().offset(-Scale(5))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

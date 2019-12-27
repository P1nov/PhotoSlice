//
//  PSLongImageSliceCollectionViewCell.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2019/12/26.
//  Copyright © 2019 leiyonglin. All rights reserved.
//

import UIKit


class PSLongImageSliceCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        
        let imageView = UIImageView()
        
        return imageView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    var image : UIImage? {
        
        get {
            
            return _image
        }
        set(newImage) {
            
            guard let image = newImage else {
                
                return
            }
            
            _image = image
            self.scrollView.contentSize = image.size
            
            self.scrollView.snp.remakeConstraints { (make) in
                
                make.centerY.equalToSuperview()
                make.left.equalTo(deleteButton.snp_right).offset(Scale(20))
                make.width.equalTo(Scale(290))
                make.height.equalTo(image.size.height)
                make.bottom.equalToSuperview().offset(-Scale(5))
            }
        }
    }
    
    var _image : UIImage?
    
    lazy var deleteButton: UIButton = {
        
        let button = UIButton()
        
        button.setImage(UIImage(named: "delete_icon"), for: .normal)
        button.backgroundColor = UIColor(rgb: 0xFF4B32)
        
        button.clipsToBounds = true
        button.layer.cornerRadius = Scale(15)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(deleteButton)
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        deleteButton.snp.makeConstraints { (make) in
            
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Scale(20))
            make.width.height.equalTo(Scale(30))
        }
        
        scrollView.snp.makeConstraints { (make) in
            
            make.centerY.equalToSuperview()
            make.left.equalTo(deleteButton.snp_right).offset(Scale(20))
            make.width.equalTo(Scale(290))
            make.bottom.equalToSuperview().offset(-Scale(5))
        }
        
        imageView.snp.makeConstraints { (make) in
            
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

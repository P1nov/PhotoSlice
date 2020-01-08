//
//  PSImageEditToolBar.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2020/1/7.
//  Copyright © 2020 leiyonglin. All rights reserved.
//

import UIKit

@objc protocol PSImageEditDelegate {
    
    @objc optional func filterEdit()
    
    @objc optional func colorClamp()
    
    @objc optional func colorControl()
    
    @objc optional func intoImage()
}

class PSImageEditToolBar: UIView {
    
    weak var editDelegate : PSImageEditDelegate?

    lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "fiter_icon"), for: .normal)
        button.addTarget(self, action: #selector(filterEditClick), for: .touchUpInside)
        
        return button
    }()
    
    lazy var filterBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "fiter_icon"), for: .normal)
        button.addTarget(self, action: #selector(colorClampClick), for: .touchUpInside)
        
        return button
    }()
    
    lazy var filterControlBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "fiter_icon"), for: .normal)
        button.addTarget(self, action: #selector(colorControlClick), for: .touchUpInside)
        
        return button
    }()
    
    lazy var intoBtn : UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(named: "fiter_icon"), for: .normal)
        button.addTarget(self, action: #selector(intoBtnClick), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(filterButton)
        addSubview(filterBtn)
        addSubview(filterControlBtn)
        addSubview(intoBtn)
        
        filterButton.snp.makeConstraints { (make) in
            
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-Scale(20))
            make.width.height.equalTo(Scale(30))
        }
        
        filterBtn.snp.makeConstraints { (make) in
            
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Scale(20))
            make.width.height.equalTo(Scale(30))
        }
        
        filterControlBtn.snp.makeConstraints { (make) in
            
            make.centerY.equalToSuperview()
            make.left.equalTo(filterBtn.snp_right).offset(Scale(20))
            make.width.height.equalTo(Scale(30))
        }
        
        intoBtn.snp.makeConstraints { (make) in
            
            make.centerY.equalToSuperview()
            make.left.equalTo(filterControlBtn.snp_right).offset(Scale(20))
            make.width.height.equalTo(Scale(30))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

@objc
private extension PSImageEditToolBar {
    
    func filterEditClick() {
        
        self.editDelegate?.filterEdit?()
    }
    
    func colorClampClick() {
        
        self.editDelegate?.colorClamp?()
    }
    
    func colorControlClick() {
        
        self.editDelegate?.colorControl?()
    }
    
    func intoBtnClick() {
        
        self.editDelegate?.intoImage?()
    }
}

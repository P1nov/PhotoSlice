//
//  PSOperationContentView.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2019/12/27.
//  Copyright © 2019 leiyonglin. All rights reserved.
//

import UIKit

class PSOperationContentView: UIView {
    
    lazy var deleteButton: UIButton = {
        
        let button = UIButton()
        
        button.setImage(UIImage(named: "delete_icon"), for: .normal)
        
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(rgb: 0xFF4B32)
        
        addSubview(deleteButton)
        
        deleteButton.snp.makeConstraints { (make) in
            
            make.center.equalToSuperview()
            make.width.height.equalTo(Scale(30))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

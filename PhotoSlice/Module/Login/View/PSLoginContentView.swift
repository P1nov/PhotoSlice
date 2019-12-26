//
//  PSLoginContentView.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2019/12/25.
//  Copyright © 2019 leiyonglin. All rights reserved.
//

import UIKit
import SnapKit

class PSLoginContentView: UIView {
    
    lazy var tipLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        label.text = "您好！\n欢迎来到PhotoSlice"
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var mobileTextField: UITextField = {
        
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString.init(string: "请输入手机号", attributes: [NSAttributedString.Key.foregroundColor : UIColor(rgb: 0x666666), NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12.0, weight: .regular)])
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        
        let button = UIButton()
        button.setTitleColor(UIColor(rgb: 0xbbbbbb), for: .normal)
        button.backgroundColor = UIColor(rgb: 0xeeeeee)
        button.setTitle("立即登录", for: .normal)
        button.layer.cornerRadius = Scale(20)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor(rgb: 0xF1F2F4)
        
        addSubview(tipLabel)
        addSubview(mobileTextField)
        addSubview(lineView)
        addSubview(loginButton)
        
        tipLabel.snp.makeConstraints { (make) in
            
            make.left.equalToSuperview().offset(Scale(30))
            make.top.equalToSuperview().offset(Scale(60))
        }
        
        mobileTextField.snp.makeConstraints { (make) in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(tipLabel.snp_bottom).offset(Scale(40))
            make.width.equalTo(Scale(315))
            make.height.equalTo(Scale(40))
        }
        
        lineView.snp.makeConstraints { (make) in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(mobileTextField.snp_bottom)
            make.width.equalTo(mobileTextField)
            make.height.equalTo(Scale(0.5))
        }
        
        loginButton.snp.makeConstraints { (make) in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(mobileTextField.snp_bottom).offset(Scale(30))
            make.width.equalTo(Scale(315))
            make.height.equalTo(Scale(40))
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

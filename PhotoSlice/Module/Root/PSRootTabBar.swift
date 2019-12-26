//
//  PSRootTabBar.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2019/12/25.
//  Copyright © 2019 leiyonglin. All rights reserved.
//

import UIKit

protocol PSRootTabBarDelegate : NSObjectProtocol {
    
    func addButtonClick(button : UIButton)
}

class PSRootTabBar: UITabBar {
    
    weak var addDelegate: PSRootTabBarDelegate?
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "add_new"), for: .normal)
        
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addButton.addTarget(self, action: #selector(PSRootTabBar.addButtonClick), for: .touchUpInside)
        self.addSubview(addButton)
//      tabbar设置背景色
//      self.shadowImage = UIImage()
        self.backgroundImage = UIImage.image(with: .white)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func addButtonClick() {
        
        addDelegate?.addButtonClick(button: addButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonX = self.frame.size.width / 5.0
        
        var currentIndex = 0
        
        for barButton in subviews {
            
            if barButton.isKind(of: NSClassFromString("UITabBarButton")!) {
                
                if currentIndex == 2 {
                    
                    addButton.frame.size = CGSize.init(width: (addButton.currentImage?.size.width)!, height: (addButton.currentImage?.size.height)!)
                    addButton.center = CGPoint.init(x: self.center.x, y: self.frame.size.height / 2 - 18)
                    
                    currentIndex += 1
                }
                
                barButton.frame = CGRect.init(x: buttonX * CGFloat(currentIndex), y: 0, width: buttonX, height: self.frame.size.height)
                currentIndex += 1
                
            }
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if self.isHidden {
            
            return super.hitTest(point, with: event)
        }else {
            
            let onButton = self.convert(point, to: addButton)
            
            if addButton.point(inside: onButton, with: event) {
                
                return addButton
            }else {
                
                return super.hitTest(point, with: event)
            }
        }
    }
}

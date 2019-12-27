//
//  UINavigationBar+Extension.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2019/12/25.
//  Copyright © 2019 leiyonglin. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    func set(backgroundColor : UIColor, tintColor : UIColor, isShowShadow : Bool) {
        
        self.setBackgroundImage(UIImage.image(with: backgroundColor), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        self.tintColor = tintColor
        
        if !isShowShadow {
            
            self.shadowImage = UIImage.init()
        }
    }
}

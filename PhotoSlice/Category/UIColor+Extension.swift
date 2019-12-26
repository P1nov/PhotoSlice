//
//  UIColor+Extension.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2019/12/25.
//  Copyright © 2019 leiyonglin. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(rgb : Int32, alpha : CGFloat) {
        
        let r = CGFloat(((rgb & 0xFF0000) >> 16)) / 255.0
        let g = CGFloat(((rgb & 0xFF00) >> 8)) / 255.0
        let b = CGFloat((rgb & 0xFF)) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    convenience init(rgb : Int32) {
        
        self.init(rgb : rgb, alpha : 1.0)
    }
}

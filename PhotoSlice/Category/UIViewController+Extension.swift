//
//  UIViewController+Extension.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2019/12/25.
//  Copyright © 2019 leiyonglin. All rights reserved.
//

import UIKit

extension UIViewController {
    
    class func current(base : UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            
            return current(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            
            return current(base: tab.selectedViewController)
        }
        
        if let presented = base?.presentedViewController {
            
            return current(base: presented)
        }
        
        return base
    }
}

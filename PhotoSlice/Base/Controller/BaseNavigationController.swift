//
//  BaseNavigationController.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2019/12/27.
//  Copyright © 2019 leiyonglin. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return self.topViewController != nil ? self.topViewController!.preferredStatusBarStyle : .lightContent
    }
    
    override var childForStatusBarStyle: UIViewController? {
        
        return self.topViewController
    }

}

extension BaseNavigationController : UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if self.viewControllers.count > 1 {
            
            return true
        }
        
        return false
    }
}

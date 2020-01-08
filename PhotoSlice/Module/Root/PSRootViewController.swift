//
//  PSRootViewController.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2019/12/25.
//  Copyright © 2019 leiyonglin. All rights reserved.
//

import UIKit

class PSRootViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tabbar : PSRootTabBar = PSRootTabBar()
        tabbar.addDelegate = self
        
        self.setValue(tabbar, forKey: "tabBar")
        
        loadMainModule()
    }

}

extension PSRootViewController {
    
    func loadMainModule() {
        
        if self.viewControllers?.count != 0 {
            
            self.viewControllers?.removeAll()
        }
        
        self.tabBar.isHidden = false
        
        let homeController = PSHomePageViewController()
        let homeNav = BaseNavigationController.init(rootViewController: homeController)
        homeNav.tabBarItem = UITabBarItem.init(title: "", image: UIImage(named: "home_unselected"), selectedImage: UIImage(named: "home_selected"))
        
        let homeController1 = PSHomePageViewController()
        let homeNav1 = BaseNavigationController.init(rootViewController: homeController1)
        homeNav1.tabBarItem = UITabBarItem.init(title: "", image: UIImage(named: "safari_unselected"), selectedImage: UIImage(named: "safari_selected"))
        
        let homeController2 = PSHomePageViewController()
        let homeNav2 = BaseNavigationController.init(rootViewController: homeController2)
        homeNav2.tabBarItem = UITabBarItem.init(title: "", image: UIImage(named: "prize_unselected"), selectedImage: UIImage(named: "prize_selected"))
        
        let homeController3 = PSHomePageViewController()
        let homeNav3 = BaseNavigationController.init(rootViewController: homeController3)
        homeNav3.tabBarItem = UITabBarItem.init(title: "", image: UIImage(named: "mine_unselected"), selectedImage: UIImage(named: "mine_selected"))
        
        self.viewControllers = [homeNav, homeNav1, homeNav2, homeNav3]
        
    }
}

extension PSRootViewController : PSRootTabBarDelegate, PSOperationViewDelegate {
    
    func addButtonClick(button: UIButton) {
        
        let currentView = UIViewController.current()?.view
        
        let view : PSOperationView = PSOperationView.init(frame: currentView!.bounds)
        view.operationViewDelegate = self

        view.present(at: currentView!)
    }
    
    func longImageSlice(operationView: PSOperationView) {
        
        operationView.dismiss()
        
        let controller = LongImageSliceViewController()
        let nav = BaseNavigationController.init(rootViewController: controller)
        
        self.present(nav, animated: true, completion: nil)
    }
    
    func cameraClick(operationView: PSOperationView) {
        
        operationView.dismiss()
        
        let controller = PSUserCameraViewController()
        let nav = BaseNavigationController.init(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        
        self.present(nav, animated: true, completion: nil)
    }
}

extension NSObject {
    
    func jumpLoginViewController() {
        
        let controller = UIViewController.current()
        
        let loginViewController = PSLoginViewController()
        
        let nav = BaseNavigationController.init(rootViewController: loginViewController)
        
        controller?.present(nav, animated: true, completion: nil)
    }
}

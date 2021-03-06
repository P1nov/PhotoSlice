//
//  PSUserCameraViewController.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2020/1/6.
//  Copyright © 2020 leiyonglin. All rights reserved.
//

import UIKit

class PSUserCameraViewController: BaseViewController {

    //MARK: lazyLoad
    lazy var cameraView: PSCameraView = {
        
        let cameraView = PSCameraView.init(frame: self.view.bounds)
        cameraView.cameraDelegate = self
        
        return cameraView
    }()
    
    
    //MARK: lifeCycle
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.cameraView.session?.stopRunning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.set(backgroundColor: .clear, tintColor: .white, isShowShadow: false)
        
        self.view.addSubview(self.cameraView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "fiter_icon"), style: .plain, target: self, action: #selector(didSelectFilter))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "关闭", style: .plain, target: self, action: #selector(dismissCurrent))
        
    }
    
    //MARK: UISet
    override func configUISet() {
        super.configUISet()
        
    }
    
    //MARK: delegate & dataSource
    
    //MARK: notification & observer
    override func addNotificationObserver() {
        super.addNotificationObserver()
        
        
        
    }
    
    //MARK: action
    
    //MARK: dealloc
    deinit {
        removeNotificationObserver()
    }

}

extension PSUserCameraViewController : PSCameraDelegate {
    
    func cameraShot(with image: UIImage, cameraView: PSCameraView) {
        
        DispatchQueue.main.async {
            
            let image = PSImageHandleManager.shared.getAspectFillWidthImage(image1: image, width: UIScreen.main.bounds.width * 0.8)
            
            let controller = PSImageShotViewController(originalImage: image)
//            controller.imageView.image = image
            controller.originalImage = image
            
            let nav = UINavigationController.init(rootViewController: controller)
            
            self.popUpPresentViewController(viewController: nav, completion: nil)
        }
    }
    
    @objc private func didSelectFilter() {
        
//        let controller = PSImageFilterViewController { (filter) in
//
//            self.cameraView.filter = filter
//        }
//
//        let nav = UINavigationController.init(rootViewController: controller)
//
//        self.customPresent(viewController: nav)
        
        cameraView.presentColorControlView()
        
    }
    
    @objc private func dismissCurrent() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

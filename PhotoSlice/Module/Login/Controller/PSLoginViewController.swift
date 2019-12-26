//
//  PSLoginViewController.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2019/12/25.
//  Copyright © 2019 leiyonglin. All rights reserved.
//

import UIKit

class PSLoginViewController: BaseViewController {
    
    //MARK: lazyLoad
    
    lazy var contentView: PSLoginContentView = {
        
        let contentView = PSLoginContentView.init(frame: self.view.bounds)
        
        return contentView
    }()
    
    //MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: UISet
    override func configUISet() {
        super.configUISet()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "close_icon"), style: .plain, target: self, action: #selector(dismissCurrentController))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "密码登陆", style: .plain, target: self, action: #selector(gotoPasswordLogin))
        
        self.view.addSubview(contentView)
    }
    
    //MARK: delegate & dataSource
    
    //MARK: notification & observer
    override func addNotificationObserver() {
        super.addNotificationObserver()
        
    }
    
    override func removeNotificationObserver() {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: action
    @objc private func dismissCurrentController() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func gotoPasswordLogin() {
        
        
    }
    
    //MARK: dealloc
    deinit {
        removeNotificationObserver()
    }

}

extension PSLoginViewController {
    
    
}

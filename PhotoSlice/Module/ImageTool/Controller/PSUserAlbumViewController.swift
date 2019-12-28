//
//  PSUserAlbumViewController.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2019/12/26.
//  Copyright © 2019 leiyonglin. All rights reserved.
//

import UIKit
import Photos

class PSUserAlbumViewController: BaseTableViewController {
    
    var userAlbums : PHFetchResult<PHAssetCollection>?

    //MARK: lazyLoad
    
    
    //MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    //MARK: UISet
    override func configUISet() {
        super.configUISet()
        
//        if PSImageHandleManager.isAuthorized() {
//            
//            userAlbums = PSImageHandleManager.shared.getAllUserAlbum().1
//            tableView.reloadData()
//        }
        
        self.setNavTitle(string: "相册选择", font: nil)
        
    }
    
    //MARK: delegate & dataSource
    
    //MARK: notification & observer
    override func addNotificationObserver() {
        
        
    }
    
    //MARK: action
    
    //MARK: dealloc
    deinit {
        removeNotificationObserver()
    }

}

extension PSUserAlbumViewController {
 
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        userAlbums?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableViewCellIdentifier, for: indexPath)
        
        cell.textLabel?.text = userAlbums?.object(at: indexPath.row).localizedLocationNames.first ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        Scale(40)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = PSUserPhotosViewController()
        controller.album = userAlbums?.object(at: indexPath.row)
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

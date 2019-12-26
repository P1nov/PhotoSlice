//
//  PSImageHandleManager.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2019/12/26.
//  Copyright © 2019 leiyonglin. All rights reserved.
//

import UIKit
import Photos

class PSImageHandleManager: NSObject {
    
    private var groups : [Any] = []
    private var photos : [Any] = []

    static let shared : PSImageHandleManager = {
       
        let shared = PSImageHandleManager()
        
        return shared
    }()
    
    //判断是否授权
    class func isAuthorized() -> Bool {
        
        return PHPhotoLibrary.authorizationStatus() == .authorized ||
            PHPhotoLibrary.authorizationStatus() == .notDetermined
    }
    
    func getAllUserAlbum() -> (PHFetchResult<PHAsset>, PHFetchResult<PHAssetCollection>, PHFetchResult<PHCollection>) {
        
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        // 获取所有照片
        let allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        // 获取智能相册
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        // 获取用户创建的所有相册
        let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        
        return (allPhotos, smartAlbums, userCollections)
    }
    
    func getPhotosFromAlbum(album : PHAssetCollection) -> PHFetchResult<PHAsset> {
        
        let photosOption = PHFetchOptions()
        photosOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let photos = PHAsset.fetchAssets(in: album, options: photosOption)
        
        return photos
    }
    
    func getAspectFillWidthImage(image1 : UIImage, width : CGFloat) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: image1.size.height * (width / image1.size.width)), false, UIScreen.main.scale)
                
        image1.draw(in: CGRect(x: 0, y: 0, width: width, height: image1.size.height * (width / image1.size.width)))
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return finalImage!
    }
    
    func sliceImage(with images : [UIImage], completion : (_ finalImage : UIImage) -> Void) {
        
        var height : CGFloat = 0.0
        var totalHeight : CGFloat = 0.0
        
        images.enumerated().forEach { (index, image) in
            
            totalHeight += image.size.height
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: Scale(360), height: totalHeight * (Scale(360) / images[0].size.width)), false, UIScreen.main.scale)
        
        images.enumerated().forEach { (index, image) in
            
            let finalImage = self.getAspectFillWidthImage(image1: image, width: Scale(360))
            image.draw(in: CGRect(x: 0, y: height, width: Scale(360), height: finalImage.size.height))
            
            height += finalImage.size.height
        }
        
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        completion(finalImage!)
        
    }
}

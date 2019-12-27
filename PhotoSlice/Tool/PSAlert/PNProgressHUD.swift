//
//  PNProgressHUD.swift
//  UITestDemo
//
//  Created by ma c on 2019/12/22.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

class PNProgressHUDView : UIView {
    
    lazy var titleLabel: UILabel = {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 0.0))
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    init() {
        super.init(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width - 50, height: 0.0))
        
        self.addSubview(titleLabel)
        
        self.backgroundColor = .white
        
        self.layer.cornerRadius = 8
        self.layer.shadowColor = UIColor(white: 0.0, alpha: 0.4).cgColor
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.clipsToBounds = true
        
        titleLabel.center = self.center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PNProgressHUD: NSObject {
    
    enum PresentType {
        case popup
        case fromTop
        case fromBottom
    }
    
    class func present(with title : NSString, presentType : PresentType, font : UIFont?, backgroundColor : UIColor?, textColor : UIColor?, in superView : UIView?) {
        
        let hudView : PNProgressHUDView = PNProgressHUDView()
        let height = title.boundingRect(with: .init(width: hudView.bounds.width, height: 0.0), options: NSStringDrawingOptions.Element(rawValue: NSStringDrawingOptions.usesFontLeading.rawValue | NSStringDrawingOptions.usesLineFragmentOrigin.rawValue), attributes: [NSAttributedString.Key.font : font != nil ? font as Any : UIFont.systemFont(ofSize: 14.0)], context: nil).size.height
        
        hudView.frame.size.height = height + 40
        
        hudView.titleLabel.text = String(title)
        hudView.titleLabel.frame.size.height = height
        hudView.titleLabel.center = hudView.center
        
        presentAnimation(view: hudView, presentType: presentType, superView: superView)
        
    }
    
    class func presentAnimation(view : PNProgressHUDView, presentType : PresentType, superView : UIView?) {
        
        if superView == nil {
            
            (UIApplication.shared.delegate as! AppDelegate).window?.addSubview(view)
        }else {
            
            superView?.addSubview(view)
        }
        
        switch presentType {
        case .popup:
            
            if superView == nil {
                
                view.center = (UIApplication.shared.delegate as! AppDelegate).window!.center
            }else {
                
                view.frame.origin = CGPoint(x: superView!.bounds.width / 2.0 - view.bounds.width / 2.0, y: superView!.bounds.height / 2.0 - view.bounds.height / 2.0)
            }
            
            view.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            
            UIView.animate(withDuration: 0.1, animations: {
                
                view.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            }) { (completed) in
                
                UIView.animate(withDuration: 0.1, delay: 1, options: .curveEaseInOut, animations: {
                    
                    view.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                }) { (completed) in
                    
                    view.removeFromSuperview()
                }
            }
            break
        case .fromTop:
            if superView == nil {
                
                view.frame.origin = CGPoint(x: 0.0, y: (UIApplication.shared.delegate as! AppDelegate).window!.frame.origin.y - view.bounds.height)
            }else {
                
                view.frame.origin = CGPoint(x: (superView!.bounds.width - view.bounds.width) / 2.0, y: superView!.bounds.origin.y - view.bounds.height)
            }
            
            UIView.animate(withDuration: 0.1, animations: {
                
                view.frame.origin = CGPoint(x: (superView!.bounds.width - view.bounds.width) / 2.0, y: superView!.bounds.origin.y + 50)
            }) { (completed) in
                
                UIView.animate(withDuration: 0.1, delay: 1, options: .curveEaseInOut, animations: {
                    
                    view.frame.origin = CGPoint(x: (superView!.bounds.width - view.bounds.width) / 2.0, y: superView!.bounds.origin.y - view.bounds.height)
                }) { (completed) in
                    
                    view.removeFromSuperview()
                }
            }
            break
        default:
            break
        }
        
        
    }

}

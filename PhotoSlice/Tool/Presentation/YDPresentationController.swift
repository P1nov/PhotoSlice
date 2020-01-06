//
//  YDPresentationController.swift
//  newyidian51
//
//  Created by ma c on 2019/12/19.
//  Copyright © 2019 北京鱼爪网络科技有限公司. All rights reserved.
//

import UIKit

class YDPresentationController: UIPresentationController, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    enum EDpresentationType {
                case Popup
                case FromLeft
                case FromRight
                case FromBottom
            }
            
            enum EDTransitionType {
                case present
                case dismiss
            }
            
            var presentationType : EDpresentationType? = .Popup
            var transitionType : EDTransitionType? = .present
            
            var dimingView : UIView!
            var presentationWrappingView : UIView!
            
            override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
                
                super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
                
                presentedViewController.modalPresentationStyle = .custom
            }
            
            override var presentedView: UIView? {
                
                return presentationWrappingView!
            }
            
            override func presentationTransitionWillBegin() {
                
                let presentedViewControllerView = super.presentedView
                
                /*
                 
                 设置wrappingView
                 */
                let presentedWrapingView1 = UIView.init(frame: self.frameOfPresentedViewInContainerView)
                presentedWrapingView1.layer.shadowOpacity = 0.44
                presentedWrapingView1.layer.shadowRadius = 13.0
                presentedWrapingView1.layer.shadowOffset = CGSize.init(width: 0, height: -6.0)
                presentationWrappingView = presentedWrapingView1
                
                let presentationRoundCornerView = UIView.init(frame: presentationWrappingView!.bounds.inset(by: UIEdgeInsets.init(top: 0, left: 0, bottom: -16.0, right: 0)))
                presentationRoundCornerView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleWidth.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue)
    //            presentationRoundCornerView.layer.cornerRadius = 16.0
                presentationRoundCornerView.layer.masksToBounds = true
                
                let presentedViewControllerWrapperView = UIView.init(frame: presentationWrappingView!.bounds.inset(by: UIEdgeInsets.init(top: 0, left: 0, bottom: 16.0, right: 0)))
                presentedViewControllerWrapperView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleWidth.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue)
                
                presentedViewControllerView?.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleHeight.rawValue | UIView.AutoresizingMask.flexibleWidth.rawValue)
                presentedViewControllerView?.frame = presentationWrappingView!.bounds
                
                presentedViewControllerWrapperView.addSubview(presentedViewControllerView!)
                presentationRoundCornerView.addSubview(presentedViewControllerWrapperView)
                presentationWrappingView?.addSubview(presentationRoundCornerView)
                
                
                /*
                 
                 设置dimingView
                 */
                
                let dimmingView = UIView.init(frame: self.containerView!.bounds)
                dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
                dimmingView.isOpaque = false;
                dimmingView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleHeight.rawValue | UIView.AutoresizingMask.flexibleWidth.rawValue)
                dimmingView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(dimmingViewTapped)))
                dimingView = dimmingView
                self.containerView?.addSubview(dimmingView)
                
                let transitionCoordinator = self.presentingViewController.transitionCoordinator
                
                dimingView?.alpha = 0.0
                
                transitionCoordinator?.animate(alongsideTransition: { (context) in
                    
                    self.dimingView?.alpha = 0.5
                }, completion: nil)
            }
            
            override func presentationTransitionDidEnd(_ completed: Bool) {
                
                if !completed {
                    
                    presentationWrappingView = nil
                    dimingView = nil
                }
            }
            
            override func dismissalTransitionWillBegin() {
                
                let transitionCoordinator = self.presentingViewController.transitionCoordinator
                
                transitionCoordinator?.animate(alongsideTransition: { (context) in
                    
                    self.dimingView?.alpha = 0.0
                }, completion: nil)
            }
            
            override func dismissalTransitionDidEnd(_ completed: Bool) {
                
                if completed {
                    
                    dimingView = nil
                    presentationWrappingView = nil
                }
            }
            
            override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
                
                super.preferredContentSizeDidChange(forChildContentContainer: container)
                
                if container.isEqual(self.presentedViewController) {
                    
                    self.containerView?.setNeedsLayout()
                }
            }
            
            override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
                
                if container.isEqual(self.presentedViewController) {
                    
                    return container.preferredContentSize
                }else {
                    
                    return super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
                }
            }
            
            override var frameOfPresentedViewInContainerView: CGRect {
                
                let containerViewBounds = self.containerView?.bounds
                
                let presentedViewSize = self.size(forChildContentContainer: self.presentedViewController, withParentContainerSize: containerViewBounds!.size)
                
                var presentedViewControllerFrame = containerViewBounds
                presentedViewControllerFrame?.size.height = presentedViewSize.height
                presentedViewControllerFrame?.origin.y = containerViewBounds!.maxY - presentedViewSize.height
                
                return presentedViewControllerFrame!
                
            }
            
            override func containerViewWillLayoutSubviews() {
                
                super.containerViewWillLayoutSubviews()
                
                self.presentationWrappingView.frame = self.frameOfPresentedViewInContainerView;
                self.dimingView.frame = self.containerView!.frame
            }
            
            @objc private func dimmingViewTapped() {
                
                self.presentingViewController.dismiss(animated: true, completion: nil)
            }
            
            func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
                
                let fromViewController = transitionContext.viewController(forKey: .from)
                let toViewController = transitionContext.viewController(forKey: .to)
                
                let containerView = transitionContext.containerView
                
                let toView = transitionContext.view(forKey: .to)
                let fromView = transitionContext.view(forKey: .from)
                
                let isPresenting = fromViewController?.isEqual(self.presentingViewController)
                
                let _ = transitionContext.initialFrame(for: fromViewController!)
                var fromViewFinalFrame = transitionContext.finalFrame(for: fromViewController!)
    //            var fromViewIntialFrame = transitionContext.initialFrame(for: fromViewController!)
                var toViewInitialFrame = transitionContext.initialFrame(for: toViewController!)
                let toViewFinalFrame = transitionContext.finalFrame(for: toViewController!)
                
                if toView != nil {
                    
                    containerView.addSubview(toView!)
                }
                
                
                if isPresenting! {
                    
                    if presentationType == .Popup {
                        
                        toViewInitialFrame.origin = CGPoint.init(x: Scale(30), y: Scale(50))
                        toViewInitialFrame.size = toViewFinalFrame.size
                        toView!.frame = toViewInitialFrame
                        
                    }else {
                        
                        toViewInitialFrame.origin = CGPoint.init(x: containerView.bounds.minX, y: containerView.bounds.maxY)
                        toViewInitialFrame.size = toViewFinalFrame.size
                        toView!.frame = toViewInitialFrame
                    }
                    
                }else {
                    
                    if presentationType != .Popup {
                        
                        fromViewFinalFrame = (fromView?.frame.offsetBy(dx: 0, dy: fromView!.frame.height))!
                    }
                    
                    
                }
                
                toView?.alpha = 0.0

                if presentationType == .Popup {
                    
                    toView?.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                }
                
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {

                    if isPresenting! {
                        
                        toView?.alpha = 1.0

                        if self.presentationType == .Popup {
                            
                            toView?.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
                            toView!.frame = toViewFinalFrame
                        }else {
                            
                            toView!.frame = toViewFinalFrame
                        }
                        
                    }else {
                        
                        fromView?.alpha = 0.0
                        
                        if self.presentationType == .Popup {

                            fromView?.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                        }else {
                            
                            fromView!.frame = fromViewFinalFrame
                        }
                        
                    }

                }) { (completed) in

                    transitionContext.completeTransition(true)
                }
                
            }

            func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
                
                return transitionContext!.isAnimated ? 0.2 : 0.0
            }
            
            func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
                
                return self
            }
            
            func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
                
                return self
            }
            
            func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
                
                return self
            }

}

extension YDPresentationController {
    
    private func presentTransition(transitionContext : UIViewControllerContextTransitioning) {
        
        let toVC = transitionContext.viewController(forKey: .to)
        let fromVC = transitionContext.viewController(forKey: .from)
        
        toVC?.modalPresentationStyle = .custom
        
        guard let fromView = fromVC?.view,
              let toView = toVC?.view
        else {
            
            return
        }
        
        transitionContext.containerView.addSubview(toView)
        
        switch presentationType{
        case .Popup:
            popUpPresentViewController(fromView: fromView, toView: toView, transitionContext: transitionContext)
        default:
            break
        }
    }
    
    private func dismissTransition(transitionContext : UIViewControllerContextTransitioning) {
        
        let toVC = transitionContext.viewController(forKey: .to)
        let fromVC = transitionContext.viewController(forKey: .from)
        
        toVC?.modalPresentationStyle = .custom
        
        guard let fromView = fromVC?.view,
              let toView = toVC?.view
        else {
            
            return
        }
        
        transitionContext.containerView.addSubview(toView)
        
        switch presentationType{
            
            case .Popup:
            
                popUpDismissViewController(fromView: fromView, toView: toView, transitionContext: transitionContext)
            
            default:
                break
        }
    }
    
    
    
    private func popUpPresentViewController(fromView : UIView, toView : UIView, transitionContext : UIViewControllerContextTransitioning) {
        
        toView.frame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)
        toView.alpha = 0.0
        toView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            toView.alpha = 1.0
            toView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
        }) { (completed) in
            
            toView.alpha = 1.0
            toView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            transitionContext.completeTransition(true)
        }
    }
    
    private func popUpDismissViewController(fromView : UIView, toView : UIView, transitionContext : UIViewControllerContextTransitioning) {
        
        transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            fromView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            
        }) { (completed) in
            
            transitionContext.completeTransition(true)
        }
    }
}

extension UIViewController {
    
    func popUpPresentViewController(viewController : UIViewController, completion : (() -> Void)?) {
        
        let presentViewController = YDPresentationController.init(presentedViewController: viewController, presenting: self)
        presentViewController.presentationType = .Popup
        presentViewController.transitionType = .present
        viewController.modalPresentationStyle = .custom
        
        viewController.transitioningDelegate = presentViewController
        
        self.present(viewController, animated: true, completion: completion)
    }
    
    func customPresent(viewController : UIViewController) {
        
        let presentViewController = YDPresentationController.init(presentedViewController: viewController, presenting: self)
        presentViewController.presentationType = .FromBottom
        presentViewController.transitionType = .present
        viewController.modalPresentationStyle = .custom
        
        viewController.transitioningDelegate = presentViewController
        
        self.present(viewController, animated: true, completion: nil)
    }
}

//
//  FloatingModalPresentationController.swift
//  dropDownExample
//
//  Created by Cynthia Denisse Verdiales Moreno on 26/02/24.
//

import UIKit

class FloatingModalPresentationController: UIPresentationController {
    private var dimmingView: UIView!
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }
    
    private func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimmingView.alpha = 0.0
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else {return}
        
        dimmingView.frame = containerView.bounds
        containerView.addSubview(dimmingView)
        containerView.addSubview(presentedViewController.view)
        
        if let coordinator = presentingViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: {_ in
                self.dimmingView.alpha = 1.0
            }, completion: nil)
        }
    }
   
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentingViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: {_ in
                self.dimmingView.alpha = 0.0
            }, completion: nil)
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {return .zero}
        var frame = containerView.bounds
        frame = frame.insetBy(dx: 30, dy: 100)
        return frame
    }
}

//
//  PTPresentationController.swift
//  DO_POPUPWindow
//
//  Created by pmst on 15/12/5.
//  Copyright © 2015年 pmst. All rights reserved.
//

import UIKit

class PTPresentationController: UIPresentationController {
  
  override func frameOfPresentedViewInContainerView() -> CGRect {
    // 告诉它尺寸大小 就是上下左右往里都收缩一部分
    return super.frameOfPresentedViewInContainerView().insetBy(dx: 40, dy: 40)
  }
  
  // 开始前配置视图
  override func presentationTransitionWillBegin() {
    let con = self.containerView!
    let shadow = UIView(frame: con.bounds)
    shadow.backgroundColor = UIColor(white: 0, alpha: 0.4)
    // 最底层
    con.insertSubview(shadow, atIndex: 0)
    shadow.autoresizingMask = [.FlexibleHeight,.FlexibleWidth]
  }
  
  override func dismissalTransitionWillBegin() {
    let con = self.containerView!
    let shadow = con.subviews[0]  //因为我们设置了它的index = 0
    let tc = self.presentedViewController.transitionCoordinator()!
    
    // 这个就需要你在animation controller 中实现dismissal 动画了
    tc.animateAlongsideTransition({
      _ in
      shadow.alpha = 0
      }, completion: nil)
  }
  
  // 告知最后的presented view
  override func presentedView() -> UIView? {
    let v = super.presentedView()!
    v.layer.cornerRadius = 6
    v.layer.masksToBounds = true
    return v
  }
  
  // presented view 动画结束
  override func presentationTransitionDidEnd(completed: Bool) {
    // 把preseting view controller 风格改了
    let vc = self.presentingViewController
    let v = vc.view
    v.tintAdjustmentMode = .Dimmed
  }
  
  // 这个才是
  override func dismissalTransitionDidEnd(completed: Bool) {
    let vc = self.presentingViewController
    let v = vc.view
    v.tintAdjustmentMode = .Automatic
  }
}

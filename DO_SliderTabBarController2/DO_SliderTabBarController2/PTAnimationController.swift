//
//  PTAnimationController.swift
//  DO_SliderTabBarController
//
//  Created by pmst on 15/12/4.
//  Copyright © 2015年 pmst. All rights reserved.
//

import UIKit

class PTAnimationController: UIViewController {
  
  // MARK: - Properties
  weak var tbc : UITabBarController?
  var duration:NSTimeInterval = 0.4
  var interacting:Bool = false
  var context : UIViewControllerContextTransitioning!
  var fvEndFrame:CGRect = CGRectZero
  var tvStartFrame:CGRect = CGRectZero
  
  // MARK: - Method

  
  override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }


}
// MARK: - UITabBarControllerDelegate Protocol
extension PTAnimationController:UITabBarControllerDelegate{

  /// 页面切换调用该方法 告知哪个对象来进行动画设计
  /// 这里是self
  func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return self
  }
  
  /// 页面切换调用该方法 告知哪个对象来进行交互式的响应(多指手势)
  /// 本来这个方法调用之后 要调用startInteractiveTransition了
  /// 但是percent driver 是直接转向调用animateTransition 但是不执行动画！
  /// 其实就是去要个起始状态，之后持续调用updateInteractiveTransition方法
  func tabBarController(tabBarController: UITabBarController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return self.interacting ? self:nil
  }
}
// MARK: - UIViewControllerAnimatedTransitioning Protocol
extension PTAnimationController:UIViewControllerAnimatedTransitioning{
  
  // 动画执行的时间
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return self.duration
  }
  
  // 动画具体执行方案
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

    let fvc = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
    let tvc = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
    let cv  = transitionContext.containerView()!
    
    let fvStartFrame = transitionContext.initialFrameForViewController(fvc)
    let tvEndFrame   = transitionContext.finalFrameForViewController(tvc)
    let fv = transitionContext.viewForKey(UITransitionContextFromViewKey)!
    let tv = transitionContext.viewForKey(UITransitionContextToViewKey)!
    
    let index1 = self.tbc!.viewControllers!.indexOf(fvc)!
    let index2 = self.tbc!.viewControllers!.indexOf(tvc)!
    let dir : CGFloat = index1 < index2 ? 1 : -1
    
    // 设定From View 的结束位置,起始位置已知
    var fvEndFrame = fvStartFrame
    fvEndFrame.origin.x -= fvEndFrame.size.width * dir
    
    // 设定To View 的起始位置,结束位置已知
    var tvStartFrame = tvEndFrame
    tvStartFrame.origin.x += tvStartFrame.size.width * dir
    
    tv.frame = tvStartFrame
    cv.addSubview(tv)
    
    UIView.animateWithDuration(self.duration, animations: {
      fv.frame = fvEndFrame
      tv.frame = tvEndFrame
      },completion: {
        _ in
        let cancelled = transitionContext.transitionWasCancelled()
        transitionContext.completeTransition(!cancelled)
    })
  }
}

extension PTAnimationController:UIViewControllerInteractiveTransitioning{
  
  // 做好准备工作!
  func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
    //
    self.context = transitionContext
    
    let fvc = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
    let tvc = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
    let cv  = transitionContext.containerView()!
    
    let fvStartFrame = transitionContext.initialFrameForViewController(fvc)
    let tvEndFrame   = transitionContext.finalFrameForViewController(tvc)
    let fv = transitionContext.viewForKey(UITransitionContextFromViewKey)!
    let tv = transitionContext.viewForKey(UITransitionContextToViewKey)!
    
    let index1 = self.tbc!.viewControllers!.indexOf(fvc)!
    let index2 = self.tbc!.viewControllers!.indexOf(tvc)!
    let dir : CGFloat = index1 < index2 ? 1 : -1
    
    // 设定From View 的结束位置,起始位置已知
    var fvEndFrame = fvStartFrame
    fvEndFrame.origin.x -= fvEndFrame.size.width * dir
    
    // 设定To View 的起始位置,结束位置已知
    var tvStartFrame = tvEndFrame
    tvStartFrame.origin.x += tvStartFrame.size.width * dir
    
    tv.frame = tvStartFrame
    cv.addSubview(tv)
    
    // record initial conditions so the gesture recognizer can get at them
    self.fvEndFrame = fvEndFrame
    self.tvStartFrame = tvStartFrame
  }
}






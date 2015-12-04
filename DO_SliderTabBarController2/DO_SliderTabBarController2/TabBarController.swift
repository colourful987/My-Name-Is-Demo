//
//  TabBarController.swift
//  DO_SliderTabBarController
//
//  Created by pmst on 15/12/4.
//  Copyright © 2015年 pmst. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

  // MARK: - Properties
  
  var ptAnimation = PTAnimationController()
  var rightEdger :UIScreenEdgePanGestureRecognizer!
  var leftEdger:UIScreenEdgePanGestureRecognizer!

  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Notice 这里有个循环引用
    self.delegate = ptAnimation
    ptAnimation.tbc = self
    
    // 添加手势
    let sep = UIScreenEdgePanGestureRecognizer(target: self, action: "pan:")
    sep.edges = UIRectEdge.Right
    self.view.addGestureRecognizer(sep)
    sep.delegate = self
    self.rightEdger = sep
    let sep2 = UIScreenEdgePanGestureRecognizer(target: self, action: "pan:")
    sep2.edges = UIRectEdge.Left
    self.view.addGestureRecognizer(sep2)
    sep2.delegate = self
    self.leftEdger = sep2
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
}
extension TabBarController:UIGestureRecognizerDelegate{

  // 是否执行手势
  func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
    var result = false
    
    // selected Index 值改变会触发动画
    if gestureRecognizer == self.rightEdger{
      result = (self.selectedIndex < self.viewControllers!.count - 1)
    }else{
      result = (self.selectedIndex > 0)
    }
    return result
  }
  
  func pan(g:UIScreenEdgePanGestureRecognizer){
    let v = g.view!
    let delta = g.translationInView(v)  // 获得滑动了距离
    let percent = fabs(delta.x/v.bounds.size.width)
    
    var vc1:UIViewController! //from view
    var vc2:UIViewController! //to view
    var con:UIView!           //container view
    var r1start:CGRect!       //fvStartFrame
    var r2end:CGRect!         //tvEndFrame
    var v1:UIView!            //fv
    var v2:UIView!            //tv
    
    let tc = self.ptAnimation.context
    if tc != nil{
      vc1 = tc.viewControllerForKey(UITransitionContextFromViewControllerKey)!
      vc2 = tc.viewControllerForKey(UITransitionContextToViewControllerKey)!
      
      con = tc.containerView()
      
      r1start = tc.initialFrameForViewController(vc1)
      r2end = tc.finalFrameForViewController(vc2)
      
      v1 = tc.viewForKey(UITransitionContextFromViewKey)!
      v2 = tc.viewForKey(UITransitionContextToViewKey)!
    }
    
    
    switch g.state{
    case .Began:
      // 表明开始交互
      self.ptAnimation.interacting = true
      
      if g == self.rightEdger{
        // 更改selectedIndex 会触发页面切换动画
        self.selectedIndex = self.selectedIndex + 1
      }else{
        self.selectedIndex = self.selectedIndex - 1
      }
    case .Changed:
      r1start.origin.x += (self.ptAnimation.fvEndFrame.origin.x-r1start.origin.x)*percent
      v1.frame = r1start
      var r2start = self.ptAnimation.tvStartFrame
      r2start.origin.x += (r2end.origin.x-r2start.origin.x)*percent
      v2.frame = r2start
      tc.updateInteractiveTransition(percent)
      
    case .Ended:
      if percent > 0.5{
        UIView.animateWithDuration(0.2, animations: {
          v1.frame = self.ptAnimation.fvEndFrame
          v2.frame = r2end
          },completion: {
            _ in
            tc.finishInteractiveTransition()
            tc.completeTransition(true)
        })
      }
      else{
        UIView.animateWithDuration(0.2, animations: {
          v1.frame = r1start
          v2.frame = self.ptAnimation.tvStartFrame
          },completion: {
            _ in
            tc.cancelInteractiveTransition()
            tc.completeTransition(false)
        })
      }
      self.ptAnimation.interacting = false
      self.ptAnimation.context = nil
    case .Cancelled:
      v1.frame = r1start
      v2.frame = self.ptAnimation.tvStartFrame
      tc.cancelInteractiveTransition()
      tc.completeTransition(false)
      self.ptAnimation.interacting = false
      self.ptAnimation.context = nil
    default: break
    }
  }
  
}

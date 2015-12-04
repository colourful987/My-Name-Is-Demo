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
    
    switch g.state{
    case .Began:

      ptAnimation.inter = UIPercentDrivenInteractiveTransition()
      ptAnimation.interacting = true
      // 右侧手势
      if g == self.rightEdger{
        // 更改selectedIndex 会触发页面切换动画
        self.selectedIndex = self.selectedIndex + 1
      }else{
        self.selectedIndex = self.selectedIndex - 1
      }
    case .Changed:
      ptAnimation.inter.updateInteractiveTransition(percent)
    case .Ended:
      if percent > 0.5{
        ptAnimation.inter.finishInteractiveTransition()
      }
      else{
        ptAnimation.inter.cancelInteractiveTransition()
      }
      ptAnimation.interacting = false
    default: break
    }
  }
  
}

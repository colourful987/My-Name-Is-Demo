//
//  ViewController2.swift
//  DO_POPUPWindow
//
//  Created by pmst on 15/12/5.
//  Copyright © 2015年 pmst. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

  // 设置代理
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    /// 由于ViewController2 是作为presented view Controller
    /// 所以要分配给它一个delegate，即transitioningDelegate。
    /// 当然这个delegate可以是self，也可以是别的对象。
    /// 唯一要求是遵循UIViewControllerTransitioningDelegate
    self.transitioningDelegate = self
    
    /// 以下是presentation controller 设置自定义
    /// 正是因为设置了.Custom 所以才会向上面transitioningDelegate 
    /// 额外发送一个信息，寻求presentationController是哪个家伙来当
    self.modalPresentationStyle = .Custom
  }
  
  //MARK: - Method
  
  @IBAction func doCancel(sender:UIButton){
    self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
  }

}


// MARK : - UIViewControllerTransitioningDelegate
extension ViewController2:UIViewControllerTransitioningDelegate{
  /**
      1. 告知呈现时的animationController
      2. 告知消失时的animationController
      3. 告知呈现时的interactionController
      4. 告知消失时的interactionController(暂时不理解)
  */
  
  func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return self // 即让viewcontroller 作为animationController
  }
  func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
    let pc = PTPresentationController(presentedViewController:presented,presentingViewController: presenting)
    return pc
  }
}

extension ViewController2:UIViewControllerAnimatedTransitioning{

  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return 0.4
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    // to View Controller
    let tvc = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
    let containerView = transitionContext.containerView()
    // 获得to View 的最后位置
    let tvEndFrame = transitionContext.finalFrameForViewController(tvc)
    
    let tv = transitionContext.viewForKey(UITransitionContextToViewKey)!
    
    // 设置toView的位置为结束位置
    tv.frame = tvEndFrame
    // 做一个变换 按比例缩放视图作为起始位置
    tv.transform = CGAffineTransformMakeScale(0.1, 0.1)
    // 一开始不可见
    tv.alpha = 0.0
    containerView!.addSubview(tv)
    
    // 执行动画
    UIView.animateWithDuration(0.4, animations: {
      tv.alpha = 1.0
      tv.transform = CGAffineTransformIdentity
      }, completion: {
        _ in
        transitionContext.completeTransition(true)
    })
  }
}












































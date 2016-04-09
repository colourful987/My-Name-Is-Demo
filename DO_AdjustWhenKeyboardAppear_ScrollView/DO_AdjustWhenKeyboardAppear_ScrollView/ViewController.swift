//
//  ViewController.swift
//  DO_AdjustWhenKeyboardAppear_ScrollView
//
//  Created by pmst on 4/9/16.
//  Copyright © 2016 pmst. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet var scrollView : UIScrollView!
	var fr : UIView?
	var oldContentInset = UIEdgeInsetsZero
	var oldIndicatorInset = UIEdgeInsetsZero
	var oldOffset = CGPointZero
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// 注册键盘事件 ：键盘弹出 和 键盘隐藏
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShow:", name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHide:", name: UIKeyboardWillHideNotification, object: nil)
		
		// 获得scrollview的contentView
		let contentView = self.scrollView.subviews[0]
		
		// 为contentView设置两个约束 分别让其高度和宽度等于scrollView的高度和宽度
		self.scrollView.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Width, relatedBy: .Equal, toItem: self.scrollView, attribute: .Width, multiplier: 1, constant: 0))
		self.scrollView.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Height, relatedBy: .Equal, toItem: self.scrollView, attribute: .Height, multiplier: 1, constant: 0))
		
	}
	
	func textFieldDidBeginEditing(tf: UITextField) {
		// 使用一个变量暂时追踪first responder
		self.fr = tf
	}
	
	func textFieldShouldReturn(tf: UITextField) -> Bool {
		// textField 输入结束 解除第一响应者
		tf.resignFirstResponder()
		// 且将当前输入textfield指向移除
		self.fr = nil
		return true
	}
	
	override func shouldAutorotate() -> Bool {
		return self.fr == nil
	}
	
	func keyboardShow(n:NSNotification) {
		
		// 获得旧参数数据
		self.oldContentInset = self.scrollView.contentInset
		self.oldIndicatorInset = self.scrollView.scrollIndicatorInsets
		self.oldOffset = self.scrollView.contentOffset
		
		
		// 更新数据
		let d = n.userInfo!
		var r = (d[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
		r = self.scrollView.convertRect(r, fromView:nil)

		self.scrollView.contentInset.bottom = r.size.height
		self.scrollView.scrollIndicatorInsets.bottom = r.size.height
	}
	
	func keyboardHide(n:NSNotification) {
		// 重置
		self.scrollView.bounds.origin = self.oldOffset
		self.scrollView.scrollIndicatorInsets = self.oldIndicatorInset
		self.scrollView.contentInset = self.oldContentInset
	}

}


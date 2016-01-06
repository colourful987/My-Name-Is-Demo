//
//  ViewController.swift
//  DO_AdjustWhenKeyboardAppear
//
//  Created by pmst on 16/1/6.
//  Copyright © 2016年 pmst. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	// sb中设置的两个约束 用于之后调整
	@IBOutlet var topConstraint:NSLayoutConstraint!
	@IBOutlet var bottomConstraint:NSLayoutConstraint!
	// slide View 将实际东西放入这个container中即可 我们主要调整 这个视图的位置来适应键盘
	@IBOutlet var slidingView:UIView!
	
	// 当前正在处理的Textfield
	var currentTextField:UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// 对键盘增加两个事件通知 1.键盘出现 2.键盘消失
		self.registerKeyboardNotification()
		
		// 别忘记设置所有 TextField 的 Delegate 为 self!!! 
		// 项目中我采用SB中拖线方式实现的！
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	//MARK: - 注册键盘通知
	func registerKeyboardNotification(){
		// 键盘将要显示
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShow:", name: UIKeyboardWillShowNotification, object: nil)
		// 键盘将要消失
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHide:", name: UIKeyboardWillHideNotification, object: nil)
	}
	
	//MARK: - 处理键盘事件
	
	func keyboardShow(n:NSNotification){
		
		// 获取信息 字典类型
		let info = n.userInfo!
		
		// 通过键获取到值
		var frame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
		// nil 表示window，因此就是将window中的键盘坐标frame转换到slidingView中
		frame = self.slidingView.convertRect(frame, fromView: nil)
		
		// 当前处理的TextField在SlidingView中的位置 需要先进行解包操作
		if let f = self.currentTextField?.frame{
			// textfield要出现在键盘上方 5 像素点位置！  这里你可以改动
			// 倘若这里不理解 请自己绘图下
			let offset:CGFloat = f.maxY + frame.size.height - self.slidingView.bounds.height + 5
			
			// 倘若 textfield 目前被键盘挡住了，则将slidingView 上移
			if frame.origin.y < f.maxY{
				self.topConstraint.constant = -offset
				self.bottomConstraint.constant = offset
				self.view.layoutIfNeeded()	// 触发一次布局
			}
		}
	}
	
	// 键盘消失
	func keyboardHide(n:NSNotification){
		// 恢复原样 在iOS8之后这些设置操作都是在一个闭包中执行 所有会有动画！
		self.topConstraint.constant = 0
		self.bottomConstraint.constant = 0
		self.view.layoutIfNeeded()
	}
	
}

//MARK: - Textfield Delegate Method
extension ViewController:UITextFieldDelegate{

	// 一旦有 textField 输入，调用该方法
	func textFieldDidBeginEditing(textField: UITextField) {
		self.currentTextField = textField		// 获取当前正在处理的TextField
	}
	
	// 点击键盘中的return按钮 接触当前textField的第一响应
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		self.currentTextField = nil
		return true
	}
}





























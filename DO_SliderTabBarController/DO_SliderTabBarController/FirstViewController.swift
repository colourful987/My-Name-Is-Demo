//
//  FirstViewController.swift
//  DO_SliderTabBarController
//
//  Created by pmst on 15/12/4.
//  Copyright © 2015年 pmst. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

  // Just for testing
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    print("\(self) " + __FUNCTION__)
  }
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    print("\(self) " + __FUNCTION__)
  }
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    print("\(self) " + __FUNCTION__)
  }
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    print("\(self) " + __FUNCTION__)
  }
  
}


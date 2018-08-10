//
//  CustomNavigationBarItemNavigationController.swift
//  BlogDemoProject
//
//  Created by LinkE on 2018/7/26.
//  Copyright © 2018年 dev. All rights reserved.
//

import UIKit

class CustomNavigationBarItemNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        weak var weakSelf = self
        if self.responds(to: #selector(getter: interactivePopGestureRecognizer)){
            self.interactivePopGestureRecognizer?.delegate = weakSelf
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK : - UIGestureRecognizerDelegate

//extension CustomNavigationBarItemNavigationController {
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if gestureRecognizer == self.interactivePopGestureRecognizer {
//            if viewControllers.count < 2 || (visibleViewController == viewControllers[0]) {
//                return false
//            }
//        }
//        return true
//    }
//}

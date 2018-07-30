//
//  UINavigationController+ScrollViewPopGesture.swift
//  BlogDemoProject
//
//  Created by LinkE on 2018/7/27.
//  Copyright © 2018年 dev. All rights reserved.
// http://swifter.tips/swizzle/(过时了)
// 如何优雅地在Swift4中实现Method Swizzling(http://blog.leanote.com/post/yaoli/%E5%A6%82%E4%BD%95%E4%BC%98%E9%9B%85%E5%9C%B0%E5%9C%A8Swift4%E4%B8%AD%E5%AE%9E%E7%8E%B0Method-Swizzling)

import Foundation
import UIKit

extension UINavigationController{
    // 实现 dispatch_once 
    private static let scrollViewPopGesture: Void = {
        
    }()
    
    static func swapScrollViewPopGesture(){
        scrollViewPopGesture
    }
    
}


extension UINavigationController{
    
}

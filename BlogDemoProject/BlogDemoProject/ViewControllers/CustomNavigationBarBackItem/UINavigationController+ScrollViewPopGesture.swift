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


protocol SelfAware: class{
    static func awake()
}


extension UINavigationController: SelfAware{
    
    static func awake() {
        UINavigationController.classInit()
    }
    
    static func classInit(){
        swizzleMethod
    }
    
    
    @objc func swizzled_viewWillAppear(_ animated: Bool) {
        swizzled_viewWillAppear(animated)
        print("-------- swizzled_viewWillAppear ----------")
    }
    
    
    
    private static let swizzleMethod: Void = {
        let originalSelector = #selector(viewWillAppear(_:))
        let swizzledSelector = #selector(swizzled_viewWillAppear(_:))
        
        let originalMethod = class_getInstanceMethod(UINavigationController.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(UINavigationController.self, swizzledSelector)
        
        guard(originalMethod != nil && swizzledMethod != nil) else {
            return
        }
        
        let didAddMethod = class_addMethod(UINavigationController.self,
                                           originalSelector,
                                           method_getImplementation(swizzledMethod!),
                                           method_getTypeEncoding(swizzledMethod!))
        if(didAddMethod){
            //
            class_replaceMethod(UINavigationController.self,
                                swizzledSelector,
                                method_getImplementation(originalMethod!),
                                method_getTypeEncoding(originalMethod!))
        }else{
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }()
}

// 遍历调用 awake 的初始化 替换方法 (如果只有单个 可单独调用)
class NothingToSeeHere {
    static func harmlessFunction() {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        for index in 0 ..< typeCount {
            (types[index] as? SelfAware.Type)?.awake()
        }
        types.deallocate()
    }
}


// 实现 load 方法 调用替换方法
extension UIApplication {
    private static let runOnce: Void = {
//        NothingToSeeHere.harmlessFunction()
        UINavigationController.awake()
    }()
    
    override open var next: UIResponder? {
        UIApplication.runOnce
        return super.next
    }
}


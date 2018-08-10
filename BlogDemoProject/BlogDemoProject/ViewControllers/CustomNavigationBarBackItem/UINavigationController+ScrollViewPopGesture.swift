//
//  UINavigationController+ScrollViewPopGesture.swift
//  BlogDemoProject
//
//  Created by LinkE on 2018/7/27.
//  Copyright © 2018年 dev. All rights reserved.
// http://swifter.tips/swizzle/(过时了)
// 如何优雅地在Swift4中实现Method Swizzling(http://blog.leanote.com/post/yaoli/%E5%A6%82%E4%BD%95%E4%BC%98%E9%9B%85%E5%9C%B0%E5%9C%A8Swift4%E4%B8%AD%E5%AE%9E%E7%8E%B0Method-Swizzling)

//  -------  还没做对 (2018-08-01)-------

import Foundation
import UIKit


protocol SelfAware: class{
    static func awake()
}


struct AssociatedKeys {
    static var toggleState: UInt8 = 0
    static var panGesture: UInt8 = 1
    static var popDelegate: UInt8 = 2
    static var navDelegate: UInt8 = 3
}



//MARK: - Swizz
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
        
        _ = self.popDelegate()
        _ = self.naviDelegate()
        self.delegate = self
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            DispatchQueue.main.async {
                self.delegate = self.naviDelegate() as? UINavigationControllerDelegate
            }
        }
    }
    
    func popDelegate() -> Any {
        var popDelegate = objc_getAssociatedObject(self, &AssociatedKeys.popDelegate)
        if popDelegate == nil {
            popDelegate = interactivePopGestureRecognizer?.delegate
            objc_setAssociatedObject(self, &AssociatedKeys.popDelegate, popDelegate, .OBJC_ASSOCIATION_ASSIGN)
        }
        return popDelegate!
    }
    
    func naviDelegate() -> Any?{
        var naviDelegate = objc_getAssociatedObject(self, &AssociatedKeys.navDelegate)
        if naviDelegate == nil {
            naviDelegate = self.delegate
            if naviDelegate != nil {
                objc_setAssociatedObject(self, &AssociatedKeys.navDelegate, naviDelegate, .OBJC_ASSOCIATION_ASSIGN)
            }
        }
        return naviDelegate
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



//MARK: - scroll view 滑动返回
extension UINavigationController: UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    //MARK: - UIGestureRecognizerDelegate
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIPanGestureRecognizer) -> Bool {
        if Bool(truncating: self.value(forKey: "_isTransitioning") as! NSNumber) {
            return false
        }
        
        if (self.navigationController?.transitionCoordinator?.isAnimated)! {
            return false
        }
        
        if (self.childViewControllers.count <= 1) {
            return false
        }
        
        let vc = self.topViewController
        if (vc?.interactivePopDisabled)! {
            return false
        }
        
        let location = gestureRecognizer.location(in: self.view)
        let offset = gestureRecognizer.translation(in: gestureRecognizer.view)
        let ret = (0 < offset.x && location.x <= 40)
        return ret
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //MAKRK:  - UINavigationControllerDelegate
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        if (self.naviDelegate() != nil && self.naviDelegate() as? UINavigationController != self){
            if let d = self.naviDelegate() as? UINavigationController {
                if d.responds(to: #selector(navigationController(_:didShow:animated:))) {
                    d.navigationController(navigationController, didShow: viewController, animated: animated)
                }
            }
        }
        
        self.interactivePopGestureRecognizer?.isEnabled = true
        if self.childViewControllers.count > 0 {
            if viewController == self.childViewControllers[0] {
                self.interactivePopGestureRecognizer?.delegate = self.popDelegate() as? UIGestureRecognizerDelegate
            }else {
                self.interactivePopGestureRecognizer?.delegate = nil
            }
        }
    }
    
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if (self.naviDelegate() != nil && self.naviDelegate() as? UINavigationController != self){
            if let d = self.naviDelegate() as? UINavigationController {
                if d.responds(to: #selector(navigationController(_:willShow:animated:))) {
                    d.navigationController(navigationController, willShow: viewController, animated: animated)
                }
            }
        }
    }
    
}

//MARK: - UIViewController

extension UIViewController {
    func addPopGesture(toView view: UIView?)  {
        guard view != nil else { return }
        if navigationController == nil {
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.05) {
                DispatchQueue.main.async {
                    self.addPopGesture(toView: view)
                }
            }
        }else {
            let pan = popGestureRecognizer()
            if !((view!.gestureRecognizers?.contains(pan))!) {
                view?.addGestureRecognizer(pan)
            }
        }
    }
    
    // https://marcosantadev.com/stored-properties-swift-extensions/(添加属性)
    var interactivePopDisabled: Bool {
        get{
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.toggleState) else {
                return false
            }
            return Bool(truncating: value as! NSNumber)
        }
        
        set(newValue){
            objc_setAssociatedObject(self, &AssociatedKeys.toggleState, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    // 添加手势
    func popGestureRecognizer() -> UIPanGestureRecognizer {
        var pan: UIPanGestureRecognizer? = objc_getAssociatedObject(self, &AssociatedKeys.panGesture) as? UIPanGestureRecognizer
        if pan == nil {
            let target = navigationController?.popDelegate
            let action = NSSelectorFromString("")
            pan = UIPanGestureRecognizer(target: target, action: action)
            pan!.maximumNumberOfTouches = 1
            pan!.delegate = self.navigationController
            self.navigationController?.interactivePopGestureRecognizer!.isEnabled = true
            objc_setAssociatedObject(self, &AssociatedKeys.panGesture, pan, .OBJC_ASSOCIATION_ASSIGN)
        }
        return pan!
    }
    
}

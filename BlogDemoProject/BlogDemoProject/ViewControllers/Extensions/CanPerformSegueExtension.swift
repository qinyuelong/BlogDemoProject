//
//  CanPerformSegueExtension.swift
//  BlogDemoProject
//
//  Created by qinge on 2018/10/29.
//  Copyright © 2018年 dev. All rights reserved.
//  https://gist.github.com/anelad/6e4827a1f0b384e65bcec36caa143948

import Foundation
import UIKit

extension UIViewController{
    func canPerformSegue(identifier: String) -> Bool {
        guard let identifiers = value(forKey: "storyboardSegueTemplates") as? [NSObject] else {
            return false
        }
        let canPerform = identifiers.contains { (object) -> Bool in
            if let id = object.value(forKey: "_identifier") as? String {
                return id == identifier
            }else{
                return false
            }
        }
        return canPerform
    }
}


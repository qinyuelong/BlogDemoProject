//
//  CnbbiSubViewController1.swift
//  BlogDemoProject
//
//  Created by LinkE on 2018/7/26.
//  Copyright © 2018年 dev. All rights reserved.
//

import UIKit

class CnbbiSubViewController1: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        customLeftBarButtonItem()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    fileprivate func customLeftBarButtonItem(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(goBack))
        //        navigationItem.leftItemsSupplementBackButton = true
    }
    
    @objc func goBack(){
        navigationController?.popViewController(animated: true)
    }
    
    

}

//
//  CustomNavigationBarBackItemViewController.swift
//  BlogDemoProject
//
//  Created by LinkE on 2018/7/26.
//  Copyright © 2018年 dev. All rights reserved.
//

import UIKit
import SnapKit

class CustomNavigationBarBackItemViewController: BaseViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBackItem()
        setupUIElement()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    fileprivate func setupUIElement(){
        // 添加按钮1
        let button = UIButton(type: .system)
        button.setTitle("自定义LeftBarItem 并能滑动返回", for: .normal)
        button.addTarget(self, action: #selector(buttonDidClicked), for: .touchUpInside)
        view.addSubview(button)
        
        button.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
        
        // 添加按钮2
        let scrollViewButton = UIButton(type: .system)
        scrollViewButton.setTitle("scrollViewButton", for: .normal)
        scrollViewButton.addTarget(self, action: #selector(scrollViewButtonDidClicked), for: .touchUpInside)
        view.addSubview(scrollViewButton)
        scrollViewButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(100)
        }
    }
    
    func setupNavigationBackItem() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    
    @objc fileprivate func buttonDidClicked(_ button: UIButton){
        let vc = CnbbiSubViewController1()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc fileprivate func scrollViewButtonDidClicked(){
        let vc = CnbbiSubViewController2()
        navigationController?.pushViewController(vc, animated: true)
    }

}

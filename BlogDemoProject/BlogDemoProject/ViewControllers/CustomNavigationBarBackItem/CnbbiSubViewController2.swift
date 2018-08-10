//
//  CnbbiSubViewController2.swift
//  BlogDemoProject
//
//  Created by LinkE on 2018/7/26.
//  Copyright © 2018年 dev. All rights reserved.
//  默认 ScrollView 的界面 边界滑动返回是失效的 如果想要scrolllView 也滑动返回(https://github.com/banchichen/TZScrollViewPopGesture)

import UIKit

class CnbbiSubViewController2: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubViews()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setupSubViews() {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = true
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        scrollView.layoutIfNeeded()
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width * 2, height: scrollView.bounds.size.height * 2)
        
        self.addPopGesture(toView: scrollView)
    }
    

}

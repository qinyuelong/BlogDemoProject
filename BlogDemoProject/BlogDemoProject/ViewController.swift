//
//  ViewController.swift
//  BlogDemoProject
//
//  Created by LinkE on 2018/7/26.
//  Copyright © 2018年 dev. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    fileprivate var classNameArray: [String]!
    fileprivate var classNameDic: [String: String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupClassNameArray()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupClassNameArray() {
        classNameArray = [
            "CustomNavigationBarBackItemViewController",
            "CalculateTextFrameViewController",
        ];
        
        classNameDic = ["CustomNavigationBarBackItemViewController" : "自定义导航栏Back按钮 滑动返回手势",
                        "CalculateTextFrameViewController" : "计算文本Frame"
        ]
        
        tableView.reloadData()
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classNameArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let key = classNameArray[indexPath.row]
        cell.textLabel?.text = classNameDic[key]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let key = classNameArray[indexPath.row]
        if canPerformSegue(identifier: key){
            // 如果storyboard 中设置了就不用手动生成 vc
            performSegue(withIdentifier: key, sender: nil)
            return
        }
        let className = "BlogDemoProject.\(classNameArray[indexPath.row])"
        let aClass = NSClassFromString(className) as! UIViewController.Type
        let vc = aClass.init()
        vc.title = classNameDic[key]
//        let nvc = CustomNavigationBarItemNavigationController(rootViewController: vc)
        navigationController?.pushViewController(vc, animated: true)
    }

}


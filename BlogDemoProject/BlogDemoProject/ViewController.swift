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
        ];
        
        classNameDic = ["CustomNavigationBarBackItemViewController" : "自定义导航栏Back按钮 滑动返回手势"]
        
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
        
        let className = "BlogDemoProject.\(classNameArray[indexPath.row])"
        let aClass = NSClassFromString(className) as! UIViewController.Type
        let vc = aClass.init()
        vc.title = classNameDic[key]
        let nvc = UINavigationController(rootViewController: vc)
        present(nvc, animated: true, completion: nil)
    }

}


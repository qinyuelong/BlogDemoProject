//
//  CalculateTextFrameViewController.swift
//  BlogDemoProject
//
//  Created by qinge on 2018/10/29.
//  Copyright © 2018年 dev. All rights reserved.
//

import UIKit

class CalculateTextFrameViewController: BaseViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = calculateTextFrame(text: "", limitSize: .zero)
    }
    

    
    @IBAction func changeTextAction(_ sender: UIButton) {
        label.text = "line1\nline2"
    }
    
    func calculateTextFrame(text: NSString, limitSize: CGSize) -> CGSize {
        let rect = text.boundingRect(with: limitSize, options: .usesLineFragmentOrigin, attributes: nil, context: nil)
        return rect.size
    }
}

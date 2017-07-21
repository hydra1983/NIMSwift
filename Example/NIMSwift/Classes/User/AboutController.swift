//
//  AboutController.swift
//  NIMSwift
//
//  Created by 衡成飞 on 6/20/17.
//  Copyright © 2017 qianwang365. All rights reserved.
//

import UIKit

class AboutController: UIViewController {
    
    @IBOutlet weak var versionLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.title = "关于NIMSwift"
        
        let version = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)
        
        versionLabel.text = "版本：\(version)"
    }

}

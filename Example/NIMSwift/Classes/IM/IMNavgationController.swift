//
//  IMNavgationController.swift
//  NIMSwift
//
//  Created by 衡成飞 on 7/7/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class IMNavgationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "消息"
        
        let vc = IMSessionListController()
        
        self.viewControllers = [vc]
    }

}

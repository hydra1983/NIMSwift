//
//  SettingController.swift
//  Teamwork
//
//  Created by 衡成飞 on 6/20/17.
//  Copyright © 2017 qianwang365. All rights reserved.
//

import UIKit

class SettingController: UIViewController,UITableViewDataSource,UITableViewDelegate {
 
    @IBOutlet weak var tableView:UITableView!
    
    let CellHeight:CGFloat = 70
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "设置"
    
        self.tabBarController?.tabBar.isHidden = true
        tableView.tableFooterView?.frame.size = CGSize(width: Constants.kScreenWidth, height: Constants.kScreenHeight - 64 - 44 - CellHeight)
        
        tableView.tableFooterView?.subviews.flatMap{$0 as? UIButton}.first?.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        UIApplication.shared.statusBarStyle = .default
    }
    
    func logout(){
        let vc = UIAlertController(title: nil, message: "确定要退出登录吗？", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        vc.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
            NIMSDK.shared().loginManager.logout { (error) in
               LoginManager.shareInstance.logout()
               NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.kNotificationTypeLogout), object: nil)
            }
        }))
            
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - ITableViewDataSource,UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "About Cell", for: indexPath)
        
        return cell
    }
}

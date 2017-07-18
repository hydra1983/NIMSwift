//
//  IMTeamListControllerBase.swift
//  NIMSwift
//
//  群／团队的列表页面的父类
//
//  Created by 衡成飞 on 6/17/17.
//  Copyright © 2017 qianwang365. All rights reserved.
//

import UIKit

class IMTeamListControllerBase: UIViewController,UITableViewDataSource,UITableViewDelegate,NIMTeamManagerDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var myTeams:[NIMTeam]? = []
    
    //选择的团队
    var selectedIndexPaths:[IndexPath] = []
    //选择的团队
    var selectedGroups:[[String:String]] = []
    /** 点击完成的回调 **/
    var finishHandler:((_ groups:[[String:String]]) -> Void)?
    
    deinit {
        NIMSDK.shared().teamManager.remove(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.myTeams = fetchTeams()
        
        NIMSDK.shared().teamManager.add(self)
        tableView.tableFooterView = UIView()
        setupNavigation()
    }
    
    func setupNavigation(){
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back_nav")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back_nav")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    /**
      子类实现
    **/
    func fetchTeams() -> [NIMTeam]?{
        return nil
    }

    // MARK: - UITableViewDataSource,UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let n = myTeams?.count {
            return n
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "List Cell", for: indexPath)
        
        let t = myTeams![indexPath.row]
        
        cell.contentView.subviews.flatMap{$0 as? UIImageView}.first?.image = UIImage(named:"team_default")
        if let u = t.avatarUrl ,NSURL(string: u) != nil {
            cell.contentView.subviews.flatMap{$0 as? UIImageView}.first?.cf_setImage(url: NSURL(string:u)!, placeHolderImage: UIImage(named:"team_default"))
        }
        cell.contentView.subviews.flatMap{$0 as? UILabel}.first?.text = t.teamName
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

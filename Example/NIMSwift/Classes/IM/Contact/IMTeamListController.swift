//
//  IMTeamListController.swift
//  NIMSwift
//
//  群列表页面
//
//  Created by 衡成飞 on 6/17/17.
//  Copyright © 2017 qianwang365. All rights reserved.
//

import UIKit

class IMTeamListController: IMTeamListControllerBase {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.title = "群聊"
    }
    
    override func fetchTeams() -> [NIMTeam]? {
        return IMTeamUtil.shareInstance.fetchTeams()

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let t = myTeams![indexPath.row]
        let session = NIMSession(t.teamId!, type: .team)
        
        let vc = IMSessionController(session: session)!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

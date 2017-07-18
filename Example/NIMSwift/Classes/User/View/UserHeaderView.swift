//
//  UserHeaderView.swift
//  Teamwork
//
//  Created by 衡成飞 on 5/23/17.
//  Copyright © 2017 qianwang365. All rights reserved.
//

import UIKit
import GSKStretchyHeaderView

class UserHeaderView: GSKStretchyHeaderView {
    
    var backgroundImageView:UIImageView!
    var blurredBackgroundImageView:UIVisualEffectView!
    var userImageView:UIImageView!
    var usernameLabel:UILabel!
    var titleLabel:UILabel!
    var companyLabel:UILabel!

    let userImageHeight:CGFloat = 60.0
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        backgroundImageView.image = UIImage(named: "avator_default")
        self.contentView.addSubview(backgroundImageView)
        
        let effect = UIBlurEffect(style: .light)
        blurredBackgroundImageView = UIVisualEffectView(effect: effect)
        blurredBackgroundImageView.frame = backgroundImageView.bounds
        self.contentView.addSubview(blurredBackgroundImageView)
        
        userImageView = UIImageView(frame: CGRect(x: (self.width - userImageHeight)/2.0, y: (self.height - userImageHeight)/2.0 - 20, width: userImageHeight, height: userImageHeight))
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = userImageHeight/2.0
        userImageView.image = UIImage(named: "avator_default")
        self.contentView.addSubview(userImageView)

        usernameLabel = UILabel()
        usernameLabel.font = UIFont.systemFont(ofSize: 16.0)
        usernameLabel.textColor = UIColor.darkGray
        let uPoint = userImageView.center
 
        usernameLabel.center = CGPoint(x: uPoint.x - 50, y: uPoint.y + 40.0)
        var frame = usernameLabel.frame
        frame.size.width = 100
        frame.size.height = 30
        usernameLabel.frame = frame
        usernameLabel.textAlignment = .center
        let userCenter = usernameLabel.center
        
        companyLabel = UILabel()
        companyLabel.center = CGPoint(x: userCenter.x - 100, y: userCenter.y +  10.0)
        var frame1 = companyLabel.frame
        frame1.size.width = 200
        frame1.size.height = 30
        companyLabel.frame = frame1
        companyLabel.textAlignment = .center
        companyLabel.font = UIFont.systemFont(ofSize: 14)
        companyLabel.textColor = UIColor.darkGray
        
        self.contentView.addSubview(usernameLabel)
        self.contentView.addSubview(companyLabel)
        
        
    }
    
}

//
//  UserController.swift
//  Teamwork
//
//  Created by 衡成飞 on 5/23/17.
//  Copyright © 2017 qianwang365. All rights reserved.
//

import UIKit
import PromiseKit
import GSKStretchyHeaderView

class UserController: UIViewController,NIMTeamManagerDelegate,GSKStretchyHeaderViewStretchDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var tableView:UITableView!
    
    var headerView: UserHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupHeaderView()
        refresh()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name.init(Constants.kNotificationTypeUserInfoChange), object: nil)
        
        NIMSDK.shared().teamManager.add(self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        UIApplication.shared.statusBarStyle = .lightContent
        
        
    }
    
    func refresh(){
        
        let info = NIMKit.shared().info(byUser: NIMSDK.shared().loginManager.currentAccount(), option: nil)
        
        headerView.usernameLabel.text = info?.showName
        headerView.companyLabel.text = ""
        
        
        if let u = info?.avatarUrlString,NSURL(string:u) != nil {
            headerView.backgroundImageView.cf_setImage(url: NSURL(string:u)!, placeHolderImage: UIImage(named: "avator_default")
            )
            headerView.userImageView.cf_setImage(url: NSURL(string:u)!, placeHolderImage: UIImage(named: "avator_default")
            )
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickAvatar))
        headerView.userImageView.isUserInteractionEnabled = true
        headerView.userImageView.addGestureRecognizer(tap)
        tableView.reloadData()
    }
    
    func setupHeaderView(){
        tableView.tableFooterView = UIView()
        let size = CGSize(width: Constants.kScreenWidth, height: 250)
        
        headerView = UserHeaderView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        //        headerView.maximumContentHeight = 250
        //        headerView.minimumContentHeight = 200
        headerView.expansionMode = .immediate
        headerView.stretchDelegate = self
        tableView.addSubview(headerView)
    }
    
    func clickAvatar(){
        let vc = UIAlertController(title: "选择图像", message: nil, preferredStyle: .actionSheet)
        vc.addAction(UIAlertAction(title:  "取消", style: .cancel, handler:nil))
        
        let cameraAction = UIAlertAction(title:  "拍照", style: .default, handler: { (action) in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .camera
            
            self.present(picker, animated: true, completion: nil)
        })
        
        let albumAction = UIAlertAction(title:  "相册", style: .default, handler: { (action) in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            
            self.present(picker, animated: true, completion: nil)
        })
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            vc.addAction(cameraAction)
            vc.addAction(albumAction)
        }else{
            vc.addAction(albumAction)
        }
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        headerView.backgroundImageView.image = image
        headerView.userImageView.image = image
        
        self.view.showHUDProgress()
        
        let imagePromise:Promise<String> = TMUpload.shareInstance.upload(image!,Constants.kQNToken,TMUpload.shareInstance.getRandomKey())
        
        when(fulfilled: [imagePromise]).then{ upLoadkeys in
             self.updateUserInfo(Constants.kQNURL + upLoadkeys[0] + "-head")
            }.then{ isSuccess -> Void in
                self.view.hiddenAllMessage()
                self.view.showHUDMsg(msg: "上传成功")
                
            }.catch { error -> Void in
                self.view.hiddenAllMessage()
                self.view.showHUDMsg(msg: error.localizedDescription)
        }

        self.tableView.reloadData()
    }
    
    /**
      更新IM头像
    **/
    func updateUserInfo(_ avatarURL:String) -> Promise<Bool>{
        return Promise{fulfill,reject in
            NIMSDK.shared().userManager.updateMyUserInfo([NSNumber.init(value:NIMUserInfoUpdateTag.avatar.rawValue): avatarURL], completion: { (error) in
                if error == nil {
                    fulfill(true)
                }else{
                    reject(error!)
                }
            })
        }
    }
    
    // MARK: - NIMTeamManagerDelegate
    func onTeamMemberChanged(_ team: NIMTeam) {
        refresh()
    }
    
    // MARK: - GSKStretchyHeaderViewStretchDelegate
    func stretchyHeaderView(_ headerView: GSKStretchyHeaderView, didChangeStretchFactor stretchFactor: CGFloat) {
        var alpha:CGFloat = 1.0
        //var blurAlpha:CGFloat = 1.0
        if stretchFactor > 1 {
            alpha =  CGFloatTranslateRange(stretchFactor,1, 1.12, 1, 0)
            //blurAlpha = alpha
        }else if stretchFactor < 0.8 {
            alpha =  CGFloatTranslateRange(stretchFactor,0.2, 0.8, 0, 1)
        }
        alpha = max(0, alpha)
        //  self.headerView.userImageView.alpha = alpha
    }
    
    
}

extension UserController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "setting cell", for: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

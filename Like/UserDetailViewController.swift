//
//  UserDetailViewController.swift
//  Like
//
//  Created by xiusl on 2019/10/14.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserDetailViewController: BaseViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWith(color: .clear), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    var userId: String = ""
    var user: User?
    
    let insetTop: CGFloat = 160
    let bgHeight: CGFloat = ScreenWidth
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.addSubview(self.aView)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.bView)
        self.bView.addSubview(self.cView)
//        self.view.addSubview(self.bView)
        self.cView.addSubview(self.nameLabel)
        
        self.tableView.contentInset = UIEdgeInsets(top: insetTop, left: 0, bottom: 0, right: 0)

                self.tableView.tableHeaderView = self.headerView
        self.loadData()
        
    }
    
    func loadData() {
        let request = UserApiRequest.getUser(id: self.userId)
        ApiManager.shared.request(request: request, success: { (result) in
            let u = User(fromJson: JSON(result))
            self.user = u
            self.headerView.setupAvatar(u.avatar)
            self.headerView.setupName(u.name)
            self.nameLabel.text = u.name
        }) { (error) in
            
        }
    }
    
    lazy var tableView: BaseTableView = {
        let frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        let tableView = BaseTableView(frame: frame, style: .plain)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    lazy var aView: UIImageView = {
        let aView = UIImageView()
        aView.frame = CGRect(x: 0, y: -(self.bgHeight-self.insetTop)/2.0, width: ScreenWidth, height: self.bgHeight)
        aView.image = UIImage(named: "abc")
        return aView
    }()
    
    lazy var bView: UIImageView = {
        let bView = UIImageView()
        bView.frame = CGRect(x: 0, y: self.insetTop-TopSafeHeight, width: ScreenWidth, height: TopSafeHeight)
        bView.backgroundColor = .cF2F4F8
        bView.image = self.fixImage()
        bView.alpha = 1
        bView.clipsToBounds = true
        return bView
    }()
    
    lazy var cView: UIView = {
        let cView = UIView()
        cView.frame = CGRect(x: 36, y: TopSafeHeight, width: 100, height: 40)
        return cView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        nameLabel.textColor = .white
        return nameLabel
    }()
    
    func fixImage() -> UIImage {
        let im = UIImage(named: "abc")!
        let imSize = im.size
        let scale = imSize.height / self.bgHeight
        let h = TopSafeHeight*scale
        let t = (self.bgHeight-self.insetTop)*0.5*scale
        
        let imageRef = im.cgImage
        let subImageRef = imageRef?.cropping(to: CGRect(x: 0, y: imSize.height-h-t, width: imSize.width, height: h))
        return UIImage(cgImage: subImageRef!)
    }
    
    lazy var headerView: UserTableHeaderView = {
        let headerView = UserTableHeaderView()
        headerView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 80)
        headerView.backgroundColor = .white
        return headerView
    }()
    
    
//    override var preferredStatusBarStyle: UIStatusBarStyle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UserDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        print(y)
        if y < -self.insetTop {
            let t = -self.insetTop-y
            self.aView.transform = CGAffineTransform(translationX: 0, y: t*0.5)
            
            self.bView.alpha = 0
            self.bView.transform = CGAffineTransform.identity
        } else if y < -TopSafeHeight {
            let t = -self.insetTop-y
            self.aView.transform = CGAffineTransform(translationX: 0, y: t)
            self.bView.transform = CGAffineTransform(translationX: 0, y: t)
            
            let alpha = min(1, (self.insetTop+y) / (self.insetTop-TopSafeHeight))
            self.bView.alpha = alpha
            self.headerView.setupAvatarAlpha(1-alpha)
        } else {
            self.bView.alpha = 1
            self.bView.transform = CGAffineTransform(translationX: 0, y: -(self.insetTop-TopSafeHeight))
        }
        
        if y > 0 {
            self.cView.transform = CGAffineTransform(translationX: 0, y: -40)
        } else if y > -40 {
            let t = -40-y
            self.cView.transform = CGAffineTransform(translationX: 0, y: t)
        } else {
            self.cView.transform = CGAffineTransform.identity
        }
    }
}

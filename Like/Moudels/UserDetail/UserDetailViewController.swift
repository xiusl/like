//
//  UserDetailViewController.swift
//  Like
//
//  Created by xiusl on 2019/10/14.
//  Copyright © 2019 likeeee. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class UserDetailViewController: BaseViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWith(color: .clear), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    var page: Int = 1
    var count: Int = 5
    var data: Array<Status> = Array()
    var userId: String = ""
    var user: User?
    
    let insetTop: CGFloat = 160
    let bgHeight: CGFloat = ScreenWidth ///  整体高度
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.addSubview(self.bgImageView)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.fackNavView)
        self.fackNavView.addSubview(self.cView)
        self.cView.addSubview(self.nameLabel)
        
        self.tableView.estimatedRowHeight = 110
        self.tableView.estimatedSectionHeaderHeight = 0
        self.tableView.estimatedSectionFooterHeight = 0
        
        self.tableView.contentInset = UIEdgeInsets(top: insetTop, left: 0, bottom: 0, right: 0)
        
        self.tableView.tableHeaderView = self.headerView
        self.loadData()
        
        self.setupRefreshControl()
        
        self.headerView.followActionHandle = {[weak self] in
            guard let `self` = self else { return }
            if self.user!.isCurrnet {
                self.editUserInfo()
            } else {
                self.followCurrentUser()
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name("UserInfoEdited_noti"), object: nil)
        
    }
    func setupRefreshControl() {
        let refHeader: RefreshNormalHeader = RefreshNormalHeader.header(withRefreshingTarget: self, refreshingAction: #selector(loadData)) as! RefreshNormalHeader
        refHeader.ignoredScrollViewContentInsetTop = self.insetTop-TopSafeHeight+54
        refHeader.lastUpdatedTimeLabel.isHidden = true
        refHeader.stateLabel.textColor = .white
        refHeader.activityIndicatorViewStyle = .white
        self.tableView.mjHeader = refHeader
        
        let footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreData))
        self.tableView.mj_footer = footer
    }
    func followCurrentUser() {
        guard let user = self.user else {return}
        let follow = user.isFollowing!
        let id = user.id!
        let req = UserApiRequest.followUser(id: id, followed: !follow)
        ApiManager.shared.request(request: req, success: { (data) in
            SLUtil.showMessage(follow ? "取消关注" : "关注成功")
            user.isFollowing = !follow
            self.headerView.setupFollowed(!follow)
        }) { (error) in
            SLUtil.showMessage(error)
        }
    }
    func editUserInfo() {
        let vc = UserInfoViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func loadData() {
        
        let request = UserApiRequest.getUser(id: self.userId)
        ApiManager.shared.request(request: request, success: { (result) in
            let u = User(fromJson: JSON(result))
            self.user = u
            self.headerView.setupAvatar(u.avatar)
            self.headerView.setupName(u.name)
            self.headerView.setupFollowed(u.isFollowing, isCurrUser: u.isCurrnet)
            self.nameLabel.text = u.name
        }) { (error) in
            
        }
        
        self.page = 1
        let request2 = StatusApiRequest.getUserStatuses(id: self.userId, page: self.page, count: self.count)
        ApiManager.shared.request(request: request2, success: { (result) in
            let data = JSON(result)
            self.data = Array()
            for json in data.arrayValue {
                self.data.append(Status(fromJson: json))
            }
            self.tableView.reloadData()
            self.tableView.mjHeader?.endRefreshing()
            self.tableView.mj_footer?.state = .idle
        }) { (error) in
            self.tableView.mjHeader?.endRefreshing()
        }
    }
    
    @objc func loadMoreData() {
        self.page += 1
        let request = StatusApiRequest.getUserStatuses(id: self.userId, page: self.page, count: self.count)
        ApiManager.shared.request(request: request, success: { (result) in
            
            var i = self.data.count
            var indexs = Array<IndexPath>()
            for json in JSON(result).arrayValue {
                self.data.append(Status(fromJson: json))
                let indexP = IndexPath(row: i, section: 0)
                i += 1
                indexs.append(indexP)
            }
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: indexs, with: .none)
            self.tableView.endUpdates()
            
            if indexs.count == 0 {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self.tableView.mj_footer?.endRefreshing()
            }
        }) { (error) in
            self.tableView.mj_footer?.endRefreshing()
        }
    }
    
    lazy var tableView: BaseTableView = {
        let frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        let tableView = BaseTableView(frame: frame, style: .plain)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var bgImageView: UIImageView = {
        let view = UIImageView()
        view.frame = CGRect(x: 0, y: -(self.bgHeight-self.insetTop)/2.0, width: ScreenWidth, height: self.bgHeight)
        view.image = UIImage(named: "abc")
        return view
    }()
    
    lazy var fackNavView: UIImageView = {
        let view = UIImageView()
        view.frame = CGRect(x: 0, y: self.insetTop-TopSafeHeight, width: ScreenWidth, height: TopSafeHeight)
        view.backgroundColor = .cF2F4F8
        view.image = self.fixImage()
        view.alpha = 1
        view.clipsToBounds = true
        return view
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
        let image = self.bgImageView.image!
        let imageSize = image.size
        let scale = imageSize.height / self.bgHeight
        let h = TopSafeHeight*scale
        let t = (self.bgHeight-self.insetTop)*0.5*scale
        
        let imageRef = image.cgImage
        let subImageRef = imageRef?.cropping(to: CGRect(x: 0, y: imageSize.height-h-t, width: imageSize.width, height: h))
        
        return UIImage(cgImage: subImageRef!)
    }
    
    lazy var headerView: UserTableHeaderView = {
        let headerView = UserTableHeaderView()
        headerView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: (ScreenWidth-self.insetTop)*0.5)
        headerView.backgroundColor = .white
        return headerView
    }()
    
    
    //    override var preferredStatusBarStyle: UIStatusBarStyle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    lazy var moreActionView: StatusMoreView = {
        let view = StatusMoreView()
        view.delegate = self
        return view
    }()
}

extension UserDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(1, self.data.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.data.count == 0 {
            let cell = NoDataViewCell.create(tableView: tableView)
            return cell
        }
        let status = self.data[indexPath.row]
        let user = status.user!
        
        let cell = StatusViewCell.create(tableView: tableView)
        
        cell.setupName(user.name)
        cell.setupAvatar(user.avatar)
        cell.setupContent(status.content)
        cell.setupLike(status.isLiked, count: status.likeCount)
        cell.setupImages(status.images)
        
        cell.delegate = self
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        
        if y < -self.insetTop {
            let t = -self.insetTop-y
            self.bgImageView.transform = CGAffineTransform(translationX: 0, y: t*0.5)
            
            self.fackNavView.alpha = 0
            self.fackNavView.transform = CGAffineTransform.identity
        } else if y < -TopSafeHeight {
            let t = -self.insetTop-y
            self.bgImageView.transform = CGAffineTransform(translationX: 0, y: t)
            self.fackNavView.transform = CGAffineTransform(translationX: 0, y: t)
            
            let alpha = min(1, (self.insetTop+y) / (self.insetTop-TopSafeHeight))
            self.fackNavView.alpha = alpha
            self.headerView.setupAvatarAlpha(1-alpha)
        } else {
            self.fackNavView.alpha = 1
            self.fackNavView.transform = CGAffineTransform(translationX: 0, y: -(self.insetTop-TopSafeHeight))
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.data.count == 0 {
            return ScreenHeight-self.bgHeight
        }
        return UITableView.automaticDimension
    }
}
extension UserDetailViewController: StatusViewCellDelegate {
    func statusCell(_ cell: StatusViewCell, likeClick: Any?) {
        guard let index = self.tableView.indexPath(for: cell) else {return}
        let data: Status = self.data[index.row]
        let liked = data.isLiked!
        var count = data.likeCount ?? 0
        guard let id = data.id else { return }
        let request = StatusApiRequest.likeAction(id: id, like: !liked)
        ApiManager.shared.request(request: request, success: { (result) in
            data.isLiked = !liked
            count = count - (liked ? 1 : -1)
            data.likeCount = count
            cell.setupLike(!liked, count: count)
        }) { (error) in
            debugPrint(error)
        }
    }
    func statusCell(_ cell: StatusViewCell, userClick: Any?) {
        guard let index = self.tableView.indexPath(for: cell) else {return}
        let s = self.data[index.row]
        guard let u = s.user else { return }
        let vc = UserDetailViewController()
        vc.userId = u.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func statusCell(_ cell: StatusViewCell, moreClick: Any?) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        self.moreActionView.indexPath = indexPath
        self.moreActionView.show()
    }
    func statusCell(_ cell: StatusViewCell, shareClick: Any?) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        let s = self.data[indexPath.row]
        
        let shareView = LKStatusShareView(status: s)
        shareView.show()
    }
}

extension UserDetailViewController: StatusMoreViewDelegate {
    func statusMoreAction(shield: Int, indexPath: IndexPath?) {
        guard let `indexPath` = indexPath else { return }
        shieldStatus(at: indexPath)
    }
    
    func statusMoreAction(report: Int, indexPath: IndexPath?) {
        guard let `indexPath` = indexPath else { return }
        reportStatus(at: indexPath)
    }
    
    func statusMoreAction(delete: Int, indexPath: IndexPath?) {
        guard let `indexPath` = indexPath else { return }
        removeStatus(at: indexPath)
    }
    
    private func removeStatus(at indexPath: IndexPath) {
        let status = self.data[indexPath.row]
        let req = StatusApiRequest.deleteStatus(id: status.id)
        SLUtil.showLoading(to: self.view)
        ApiManager.shared.request(request: req, success: { (data) in
            SLUtil.hideLoading(from: self.view)
            SLUtil.showMessage("删除成功".localized)
            self.data.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .none)
            self.moreActionView.dismiss()
        }) { (error) in
            SLUtil.hideLoading(from: self.view)
            SLUtil.showMessage(error)
        }
    }
    
    private func shieldStatus(at indexPath: IndexPath) {
        let status = self.data[indexPath.row]
        let req = StatusApiRequest.shield(id: status.id, shield: true)
        SLUtil.showLoading(to: self.view)
        ApiManager.shared.request(request: req, success: { (data) in
            SLUtil.hideLoading(from: self.view)
            SLUtil.showMessage("屏蔽成功".localized)
            self.data.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .none)
            self.moreActionView.dismiss()
        }) { (error) in
            SLUtil.hideLoading(from: self.view)
            SLUtil.showMessage(error)
        }
    }
    
    private func reportStatus(at indexPath: IndexPath) {
        self.moreActionView.dismiss()
        let reportView = LKReportView()
        reportView.show()
        
        reportView.clickHandle = { [weak self] content in
            guard let `self` = self else { return }
            self.reportStatus(at: indexPath, content: content)
        }
    }
    
    private func reportStatus(at indexPath: IndexPath, content: String) {
        
        let status = self.data[indexPath.row]
        let req = AppApiRequest.report(conetnt: content, ref_id: status.id, type: "status")
        
        SLUtil.showLoading(to: view)
        ApiManager.shared.request(request: req, success: { (data) in
            self.data.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .none)
            SLUtil.hideLoading(from: self.view)
        }) { (error) in
            SLUtil.hideLoading(from: self.view)
            SLUtil.showMessage(error)
        }
    }
}

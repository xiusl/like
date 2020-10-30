//
//  HomeViewController.swift
//  Like
//
//  Created by duoji on 2020/10/30.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    public var articles: PublishSubject<[Article]> = PublishSubject()
    private let disposeBag = DisposeBag()
    
    private func setupBinding() {
        articles.bind(to: tableView.rx.items(cellIdentifier: ArticleViewCell.identifier, cellType: ArticleViewCell.self)) { (row, article, cell) in
        }.disposed(by: disposeBag)
    }

    lazy var tableView: UITableView = {
        var height = ScreenHeight-TopSafeHeight-TabbarHeight
        if StatusBarHeight > 20 {
            height -= BottomSafeHeight
        }
        let frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: height)
        let tableView = UITableView(frame: frame, style: .plain)
        tableView.separatorStyle = .none
        return tableView
    }()

}

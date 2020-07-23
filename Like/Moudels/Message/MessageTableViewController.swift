//
//  MessageTableViewController.swift
//  Like
//
//  Created by tmt on 2020/7/23.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit
import LeanCloud

class MessageTableViewController: UIViewController {

    var conversations: [IMConversation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        // Do any additional setup after loading the view.
        if let conversations = Client.storedConversations {
            self.conversations = conversations
            Client.storedConversations = nil
        }
        
        
    }
    

    lazy var tableView: UITableView = {
        var height = ScreenHeight-TopSafeHeight-TabbarHeight
        if StatusBarHeight > 20 {
            height -= BottomSafeHeight
        }
        let frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: height)
        let tableView = UITableView(frame: frame, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()

}

extension MessageTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

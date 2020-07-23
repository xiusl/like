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

    let uuid = UUID().uuidString
    var conversations: [IMConversation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .cF2F4F8
        view.addSubview(tableView)
        // Do any additional setup after loading the view.
        if let conversations = Client.storedConversations {
            self.conversations = conversations
            Client.storedConversations = nil
        }
        
        queryRecentNormalConversations()
        
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
        tableView.backgroundColor = .cF2F4F8
        return tableView
    }()

}

extension MessageTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ConversationListCell()
        let conversation = conversations[indexPath.row]
        
        cell.setupText(conversation.name ?? "会话")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let conversation = conversations[indexPath.row]
        let vc = ChatViewController()
        vc.conversation = conversation
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension MessageTableViewController {
    func queryRecentNormalConversations() {
        do {
            
            let transientKey: String = "tr"
            let transientFalseQuery = Client.current.conversationQuery
            try transientFalseQuery.where(transientKey, .equalTo(false))
            let transientNotExistQuery = Client.current.conversationQuery
            try transientNotExistQuery.where(transientKey, .notExisted)
            
            let systemKey: String = "sys"
            let systemFalseQuery = Client.current.conversationQuery
            try systemFalseQuery.where(systemKey, .equalTo(false))
            let systemNotExistQuery = Client.current.conversationQuery
            try systemNotExistQuery.where(systemKey, .notExisted)
            
            guard
                let notTransientQuery = try transientFalseQuery.or(transientNotExistQuery),
                let notSystemQuery = try systemFalseQuery.or(systemNotExistQuery),
                let query = try notTransientQuery.and(notSystemQuery) else
            {
                fatalError()
            }
            
            try query.where("m", .containedIn([Client.current.ID]))
            query.options = [.containLastMessage]
            query.limit = 20
            
            try query.findConversations { [weak self] (result) in
                Client.specificAssertion
                guard let self = self else {
                    return
                }
                switch result {
                case .success(value: let conversations):
                    mainQueueExecuting {
                        self.conversations = conversations
                        self.tableView.reloadData()
                    }
                case .failure(error: let error):
                    UIAlertController.show(error: error, controller: self)
                }
            }
        } catch {
            UIAlertController.show(error: error, controller: self)
        }
    }
}

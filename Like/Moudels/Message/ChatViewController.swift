//
//  ChatViewController.swift
//  Like
//
//  Created by tmt on 2020/7/23.
//  Copyright © 2020 likeeee. All rights reserved.
//

import UIKit
import LeanCloud

class ChatViewController: UIViewController {
    public var userId: String = ""
    
    
    let uuid = UUID().uuidString
    var conversation: IMConversation!
    var messages: [IMMessage] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWith(color: .white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage(color: .cF2F4F8)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(tableView)
        view.addSubview(textView)
        view.addSubview(sendButton)
        
        self.navigationItem.title = self.conversation.name
       
        
        self.queryMessageHistory(isFirst: true) { (_) in
            
        }
        
        self.addObserverForClient()
    }
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.frame = CGRect(x: 12, y: 20, width: ScreenWidth-24-60, height: 30)
        textView.backgroundColor = .cF2F4F8
        return textView
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: ScreenWidth-12-60, y: 18, width: 58, height: 34)
        button.setTitle("发送", for: .normal)
        button.setTitleColor(.theme, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        return button
    }()
    
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
    
    func autoSendMessage() {
        do {
            let textMessage = IMTextMessage(text: "Jerry，起床了！")
            try conversation.send(message: textMessage) { (result) in
                switch result {
                case .success:
                    break
                case .failure(error: let error):
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    @objc
    private func sendButtonAction() {
        guard let text = textView.text else { return }
        
        let textMessage = IMTextMessage(text: text)
        send(message: textMessage)
    }
}

extension ChatViewController {
    func send(message: IMMessage) {
        let pushData: [String: Any] = [
            "alert": "您有一条未读的消息",
            "category": "消息",
            "badge": 1,
            "sound": "message.mp3",
            "custom-key": ""
        ]
        do {
            try self.conversation.send(message: message, options: [.isAutoDeliveringWhenOffline], pushData: pushData, completion: { [weak self] (result) in
                Client.specificAssertion
                guard let self = self else {
                    return
                }
                switch result {
                case .success:
                    mainQueueExecuting {
                        self.messages.append(message)
                        let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                        self.tableView.insertRows(at: [indexPath], with: .bottom)
                        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                        self.textView.text = ""
                    }
                case .failure(error: let error):
                    UIAlertController.show(error: error, controller: self)
                }
            })
        } catch {
            UIAlertController.show(error: error, controller: self)
        }
    }
}

//
extension ChatViewController {
    func queryMessageHistory(isFirst: Bool, completion: @escaping (Result<Bool, Error>) -> Void) {
        var start: IMConversation.MessageQueryEndpoint? = nil
        if let oldMessage = self.messages.first {
            start = IMConversation.MessageQueryEndpoint(
                messageID: oldMessage.ID,
                sentTimestamp: oldMessage.sentTimestamp,
                isClosed: true
            )
        }
        do {
            try conversation.queryMessage(
                start: start,
                policy: isFirst ? .onlyNetwork : .default)
            { [weak self] (result) in
                Client.specificAssertion
                guard let self = self else {
                    return
                }
                switch result {
                case .success(value: let messageResults):
                    if isFirst {
                        self.conversation.read()
                        if messageResults.isEmpty {
                            self.send(message: IMTextMessage(text: "Hello."))
                        }
                    }
                    if !messageResults.isEmpty {
                        mainQueueExecuting {
                            let isOriginMessageEmpty = self.messages.isEmpty
                            if
                                let first = self.messages.first,
                                let last = messageResults.last,
                                let firstTimestamp = first.sentTimestamp,
                                let lastTimestamp = last.sentTimestamp,
                                firstTimestamp == lastTimestamp,
                                let firstMessageID = first.ID,
                                let lastMessageID = last.ID,
                                firstMessageID == lastMessageID
                            {
                                self.messages.removeFirst()
                            }
                            self.messages.insert(contentsOf: messageResults, at: 0)
                            self.tableView.reloadData()
                            self.tableView.scrollToRow(
                                at: IndexPath(row: messageResults.count - 1, section: 0),
                                at: isOriginMessageEmpty ? .bottom : .top,
                                animated: false
                            )
                        }
                    }
                    completion(.success(true))
                case .failure(error: let error):
                    UIAlertController.show(error: error, controller: self)
                    completion(.failure(error))
                }
            }
        } catch {
            UIAlertController.show(error: error, controller: self)
            completion(.failure(error))
        }
    }
    
    func refreshMessageList() {
        do {
            try self.conversation.queryMessage(policy: .onlyNetwork) { [weak self] (result) in
                Client.specificAssertion
                guard let self = self else {
                    return
                }
                switch result {
                case .success(value: let messages):
                    guard !messages.isEmpty else {
                        return
                    }
                    self.conversation.read()
                    mainQueueExecuting {
                        self.messages = messages
                        self.tableView.reloadData()
                        self.tableView.scrollToRow(
                            at: IndexPath(row: self.messages.count - 1, section: 0),
                            at: .bottom,
                            animated: true
                        )
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

extension ChatViewController {
    func addObserverForClient() {
        Client.addEventObserver(key: self.uuid) { [weak self] (client, conversation, event) in
            Client.specificAssertion
            guard let self = self, self.conversation.ID == conversation.ID else {
                return
            }
            switch event {
            case .message(event: let messageEvent):
                switch messageEvent {
                case let .received(message: message):
                    self.handleMessageReceived(message: message)
                case let .updated(updatedMessage: updatedMessage, reason: _):
                    self.handleMessageUpdated(updatedMessage: updatedMessage)
                default:
                    break
                }
            default:
                break
            }
            if conversation.isOutdated {
                self.refreshConversationData()
            }
        }
        
        Client.addSessionObserver(key: self.uuid) { [weak self] (client, event) in
            Client.specificAssertion
            guard let self = self else {
                return
            }
            switch event {
            case .sessionDidOpen:
                self.refreshMessageList()
                
            default:
                break
            }
        }
    }
    
    func handleMessageReceived(message: IMMessage) {
        self.conversation.read(message: message)
        mainQueueExecuting {
            var originBottomIndexPath: IndexPath?
            if !self.messages.isEmpty {
                originBottomIndexPath = IndexPath(row: self.messages.count - 1, section: 0)
            }
            self.messages.append(message)
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .bottom)
            if
                let bottomIndexPath = originBottomIndexPath,
                let bottomCell = self.tableView.cellForRow(at: bottomIndexPath),
                self.tableView.visibleCells.contains(bottomCell)
            {
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    func handleMessageUpdated(updatedMessage: IMMessage) {
        mainQueueExecuting {
            var indexPath: IndexPath?
            for (index, item) in self.messages.enumerated() {
                if item.ID == updatedMessage.ID, item.sentTimestamp == updatedMessage.sentTimestamp {
                    indexPath = IndexPath(row: index, section: 0)
                    self.messages[index] = updatedMessage
                    break
                }
            }
            if let indexPath = indexPath {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func refreshConversationData() {
        do {
            try conversation.refresh(completion: { (result) in
                Client.specificAssertion
                switch result {
                case .success:
                    break
                case .failure(error: let error):
                    print(error)
                }
            })
        } catch {
            print(error)
        }
    }
    
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChatMessageViewCell.create(tableView: tableView)
        
        let message = messages[indexPath.row]
        
        switch message {
        case let textMessage as IMTextMessage:
            cell.setupMessageText(textMessage.text ?? "", fromMe: message.ioType == .out)
        default:
            fatalError()
        }
            
        
        return cell
    }
}

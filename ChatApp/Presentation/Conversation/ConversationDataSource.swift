//
//  ConversationDataSource.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 19.04.2022.
//

import UIKit

final class ConversationDataSource: NSObject {
    private let tableView: UITableView
    private let frcConversationProvider: FRCProvider<DBMessage>
    private let userService: UserService
    
    init(tableView: UITableView,
         frcConversationProvider: FRCProvider<DBMessage>,
         userService: UserService) {
        self.tableView = tableView
        self.frcConversationProvider = frcConversationProvider
        self.userService = userService
        
        super.init()
        frcConversationProvider.delegate = self
    }
}

// MARK: - UITableViewDataSource

extension ConversationDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        frcConversationProvider.numberOfObjects(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationMessageTableViewCell.cellIdentifier, for: indexPath) as? ConversationMessageTableViewCell else { return UITableViewCell() }
        let message = frcConversationProvider.getObject(indexPath: indexPath)
        
        let isIncoming = message.senderId != userService.userId
        let name = isIncoming ? message.senderName : nil
        
        cell.message = message.content
        cell.date = Date(timeIntervalSince1970: message.created)
        cell.isIncoming = isIncoming
        cell.name = name
        
        return cell
    }
}

// MARK: - FRCProviderDelegate
extension ConversationDataSource: FRCProviderDelegate {
    func didChangeObjects(changes: [ObjectsChanges]) {
        tableView.performBatchUpdates {
            tableView.beginUpdates()
            for change in changes {
                switch change {
                case .insert(let indexPath):
                    tableView.insertRows(at: [indexPath], with: .automatic)
                default: break
                }
            }
            tableView.endUpdates()
            tableView.scrollToBottom(animated: false)
        }
    }
}

//
//  ConversationsDataSource.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 15.04.2022.
//

import UIKit

protocol ConversationsDataSourceDelegate: AnyObject {
    func didDeleteChannel(id: String)
}

final class ConversationsDataSource: NSObject {
    private let tableView: UITableView
    private let frcConversationsProvider: FRCProvider<DBChannel>
    weak var delegate: ConversationsDataSourceDelegate?
    
    init(tableView: UITableView, frcConversationsProvider: FRCProvider<DBChannel>) {
        self.tableView = tableView
        self.frcConversationsProvider = frcConversationsProvider
        super.init()
        frcConversationsProvider.delegate = self
    }
}
    
// MARK: - UITableViewDataSource

extension ConversationsDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        frcConversationsProvider.numberOfObjects(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.cellIdentifier, for: indexPath) as? ConversationTableViewCell else { return UITableViewCell() }
        
        let channel = frcConversationsProvider.getObject(indexPath: indexPath)
        
        cell.accessoryType = .disclosureIndicator

        cell.name = channel.name
        cell.message = channel.lastMessage
        cell.date = channel.lastActivity

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let channel = frcConversationsProvider.getObject(indexPath: indexPath)
            guard let channelID = channel.identifier else { return }
            delegate?.didDeleteChannel(id: channelID)
        }
    }
}

// MARK: - FRCConversationsProviderDelegate
extension ConversationsDataSource: FRCProviderDelegate {
    func didChangeObjects(changes: [ObjectsChanges]) {
        tableView.beginUpdates()
        for change in changes {
            switch change {
            case .delete(let indexPath):
                tableView.deleteRows(at: [indexPath], with: .automatic)
            case .insert(let indexPath):
                tableView.insertRows(at: [indexPath], with: .automatic)
            case .move(at: let indexParth, to: let newIndexPath):
                tableView.deleteRows(at: [indexParth], with: .automatic)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            case .update(let indexPath):
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        tableView.endUpdates()
    }
}

// MARK: - Public Interface
extension ConversationsDataSource {
    func getChannel(indexPath: IndexPath) -> DBChannel {
        return frcConversationsProvider.getObject(indexPath: indexPath)
    }
}

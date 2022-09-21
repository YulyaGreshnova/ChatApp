//
//  ConversationAssembly.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 13.05.2022.
//

import UIKit
import CoreData

final class ConversationAssembly {
    func buildViewController(conversationInput: ConversationInput) -> UIViewController {
        let fetchRequest: NSFetchRequest<DBMessage> = DBMessage.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "channel.identifier == %@", conversationInput.id)
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let frcProvider = FRCProvider(coreDataStack: CoreDataStack.shared,
                                      fetchRequest: fetchRequest,
                                      cacheName: "Messages")
        
        let messageProvider = MessageProvider(channelId: conversationInput.id,
                                              storageService: ChatCoreDataStorageService(coreDataStack: CoreDataStack.shared))
        let viewController = ConversationViewController(
            conversationTitle: conversationInput.title,
            messageProvider: messageProvider,
            frcProvider: frcProvider,
            userService: UserService.shared)
        
        return viewController
    }
}

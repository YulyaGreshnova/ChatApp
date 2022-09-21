//
//  ConversationsAssembly.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 13.05.2022.
//

import UIKit
import CoreData

final class ConversationsAssembly {
    func buildViewController() -> UIViewController {
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "lastActivity", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 25
        let frc = FRCProvider(coreDataStack: CoreDataStack.shared,
                              fetchRequest: fetchRequest,
                              cacheName: "Channels")
        let channelService = ChannelsService()
        let storageService = ChatCoreDataStorageService(coreDataStack: CoreDataStack.shared)
        let channelsProvider = ChannelsProvider(channelService: channelService,
                                                storageService: storageService)
    
        let viewController = ConversationsListViewController(
            frcProvider: frc,
            channelProvider: channelsProvider)
        
        let router = ConversationsRouter(viewController: viewController)
        viewController.router = router
        return viewController
    }
}

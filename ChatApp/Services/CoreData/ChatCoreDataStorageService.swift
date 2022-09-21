//
//  ChannelsStorageService.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 02.04.2022.
//

import CoreData
import UIKit
import Foundation

protocol IChatStorage {
    func saveChannels(channels: [Channel], completion: @escaping(Bool) -> Void)
    func saveMessages(messages: [Message], channelID: String, completion: @escaping(Bool) -> Void)
    func deleteChannel(channel: Channel, completion: @escaping(Bool) -> Void)
}

final class ChatCoreDataStorageService: IChatStorage {
     private let coreDataStack: ICoreDataStack

     init(coreDataStack: ICoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func saveChannels(channels: [Channel], completion: @escaping(Bool) -> Void) {
        let context = coreDataStack.backgroundContext
        
        context.perform {
            channels.forEach {
                if let entity = NSEntityDescription.entity(forEntityName: "DBChannel", in: context) {
                    let channelModel = DBChannel(entity: entity,
                                                 insertInto: context)
                    channelModel.name = $0.name
                    channelModel.identifier = $0.identifier
                    channelModel.lastActivity = $0.lastActivity
                    channelModel.lastMessage = $0.lastMessage
                }
            }
            do {
                try context.save()
                completion(true)
            } catch {
                completion(false)
            }
        }
    }
    
    func saveMessages(messages: [Message], channelID: String, completion: @escaping(Bool) -> Void) {
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", channelID)
       
        let context = coreDataStack.backgroundContext
        context.perform {
            guard let entity = NSEntityDescription.entity(forEntityName: "DBMessage", in: context),
                  let dbChannel = try? context.fetch(fetchRequest).first else {
                completion(false)
                return
            }
            
            for message in messages {
                let dbM = DBMessage(entity: entity, insertInto: context)
                dbM.content = message.content
                dbM.created = message.created.timeIntervalSince1970
                dbM.senderId = message.senderID
                dbM.senderName = message.senderName
                dbM.channel = dbChannel
            }
            
            do {
                try context.save()
                completion(true)
            } catch {
                completion(false)
            }
        }
    }
    
    func deleteChannel(channel: Channel, completion: @escaping(Bool) -> Void) {
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", channel.identifier)
        let context = coreDataStack.backgroundContext
        do {
            let dbChannels = try context.fetch(fetchRequest)
            for object in dbChannels {
                context.delete(object)
            }
            try? context.save()
            completion(true)
        } catch {
            completion(false)
        }
    }
}

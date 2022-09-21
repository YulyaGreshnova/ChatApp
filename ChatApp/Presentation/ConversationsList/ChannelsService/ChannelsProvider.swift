//
//  ChannelsProvider.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 02.04.2022.
//

import Foundation
import CoreData

protocol IChannelsProvider {
    func startListeningChannels()
    func stopListeningChannels()
    func createNewChannel(name: String, completion: @escaping (Bool) -> Void)
    func deleteChannel(id: String, completion: @escaping (Bool) -> Void)
}

final class ChannelsProvider: IChannelsProvider {
    private var channelService: IChannelsService
    private let storageService: IChatStorage
    
    init(channelService: IChannelsService, storageService: IChatStorage) {
        self.storageService = storageService
        self.channelService = channelService
        self.channelService.delegate = self
    }
    
    func startListeningChannels() {
        channelService.startListeningChannels()
    }
   
    func stopListeningChannels() {
        channelService.stopListeningChannels()
    }
    
    func createNewChannel(name: String, completion: @escaping (Bool) -> Void) {
        channelService.createNewChannel(name: name, completion: completion)
    }
    
    func deleteChannel(id: String, completion: @escaping (Bool) -> Void) {
        channelService.deleteChannel(id: id, completion: completion)
    }
}

// MARK: - ChannelsServiceDelegate
extension ChannelsProvider: ChannelsServiceDelegate {
    func didAddNewChannel(channel: Channel) {
        storageService.saveChannels(channels: [channel]) { isSuccess in
            if isSuccess {
                let messageForLog = "Новый канал  - \" \(channel.name)\" успешно сохранен в CoreData"
                ConsoleLogger.log(message: messageForLog)
            }
        }
    }
    
    func didDeleteChannel(channel: Channel) {
        storageService.deleteChannel(channel: channel) { isSuccess in
            if isSuccess {
                let messageForLog = "канал  - \"\(channel.name)\" удален из CoreData"
                ConsoleLogger.log(message: messageForLog)
            }
        }
    }
    
    func didUpdateChannel(channel: Channel) {
        storageService.saveChannels(channels: [channel]) { isSuccess in
            if isSuccess {
                let messageForLog = "Канал \" \(channel.name) \" успешно обновлен из CoreData"
                ConsoleLogger.log(message: messageForLog)
            }
        }
    }
    
    func didLoadChannels(channels: [Channel]) {
        self.storageService.saveChannels(channels: channels) { isSuccess in
            if isSuccess {
                ConsoleLogger.log(message: "\(channels.count) - канала(ов) успешно сохранены в CoreData")
            }
        }
    }
}

//
//  MessageProvider.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 05.04.2022.
//

import Foundation
import CoreData

protocol IMessageProvider {
    func startListeningMessages()
    func createNewMessage(text: String, completion: @escaping (Bool) -> Void)
}

class MessageProvider: IMessageProvider {
    private let channelId: String
    private var messageService: IMessageService
    private let storageService: IChatStorage
    
    init(channelId: String, storageService: IChatStorage) {
        self.channelId = channelId
        self.storageService = storageService
        self.messageService = MessageService(channelId: channelId)
        messageService.delegate = self
    }
    
    func startListeningMessages() {
        messageService.startListeningMessages()
    }
    
    func createNewMessage(text: String, completion: @escaping (Bool) -> Void) {
        messageService.createNewMessage(text: text, completion: completion)
    }
}

// MARK: - MessageServiceDelegate
extension MessageProvider: MessagesServiceDelegate {
    func didAddNewMessage(message: Message) {
        storageService.saveMessages(messages: [message], channelID: channelId) { isSuccess in
            if isSuccess {
                let messageForLog = "Новое сообщение - \" \(message.content) \" успешно сохранено"
                ConsoleLogger.log(message: messageForLog)
            }
        }
    }
    
    func didLoadMessages(messages: [Message]) {
        storageService.saveMessages(messages: messages, channelID: channelId) { isSuccess in
            if isSuccess {
                let messageForLog = "\(messages.count) сообщений успешно сохранено"
                ConsoleLogger.log(message: messageForLog)
            }
        }
    }
}

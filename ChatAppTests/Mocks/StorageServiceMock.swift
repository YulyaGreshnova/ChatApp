//
//  StorageServiceMock.swift
//  ChatAppTests
//
//  Created by Yulya Greshnova on 16.05.2022.
//

import Foundation
@testable import ChatApp

final class StorageServiceMock: IChatStorage {
    var invokedSaveChannels = false
    var invokedSaveChannelsCount = 0
    var invokedSaveChannelsParameters: (channels: [Channel], Void)?
    var invokedSaveChannelsParametersList = [(channels: [Channel], Void)]()
    var stubbedSaveChannelsCompletionResult: (Bool, Void)?

    func saveChannels(channels: [Channel], completion: @escaping(Bool) -> Void) {
        invokedSaveChannels = true
        invokedSaveChannelsCount += 1
        invokedSaveChannelsParameters = (channels, ())
        invokedSaveChannelsParametersList.append((channels, ()))
        if let result = stubbedSaveChannelsCompletionResult {
            completion(result.0)
        }
    }

    var invokedSaveMessages = false
    var invokedSaveMessagesCount = 0
    var invokedSaveMessagesParameters: (messages: [Message], channelID: String)?
    var invokedSaveMessagesParametersList = [(messages: [Message], channelID: String)]()
    var stubbedSaveMessagesCompletionResult: (Bool, Void)?

    func saveMessages(messages: [Message], channelID: String, completion: @escaping(Bool) -> Void) {
        invokedSaveMessages = true
        invokedSaveMessagesCount += 1
        invokedSaveMessagesParameters = (messages, channelID)
        invokedSaveMessagesParametersList.append((messages, channelID))
        if let result = stubbedSaveMessagesCompletionResult {
            completion(result.0)
        }
    }

    var invokedDeleteChannel = false
    var invokedDeleteChannelCount = 0
    var invokedDeleteChannelParameters: (channel: Channel, Void)?
    var invokedDeleteChannelParametersList = [(channel: Channel, Void)]()
    var stubbedDeleteChannelCompletionResult: (Bool, Void)?

    func deleteChannel(channel: Channel, completion: @escaping(Bool) -> Void) {
        invokedDeleteChannel = true
        invokedDeleteChannelCount += 1
        invokedDeleteChannelParameters = (channel, ())
        invokedDeleteChannelParametersList.append((channel, ()))
        if let result = stubbedDeleteChannelCompletionResult {
            completion(result.0)
        }
    }
}

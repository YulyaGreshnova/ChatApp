//
//  ConversationServiceTest.swift
//  ConversationServiceTest
//
//  Created by Yulya Greshnova on 16.05.2022.
//

import XCTest

@testable import ChatApp

class ConversationServiceTest: XCTestCase {
    
    private var storageService: StorageServiceMock!
    private var messagesMock: MessagesMock!
    
    override func setUp() {
        super.setUp()
        storageService = StorageServiceMock()
        messagesMock = MessagesMock()
    }
    
    func testSaveMessagesCalled() {
        // Arrange
        let messageProvider = build()
        
        // Act
        messageProvider.didLoadMessages(messages: messagesMock.messages)
        
        // Assert
        XCTAssertTrue(storageService.invokedSaveMessages)
        XCTAssertEqual(storageService.invokedSaveMessagesCount, 1)
        XCTAssertEqual(storageService.invokedSaveMessagesParameters?.channelID, "testChannelId")
        XCTAssertEqual(storageService.invokedSaveMessagesParameters?.messages, messagesMock.messages)

    }
    
    private func build() -> MessageProvider {
        return MessageProvider(channelId: "testChannelId", storageService: storageService)
    }
}

// для тестирования
extension Message: Equatable {
    public static func ==(lhs: Message, rhs: Message) -> Bool {
        return lhs.content == rhs.content && lhs.created == rhs.created
    }
}

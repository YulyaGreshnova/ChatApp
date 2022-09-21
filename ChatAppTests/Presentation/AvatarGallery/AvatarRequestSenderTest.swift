//
//  AvatarRequestSenderTest.swift
//  ChatAppTests
//
//  Created by Yulya Greshnova on 16.05.2022.
//

import XCTest

@testable import ChatApp

class AvatarRequestSenderTest: XCTestCase {
    
    private var requestSenderMock: RequestSenderMock<AvatarImageParser>!
    
    override func setUp() {
        super.setUp()
        requestSenderMock = RequestSenderMock<AvatarImageParser>()
    }
    
    func testSendCalled() {
        // Arrange
        let avatarRequestSender = AvatarRequestSender(requestSender: requestSenderMock)
        let page = 3
        let perPage = 10
        
        // Act
        avatarRequestSender.loadImages(page: page,
                                       perPage: perPage) { (_) in }
        
        // Assert
        XCTAssertTrue(requestSenderMock.invokedSend)
        XCTAssertEqual(requestSenderMock.invokedSendCount, 1)
        XCTAssertNotNil(requestSenderMock.invokedSendParameters?.config.request.urlRequest)
    }
}

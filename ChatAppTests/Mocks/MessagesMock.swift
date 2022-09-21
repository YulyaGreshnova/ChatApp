//
//  MessagesMock.swift
//  ChatAppTests
//
//  Created by Yulya Greshnova on 16.05.2022.
//

import Foundation
@testable import ChatApp

class MessagesMock {
    var messages = [
        Message(content: "Hello",
                created: Date(),
                senderID: "Me",
                senderName: "Bob")
    ]
}

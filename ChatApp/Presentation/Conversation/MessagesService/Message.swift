//
//  Message.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 26.03.2022.
//

import Foundation
import Firebase

struct Message: Codable {
    let content: String
    let created: Date
    let senderID: String
    let senderName: String
    
    init(content: String, created: Date, senderID: String, senderName: String) {
        self.content = content
        self.created = created
        self.senderID = senderID
        self.senderName = senderName
    }
    
    init?(dict: [String: Any]) {
        guard let messageContent = dict["content"] as? String,
              let date = dict["created"] as? Timestamp,
              let id = dict["senderId"] as? String,
              let name = dict["senderName"] as? String
        else { return nil }
        
        self.content = messageContent
        self.created = date.dateValue()
        self.senderID = id
        self.senderName = name
    }
}

extension Message {
    var toDict: [String: Any] {
        return ["content": content,
                 "created": Timestamp(date: created),
                 "senderId": senderID,
                 "senderName": senderName]
    }
}

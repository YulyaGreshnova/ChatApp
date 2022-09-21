//
//  Channel.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 25.03.2022.
//

import Foundation
import Firebase

struct Channel: Codable, Equatable {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
    
    init(identifier: String,
         name: String,
         lastMessage: String? = nil,
         lastActivity: Date? = nil) {
        self.identifier = identifier
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
    }
    
    init?(dict: [String: Any], id: String) {
        guard let channelName = dict["name"] as? String else { return nil }
        
        self.identifier = id
        self.name = channelName
        
        if let lastMessage = dict["lastMessage"] as? String {
            self.lastMessage = lastMessage
        } else {
            self.lastMessage = nil
        }
        
        if let lastActivity = dict["lastActivity"] as? Timestamp {
            self.lastActivity = lastActivity.dateValue()
        } else {
            self.lastActivity = nil
        }
    }
}

extension Channel {
    var toDict: [String: Any] {
        var dict: [String: Any] = ["identifier": identifier,
                                   "name": name,
                                   "lastMessage": lastMessage as Any]
        if let date = lastActivity {
            dict["lastActivity"] = Timestamp(date: date)
        }
        return dict
    }
}
